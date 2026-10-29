unit P2.HTTP.Router.APIv2;

interface

procedure Init();

implementation
uses
	P2.Altcha, P2.C, P2.Config,
	FPJSON,
	HTTPDefs, HTTPRoute;

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
var
	Challenge: PChar;
begin
	Challenge := P2.Altcha.Challenge(PChar(P2.Config.Table.AltchaAlgorithm), P2.Config.Table.AltchaCost, PChar(P2.Config.Table.AltchaSecret));

	Res.ContentType := 'application/json';
	Res.Content := String(Challenge);

	P2.C.Free(Challenge);
end;

procedure Init();
begin
	HTTPRouter.RegisterRoute('/api/v2/health', @RouteHealth);
	HTTPRouter.RegisterRoute('/api/v2/altcha', @RouteAltcha);
end;

end.
