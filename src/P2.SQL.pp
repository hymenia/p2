unit P2.SQL;

interface
uses
	Classes, SyncObjs,
	SQLDB;

type
	TQuery = class(TSQLQuery)
	public
		constructor Create(AOwner: TComponent); override;
		destructor Destroy(); override;

		procedure Go();
	end;
	TTransaction = class(TSQLTransaction)
	public
		constructor Create(AOwner: TComponent); override;
		destructor Destroy(); override;

		function CreateQuery(Query: String = ''): TQuery;
		procedure ExecSQL(Query: String);
	end;
	TConnection = record
		Connection: TSQLConnector;
		Transaction: TTransaction;
		InUse: Boolean;
	end;
	TPool = class
	private
		Lock: TCriticalSection;
		Available: TEvent;
		Connections: Array of TConnection;
	public
		constructor Create(Pools: Integer; Database: String; Host: String; User: String; Password: String);
		destructor Destroy(); override;

		function Acquire(): TTransaction;
		procedure Release(Transaction: TTransaction);
	end;

var
	Pool: TPool;

function Init(): Boolean;

implementation
uses
	SysUtils,
	PQConnection,
	P2.Config;

constructor TQuery.Create(AOwner: TComponent);
begin
	Inherited;
end;

destructor TQuery.Destroy();
begin
	Inherited;
end;

procedure TQuery.Go();
begin
	Self.Open();
	if Self.Active then
	begin
		while Not(Self.EOF) do
		begin
			Self.Next();
		end;
	end;
	Self.Close();
end;

constructor TTransaction.Create(AOwner: TComponent);
begin
	Inherited;
end;

destructor TTransaction.Destroy();
begin
	Inherited;
end;

function TTransaction.CreateQuery(Query: String): TQuery;
var
	Q: TQuery;
begin
	Q := TQuery.Create(Nil);

	Q.SQLConnection := Self.SQLConnection;
	Q.SQLTransaction := Self;
	Q.UniDirectional := True;

	Q.SQL.Text := Query;

	CreateQuery := Q;
end;

procedure TTransaction.ExecSQL(Query: String);
var
	Q: TSQLQuery;
begin
	Q := Self.CreateQuery();

	Q.SQL.Text := Query;
	Q.ExecSQL();

	Q.Free();
end;

constructor TPool.Create(Pools: Integer; Database: String; Host: String; User: String; Password: String);
var
	I: Integer;
	C: TSQLConnector;
begin
	Self.Lock := TCriticalSection.Create();
	Self.Available := TEvent.Create(Nil, False, False, '');

	SetLength(Self.Connections, Pools);

	for I := Low(Self.Connections) to High(Self.Connections) do
	begin
		C := TSQLConnector.Create(Nil);
		C.ConnectorType := 'PostgreSQL';

		try
			C.DatabaseName := Database;
			C.HostName := Host;
			C.UserName := User;
			C.Password := Password;

			C.Connected := True;

			WriteLn('SQL: Pool ' + IntToStr(I) + ': Ready');
		except
			C.Free();
			raise;
		end;

		Self.Connections[I].Connection := C;
		Self.Connections[I].InUse := False;
	end;
end;

destructor TPool.Destroy();
var
	I: Integer;
begin
	for I := Low(Self.Connections) to High(Self.Connections) do
	begin
		Self.Connections[I].Connection.Free();
	end;

	Self.Available.Free();
	Self.Lock.Free();

	Inherited;
end;

function TPool.Acquire(): TTransaction;
var
	I: Integer;
	T: TTransaction;
begin
	Acquire := Nil;

	while True do
	begin
		Self.Lock.Acquire();
		try
			for I := Low(Self.Connections) to High(Self.Connections) do
				if Not(Self.Connections[I].InUse) then
				begin
					Self.Connections[I].InUse := True;
					T := TTransaction.Create(Nil);

					try
						T.SQLConnection := Self.Connections[I].Connection;
						T.StartTransaction();

						Self.Connections[I].Transaction := T;
						Self.Connections[I].Connection.Transaction := T;

						Exit(T);
					except
						T.Free();
						Self.Connections[I].InUse := False;
						raise;
					end;
				end;
		finally
			Self.Lock.Release();
		end;

		Self.Available.WaitFor(INFINITE); // TODO: Maybe add timeout?
	end;
end;

procedure TPool.Release(Transaction: TTransaction);
var
	I: Integer;
begin
	Self.Lock.Acquire();
	try
		for I := Low(Self.Connections) to High(Self.Connections) do
			if Self.Connections[I].InUse and (Self.Connections[I].Transaction = Transaction) then
			begin
				Transaction.EndTransaction(); // FIXME: This could fail

				Self.Connections[I].Connection.Transaction := Nil;
				Self.Connections[I].Transaction := Nil;

				Transaction.Free();

				Self.Connections[I].InUse := False;
				Self.Available.SetEvent();
				Exit();
			end;
	finally
		Self.Lock.Release();
	end;
end;

function Init(): Boolean;
begin
	Init := True;

	try
		Pool := TPool.Create(P2.Config.Table.SQLPools, P2.Config.Table.SQLDatabase, P2.Config.Table.SQLHost, P2.Config.Table.SQLUser, P2.Config.Table.SQLPassword);
	except
		on E: Exception do
		begin
			WriteLn('SQL: Error: ' + E.Message);
			Exit(False);
		end;
	end;
end;

procedure EndSQL();
begin
	Pool.Free();
end;

finalization
	EndSQL;

end.
