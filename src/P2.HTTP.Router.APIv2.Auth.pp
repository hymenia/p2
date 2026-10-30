unit P2.HTTP.Router.APIv2.Auth;

interface

procedure Init();

implementation
uses
	SysUtils, TypInfo,
	FPJSON, JSONParser,
	HTTPDefs, HTTPRoute,
	P2.Altcha, P2.HTTP, P2.JSON, P2.User;

procedure RouteRegister(Req: TRequest; Res: TResponse);
var
	JObj: TJSONObject;
	JReq: TJSONObject;
	Altcha: TJSONObject;
	Verify: TVerify;
begin
	Res.ContentType := 'application/json';

	JObj := TJSONObject.Create();

	try
		JReq := TJSONObject(GetJSON(Req.Content));

		P2.JSON.Expect(JReq, 'username', jtString);
		P2.JSON.Expect(JReq, 'email', jtString);
		P2.JSON.Expect(JReq, 'password', jtString);
		P2.JSON.Expect(JReq, 'altcha', jtObject);
		P2.JSON.Expect(JReq, 'altcha.challenge', jtObject);
		P2.JSON.Expect(JReq, 'altcha.solution', jtObject);
	except
		on E: Exception do
		begin
			FreeAndNil(JReq);
			JObj.Strings['error'] := E.Message;
			P2.HTTP.SetStatus(Res, 400);
		end;
	end;

	if Assigned(JReq) then
	begin
		Altcha := JReq.Objects['altcha'];
		Verify := P2.Altcha.Verify(Altcha.Objects['challenge'].AsJSON, Altcha.Objects['solution'].AsJSON);

		if Verify = P2.Altcha.Verified then
		begin
			if P2.User.Create(JReq.Strings['username'], JReq.Strings['email'], JReq.Strings['password']) then
			begin
			end
			else
			begin
			end;
		end
		else
		begin
			JObj.Strings['error'] := 'Captcha failed, error is ''' + GetEnumName(TypeInfo(P2.Altcha.TVerify), Ord(Verify)) + '''';
			P2.HTTP.SetStatus(Res, 403);
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
