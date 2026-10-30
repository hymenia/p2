program p2;

{$linklib stdc++}
{$ifdef UNIX}
{$linklib m}
{$linklib c}
{$endif}
{$linklib gcc_s}

uses
{$ifdef UNIX}
	CThreads,
{$endif}
	SysUtils,
	P2.Config, P2.SQL, P2.HTTP;

begin
	if Not(P2.Config.Init()) then
	begin
		WriteLn('Config error. P2 is exiting.');
		Halt(1);
	end;

	if Not(P2.SQL.Init()) then
	begin
		WriteLn('SQL error. P2 is exiting.');
		Halt(1);
	end;

	if Not(P2.HTTP.Init()) then
	begin
		WriteLn('HTTP error. P2 is exiting.');
		Halt(1);
	end;

	WriteLn('P2 is listening to :' + IntToStr(P2.Config.Table.WebPort));

	P2.HTTP.Run();
end.
