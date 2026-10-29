unit P2.Altcha;

{$linklib libargon2.a}
{$linklib libaltcha.a}
{$linklib libp2.a}
{$linklib libcrypto.so}

interface
type
	TVerify = (Verified = 0, Expired, InvalidSignature, InvalidSolution);

function Challenge(): String;
function Verify(Challenge: String; Solution: String): TVerify;

implementation
uses
	CTypes,
	P2.C, P2.Config;

function ChallengeC(Algorithm: PChar; Cost: CInt; Secret: PChar): PChar; external name 'p2_altcha_challenge';
function VerifyC(Challenge: PChar; Solution: PChar; Secret: PChar): CInt; external name 'p2_altcha_verify';

function Challenge(): String;
var
	Tmp: PChar;
begin
	Tmp := ChallengeC(PChar(P2.Config.Table.AltchaAlgorithm), P2.Config.Table.AltchaCost, PChar(P2.Config.Table.AltchaSecret));

	Challenge := String(Tmp);

	P2.C.Free(Tmp);
end;

function Verify(Challenge: String; Solution: String): TVerify;
begin
	Verify := TVerify(VerifyC(PChar(Challenge), PChar(Solution), PChar(P2.Config.Table.AltchaSecret)));
end;

end.
