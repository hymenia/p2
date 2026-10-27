unit P2.HTTP.Router;

interface
uses
	HTTPDefs;

procedure Init();
procedure Route404(Req: TRequest; Res: TResponse);
procedure RouteNormal(Req: TRequest; Res: TResponse);

implementation
uses
	HTTPRoute,
	P2.HTTP;

procedure Init();
begin
	HTTPRouter.RegisterRoute('/', @RouteNormal, True);
end;

procedure Route404(Req: TRequest; Res: TResponse);
begin
	Res.Code := 404;
	Res.CodeText := P2.HTTP.StatusText(404);

	if Not(P2.HTTP.SetContent(Res, '/404.html')) then
	begin
		Res.ContentType := 'text/plain';
		Res.Content := '404 page was also Not found';
	end;
end;

procedure RouteNormal(Req: TRequest; Res: TResponse);
begin
	if P2.HTTP.SetContent(Res, '/' + Req.PathInfo) then
	begin end
	else if P2.HTTP.SetContent(Res, '/' + Req.PathInfo + '/index.html') then
	begin end
	else
	begin
		Route404(Req, Res);
	end;
end;

end.
