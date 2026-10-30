unit P2.User;

interface
function Create(UserName: String; Email: String; Password: String): Boolean;

implementation
uses
	P2.SQL, P2.Crypto;

function Create(UserName: String; Email: String; Password: String): Boolean;
var
	KeyPair: P2.Crypto.TKeyPair;
	Trans: P2.SQL.TTransaction;
	Query: P2.SQL.TQuery;
begin
	Create := False;

	KeyPair := P2.Crypto.CreateKeyPair();

	Trans := P2.SQL.Pool.Acquire();

	Query := Trans.CreateQuery('INSERT INTO users (username, email, password_hash, public_key, private_key) VALUES (:username, :email, :password_hash, :public_key, :private_key)');
	Query.ParamByName('username').AsString := UserName;
	Query.ParamByName('email').AsString := Email;
	Query.ParamByName('password_hash').AsString := 'ok';
	Query.ParamByName('public_key').AsString := KeyPair.PublicKey;
	Query.ParamByName('private_key').AsString := KeyPair.PrivateKey;
	Query.ExecSQL();
	Query.Free();

	Trans.Commit();
	P2.SQL.Pool.Release(Trans);
end;

end.
