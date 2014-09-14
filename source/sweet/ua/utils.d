module sweet.ua.utils;

public pure bool cStrCmp(string s)(const(char)* cs) @trusted nothrow {
	if(cs is null) {
		return false;
	}

	size_t i = 0;
	for(; i < s.length; ++i) {
		if(cs[i] == '\0') {
			return false;
		} 
		if(cs[i] != s[i]) {
			return false;
		}
	}

	return i == s.length && cs[i] == '\0';
}
