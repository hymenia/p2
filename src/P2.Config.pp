unit P2.Config;

interface
uses
	INIFiles;

type
	TTable = class
	private
		INI: TINIFile;

	public
		SQLPools: Integer;
		SQLDatabase: String;
		SQLHost: String;
		SQLUser: String;
		SQLPassword: String;

		WebHost: String;
		WebPort: Integer;
		WebRoot: String;
		WebMIMETypes: String;

		AltchaAlgorithm: String;
		AltchaCost: Integer;
		AltchaSecret: String;

		constructor Create(Path: String);
		destructor Destroy(); override;
	end;

var
	Table: TTable;

function Init(Path: String = 'config/config.ini'): Boolean;

implementation
uses
	SysUtils;

constructor TTable.Create(Path: String);
begin
	Self.INI := TINIFile.Create(Path);

	Self.SQLPools := Self.INI.ReadInteger('sql', 'pools', 16);
	Self.SQLDatabase := Self.INI.ReadString('sql', 'database', 'p2');
	Self.SQLHost := Self.INI.ReadString('sql', 'host', '127.0.0.1');
	Self.SQLUser := Self.INI.ReadString('sql', 'user', 'p2');
	Self.SQLPassword := Self.INI.ReadString('sql', 'password', 'p2');

	Self.WebHost := Self.INI.ReadString('web', 'host', 'hymenia.com');
	Self.WebPort := Self.INI.ReadInteger('web', 'port', 9070);
	Self.WebRoot := Self.INI.ReadString('web', 'root', 'web');
	Self.WebMIMETypes := Self.INI.ReadString('web', 'mimetypes', 'mime.types');

	Self.AltchaAlgorithm := Self.INI.ReadString('altcha', 'algorithm', 'PBKDF2/SHA-256');
	Self.AltchaCost := Self.INI.ReadInteger('altcha', 'cost', 5000);
	Self.AltchaSecret := Self.INI.ReadString('altcha', 'secret', 'very long secret');
end;

destructor TTable.Destroy();
begin
	Self.INI.Free();

	Inherited;
end;

function Init(Path: String): Boolean;
begin
	Init := True;

	if Not(FileExists(Path)) then
	begin
		WriteLn('Config: ' + Path + ': Not found');
		Exit(False);
	end;

	Table := TTable.Create(Path);
end;

procedure EndConfig();
begin
	if Assigned(Table) then Table.Free();
end;

finalization
	EndConfig;

end.
