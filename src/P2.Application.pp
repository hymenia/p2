unit P2.Application;

interface
uses
	SysUtils,
	CustHTTPApp, CustWeb;

type
	TApplication = class(TCustomHTTPApplication)
	protected
		function InitializeWebHandler(): TWebHandler; override;
		procedure DoLog(EventType: TEventType; const Msg: String); override;
	end;

var
	Application: TApplication;

implementation
uses
	HTTPDefs;

type
	TApplicationWebHandler = class(TFPHTTPServerHandler)
	protected
		procedure EndRequest(Req: TRequest; Res: TResponse); override;
	end;

procedure TApplicationWebHandler.EndRequest(Req: TRequest; Res: TResponse);
begin
	Application.Log(etInfo, Req.Method + ' ' + Req.URL + ' ' + IntToStr(Res.Code) + ' ' + Res.CodeText);

	Inherited;
end;

function TApplication.InitializeWebHandler(): TWebHandler;
begin
	InitializeWebHandler := TApplicationWebHandler.Create(Self);
end;

procedure TApplication.DoLog(EventType: TEventType; const Msg: String);
begin
	WriteLn(FormatDateTime('yyyy-mm-dd hh:nn:ss.zzz', Now()) + ' [', EventType, '] ' + Msg);
end;

procedure BeginApplication();
begin
	Application := TApplication.Create(Nil);
end;

procedure EndApplication();
begin
	Application.Destroy();
end;

initialization
	BeginApplication;

finalization
	EndApplication;

end.
