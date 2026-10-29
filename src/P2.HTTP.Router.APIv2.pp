unit P2.HTTP.Router.APIv2;

interface

procedure Init();

implementation
uses
	FPJSON,
	HTTPDefs, HTTPRoute,
	P2.Altcha, P2.HTTP.Router.APIv2.Auth;

procedure RouteHealth(Req: TRequest; Res: TResponse);
var
	JObj: TJSONObject;
begin
	JObj := TJSONObject.Create();
	JObj.Strings['status'] := 'ok';
	JObj.Strings['version'] := '2';

	Res.ContentType := 'application/json';
	Res.Content := JObj.AsJSON;

	JObj.Free();
end;

procedure RouteAltcha(Req: TRequest; Res: TResponse);
begin
	Res.ContentType := 'application/json';
	Res.Content := P2.Altcha.Challenge();
end;

procedure Init();
begin
	HTTPRouter.RegisterRoute('/api/v2/health', @RouteHealth);
	HTTPRouter.RegisterRoute('/api/v2/altcha', @RouteAltcha);
	P2.HTTP.Router.APIv2.Auth.Init();
end;

end.
