#include <ctime>
#include <cstring>
#include <cstdlib>

#include <string>

#include <altcha/altcha.hpp>

static char* p2_strdup(const char* str){
	char* r = (char*)malloc(strlen(str) + 1);

	strcpy(r, str);

	return r;
}

extern "C" char* p2_altcha_challenge(const char* algorithm, int cost, const char* secret){
	altcha::CreateChallengeOptions opts;

	opts.algorithm = algorithm;
	opts.cost = cost;
	opts.hmacSignatureSecret = secret;
	opts.expiresAt = time(nullptr) + 600;

	altcha::Challenge ch = altcha::createChallenge(opts);
	return p2_strdup(altcha::challengeToJson(ch).c_str());
}
