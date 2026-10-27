program p2;

uses
{$ifdef UNIX}
	CThreads,
{$endif}
	SysUtils,
	P2.Config, P2.SQL, P2.HTTP;

begin
	if not(P2.Config.Init()) then
	begin
		WriteLn('Config error. P2 is exiting.');
		Halt(1);
	end;

	if not(P2.SQL.Init()) then
	begin
		WriteLn('SQL error. P2 is exiting.');
		Halt(1);
	end;

	if not(P2.HTTP.Init()) then
	begin
		WriteLn('HTTP error. P2 is exiting.');
		Halt(1);
	end;

	WriteLn('P2 is listening to :' + IntToStr(P2.Config.Table.WebPort));

	P2.HTTP.Run();
end.
