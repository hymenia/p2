unit P2.HTTP;

interface
uses
	HTTPDefs;

type
	TMIME = record
		Extension: String;
		MIMEType: String;
	end;

var
	MIMETypes: Array of TMIME;

function Init(): Boolean;
procedure Run();
function SetContent(Res: TResponse; Path: String): Boolean;
procedure SetStatus(Res: TResponse; Code: Integer);
function StatusText(Code: Integer): String;

implementation
uses
	Classes, SysUtils, Types,
	P2.Application, P2.Config, P2.HTTP.Router;

const
	C100Codes: Array[100..101] of String = (
		'Continue',
		'Switching Protocols'
	);
	C200Codes: Array[200..206] of String = (
		'OK',
		'Created',
		'Accepted',
		'Non-Authoritative Information',
		'No Content',
		'Reset Content',
		'Partial Content'
	);
	C300Codes: Array[300..308] of String = (
		'Multiple Choices',
		'Moved Permanently',
		'Found',
		'See Other',
		'Not Modified',
		'Use Proxy',
		'306',
		'Temporary Redirect',
		'Permanent Redirect'
	);
	C400Codes: Array[400..426] of String = (
		'Bad Request',
		'Unauthorized',
		'Payment Required',
		'Forbidden',
		'Not Found',
		'Method Not Allowed',
		'Not Acceptable',
		'Proxy Authentication Required',
		'Request Timeout',
		'Conflict',
		'Gone',
		'Length Required',
		'Precondition Failed',
		'Content Too Large',
		'URI Too Long',
		'Unsupported Media Type',
		'Range Not Satisiable',
		'Expectation Failed',
		'I''m a Teapot',
		'419',
		'420',
		'Misdirected Request',
		'Unprocessable Content',
		'423',
		'424',
		'425',
		'Upgrade Required'
	);
	C500Codes: Array[500..505] of String = (
		'Internal Server Error',
		'Not Implemented',
		'Bad Gateway',
		'Service Unavailable',
		'Gateway Timeout',
		'HTTP Version Not Supported'
	);

function Init(): Boolean;
var
	F: TextFile;
	S: String;
	Args: TStringDynArray;
	I: Integer;
	C: Integer;
begin
	Init := True;
	C := 0;

	try
		AssignFile(F, P2.Config.Table.WebMIMETypes);
		Reset(F);

		while Not(EOF(F)) do
		begin
			ReadLn(F, S);
			if S.StartsWith('#') then Continue;

			Args := S.Split([' ', #9], TStringSplitOptions.ExcludeEmpty);
			if Length(Args) > 1 then
			begin
				for I := 1 to High(Args) do
				begin
					SetLength(MIMETypes, C + 1);
					MIMETypes[C].Extension := '.' + Args[I];
					MIMETypes[C].MIMEType := Args[0];
					C := C + 1;
				end;
			end;
		end;

		CloseFile(F);
	except
		WriteLn('HTTP: ' + P2.Config.Table.WebMIMETypes + ': Not found');
		Exit(False);
	end;

	P2.HTTP.Router.Init();
end;

procedure Run();
begin
	Application.Port := P2.Config.Table.WebPort;
	Application.Threaded := True;
	Application.Initialize();
	Application.Run();
end;

function SetContent(Res: TResponse; Path: String): Boolean;
var
	I: Integer;
begin
	SetContent := True;

	try
		Res.ContentStream := TFileStream.Create(P2.Config.Table.WebRoot + '/' + Path, fmOpenRead or fmShareDenyNone);
		Res.FreeContentStream := True;

		Res.ContentType := 'application/octet-stream';
		for I := Low(MIMETypes) to High(MIMETypes) do
		begin
			if Path.EndsWith(MIMETypes[I].Extension) then
			begin
				Res.ContentType := MIMETypes[I].MIMEType;
				Break;
			end;
		end;
	except
		Exit(False);
	end;
end;

procedure SetStatus(Res: TResponse; Code: Integer);
begin
	Res.Code := Code;
	Res.CodeText := StatusText(Code);
end;

function StatusText(Code: Integer): String;
begin
	StatusText := '';

	if (Low(C100Codes) <= Code) and (Code <= High(C100Codes)) then StatusText := C100Codes[Code];
	if (Low(C200Codes) <= Code) and (Code <= High(C200Codes)) then StatusText := C200Codes[Code];
	if (Low(C300Codes) <= Code) and (Code <= High(C300Codes)) then StatusText := C300Codes[Code];
	if (Low(C400Codes) <= Code) and (Code <= High(C400Codes)) then StatusText := C400Codes[Code];
	if (Low(C500Codes) <= Code) and (Code <= High(C500Codes)) then StatusText := C500Codes[Code];
end;

end.
