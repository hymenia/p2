unit P2.Crypto;

{$linklib crypto}

interface
type
	TKeyPair = record
		PublicKey: String;
		PrivateKey: String;
	end;

function CreateKeyPair(KeyType: String = 'Ed25519'): TKeyPair;

implementation
uses
	CTypes, SysUtils;

function EVP_PKEY_CTX_new_from_name(libctx: Pointer; name: PChar; propquery: PChar): Pointer; cdecl; external name 'EVP_PKEY_CTX_new_from_name';
function EVP_PKEY_keygen_init(ctx: Pointer): CInt; cdecl; external name 'EVP_PKEY_keygen_init';
function EVP_PKEY_keygen(ctx: Pointer; ppkey: Pointer): CInt; cdecl; external name 'EVP_PKEY_keygen';
function EVP_PKEY_get_raw_public_key(pkey: Pointer; pub: PCUChar; len: PCSize_T): CInt; cdecl; external name 'EVP_PKEY_get_raw_public_key';
function EVP_PKEY_get_raw_private_key(pkey: Pointer; priv: PCUChar; len: PCSize_T): CInt; cdecl; external name 'EVP_PKEY_get_raw_private_key';
procedure EVP_PKEY_CTX_free(ctx: Pointer); cdecl; external name 'EVP_PKEY_CTX_free';
procedure EVP_PKEY_free(key: Pointer); cdecl; external name 'EVP_PKEY_free';

function HexDump(Data: Array of CUChar; Size: Integer): String;
var
	I: Integer;
begin
	HexDump := '';

	for I := Low(Data) to High(Data) do
	begin
		HexDump := HexDump + IntToHex(Data[I], 2);
	end;
end;

function CreateKeyPair(KeyType: String): TKeyPair;
var
	PKey: Pointer;
	PKeyCtx: Pointer;
	Size: CSize_T;
	Key: Array [1..32] of CUChar;
begin
	PKey := Nil;
	PKeyCtx := EVP_PKEY_CTX_new_from_name(Nil, PChar(KeyType), Nil);

	EVP_PKEY_keygen_init(PKeyCtx);
	EVP_PKEY_keygen(PKeyCtx, @PKey);

	Size := 32;
	EVP_PKEY_get_raw_public_key(PKey, @Key[1], @Size);
	CreateKeyPair.PublicKey := HexDump(Key, 32);

	Size := 32;
	EVP_PKEY_get_raw_private_key(PKey, @Key[1], @Size);
	CreateKeyPair.PrivateKey := HexDump(Key, 32);

	EVP_PKEY_CTX_free(PKeyCtx);
	EVP_PKEY_free(PKey);
end;

end.
