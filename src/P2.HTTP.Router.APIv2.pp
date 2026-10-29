unit P2.HTTP.Router.APIv2;

interface

procedure Init();

implementation
uses
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

procedure Init();
begin
	HTTPRouter.RegisterRoute('/api/v2/health', @RouteHealth);
end;

end.
