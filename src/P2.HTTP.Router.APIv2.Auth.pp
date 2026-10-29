unit P2.HTTP.Router.APIv2.Auth;

interface

procedure Init();

implementation
uses
	SysUtils,
	FPJSON, JSONParser,
	HTTPDefs, HTTPRoute,
	P2.Altcha, P2.JSON;

procedure RouteRegister(Req: TRequest; Res: TResponse);
var
	JObj: TJSONObject;
	JReq: TJSONObject;
begin
	Res.ContentType := 'application/json';

	JObj := TJSONObject.Create();

	try
		JReq := TJSONObject(GetJSON(Req.Content));

		P2.JSON.Expect(JReq, 'username', jtString);
		P2.JSON.Expect(JReq, 'email', jtString);
		P2.JSON.Expect(JReq, 'password', jtString);
		P2.JSON.Expect(JReq, 'altcha', jtObject);
	except
		on E: Exception do
		begin
			JObj.Strings['error'] := E.Message;
		end;
	end;

	Res.Content := JObj.AsJSON;

	if Assigned(JReq) then 
	begin
		JReq.Free();
	end;
	JObj.Free();
end;

procedure Init();
begin
	HTTPRouter.RegisterRoute('/api/v2/auth/register', @RouteRegister);
end;

end.
