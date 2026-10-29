unit P2.Altcha;

{$linklib libargon2.a}
{$linklib libaltcha.a}
{$linklib libp2.a}
{$linklib libcrypto.so}

interface
uses
	CTypes;

function Challenge(Algorithm: PChar; Cost: CInt; Secret: PChar): PChar; external name 'p2_altcha_challenge';

implementation

end.
