module sweet.ua.tablegen1;

import sweet.ua.uda;

// MySQL / SQL Server / Oracle / MS Access:
string genCreateTable1(T, alias TypeGen)() if(isUA!T) {
	import std.array : empty;

	string[string] namesInUse;

	UA[] pks;

	string ret = "CREATE TABLE ";
	ret ~= getName!T();
	ret ~= " (";

	bool first = false;
	foreach(mem; __traits(allMembers, T)) {
		static if(isUA!(T, mem)) {
			if(mem in namesInUse) {
				continue;
			} else {
				UA ua = getUA!(T, mem);
				ret ~= first ? ", " : "";
				ret ~= uaToTable!(TypeGen, typeof(__traits(getMember, T, mem)))
					(ua);
				first = true;
				
				if(ua.isPrimaryKey) {
					pks ~= ua;
				}
			}
		}
	}

	if(!pks.empty) {
		first = false;
		ret ~= ", CONSTRAINT PRIMARY KEY(";
		foreach(it; pks) {
			ret ~= first ? ", " : "";
			first = true;
			ret ~= it.rename;
		}
		ret ~= ")";
	}
	ret ~= ");";

	return ret;
}

pure string uaToTable(alias TypeGen,T)(UA ua) {
	import std.string : format;

	return format("%s %s%s", ua.rename, TypeGen!T(), 
		ua.isNotNull ? " NOT NULL" : "");
}
