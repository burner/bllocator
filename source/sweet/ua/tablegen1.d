module sweet.ua.tablegen1;

import sweet.ua.uda;

private string buildElementsFromKey(alias TypeGen, T)(UA ua, string tablePrefix) {
	string ret;
	string[string] namesInUse;
	bool first = false;

	foreach(mem; __traits(allMembers, T)) {
		static if(isUA!(T, mem)) {
			if(mem in namesInUse) {
				continue;
			} else {
				UA lua = getUA!(T, mem);
				if(lua.isPrimaryKey) {
					ret ~= first ? ", " : "";
					ret ~= uaToTable!(TypeGen, typeof(__traits(getMember, T,
						mem)))(lua, tablePrefix);
					first = true;
				}
			}
		}
	}

	return ret;
}

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
	ret ~= ");\0";

	return ret;
}

pure string uaToTable(alias TypeGen,T)(UA ua) {
	import std.string : format;
	import std.traits : isNested;

	if(ua.relation == UARelation.None) {
		return format("%s %s%s", ua.rename, TypeGen!T(), 
			ua.isNotNull ? " NOT NULL" : "");
	} else if(ua.relation == UARelation.ForeignKey && is(T == struct)) {
		static if(is(T == struct)) {
			auto keys = buildElementsFromKey!(TypeGen,T)(ua,"");
			return keys;
		}
	}
	return "ERROR";
}

pure string uaToTable(alias TypeGen,T)(UA ua, string prefix) {
	import std.string : format;
	import std.traits : isNested;

	if(ua.relation == UARelation.None) {
		return format("%s%s %s%s", prefix ~ "_", ua.rename, TypeGen!T(), 
			ua.isNotNull ? " NOT NULL" : "");
	} else if(ua.relation == UARelation.ForeignKey && is(T == struct)) {
		static if(is(T == struct)) {
			auto keys = buildElementsFromKey!(TypeGen,T)(ua, prefix);
			return keys;
		}
	}
	return "ERROR";
}

// SQLite 
string genCreateTable2(T, alias TypeGen)() if(isUA!T) {
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
					(ua, getName!T());
				first = true;
				
				if(ua.isPrimaryKey) {
					pks ~= ua;
				}
			}
		}
	}

	ret ~= ')';

	if(!pks.empty) {
		assert(ret.length);
		ret = ret[0 .. $-1];
		first = false;
		ret ~= ", PRIMARY KEY(";
		foreach(it; pks) {
			ret ~= first ? ", " : "";
			first = true;
			ret ~= it.rename;
		}
		ret ~= ")";
	}
	ret ~= ");\0";

	return ret;
}

version(unittest) {
	import sweet.ua.options;
}

private @UA struct FooHH {
	@UA string a;
	@UA int b;
	@UA(PrimaryKey, "k1") int c;
	@UA(PrimaryKey, "k2") int d;

	@UA(ForeignKey)
	BarHH someBar;
}

private struct BarHH {
	@UA(PrimaryKey) int a;
	@UA(PrimaryKey) int b;
}

unittest {
	import sweet.ua.types;
	import std.stdio : writeln;
	enum i = genCreateTable2!(FooHH,sqliteType)();
	writeln(i);
	enum j = genCreateTable1!(FooHH,mysqlType)();
}
