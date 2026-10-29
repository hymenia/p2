unit P2.JSON;

interface
uses
	FPJSON;

procedure Expect(JObj: TJSONObject; Key: String; JSONType: TJSONType);

implementation
uses
	SysUtils, TypInfo;

procedure Expect(JObj: TJSONObject; Key: String; JSONType: TJSONType);
var
	JKey: TJSONData;
begin
	JKey := JObj.Find(Key);

	if Not(Assigned(JKey)) then
	begin
		Raise(Exception.Create('Expected key ''' + Key + ''' but was not found'));
	end;

	if Not(JKey.JSONType = JSONType) then
		Raise(Exception.Create('Expected type ''' + GetEnumName(TypeInfo(TJSONType), Ord(JSONType)) + ''' for key ''' + Key + ''' but was ''' + GetEnumName(TypeInfo(TJSONType), Ord(JKey.JSONType)) + ''''));
	begin
	end;
end;

end.
