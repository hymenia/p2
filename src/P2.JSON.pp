unit P2.JSON;

interface
uses
	FPJSON;

procedure Expect(JObj: TJSONObject; Key: String; JSONType: TJSONType);

implementation
uses
	StrUtils, SysUtils, Types, TypInfo;

procedure Expect(JObj: TJSONObject; Key: String; JSONType: TJSONType);
var
	JKey: TJSONData;
	JKeyObj: TJSONObject;
	Keys: TStringDynArray;
	I: Integer;
	Cond: Boolean;
begin
	Keys := SplitString(Key, '.');

	JKeyObj := JObj;

	for I := Low(Keys) to High(Keys) do
	begin
		JKey := JKeyObj.Find(Keys[I]);

		if Not(Assigned(JKey)) then
		begin
			Raise(Exception.Create('Expected key ''' + Key + ''' but was not found'));
		end;

		if I = High(Keys) then
		begin
			Cond := JKey.JSONType = JSONType;
		end
		else
		begin
			Cond := JKey.JSONType = jtObject;
		end;

		if Not(Cond) then
		begin
			Raise(Exception.Create('Expected type ''' + GetEnumName(TypeInfo(TJSONType), Ord(JSONType)) + ''' for key ''' + Key + ''' but was ''' + GetEnumName(TypeInfo(TJSONType), Ord(JKey.JSONType)) + ''''));
		end;

		JKeyObj := TJSONObject(JKey);
	end;
end;

end.
