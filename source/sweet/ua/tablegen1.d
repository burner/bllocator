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

// sqlite
string getCreateTable2(T, alias TypeGen)() if(isUA!T) {
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
	ret ~= ");";

	return ret;
}

version(unittest) {
	import sweet.ua.options;
	private @UA struct Foo {
		@UA string a;
		@UA int b;
		@UA(PrimaryKey, "k1") int c;
		@UA(PrimaryKey, "k2") int d;
	}
}

unittest {
	import sweet.ua.types;
	enum i = getCreateTable2!(Foo,sqliteType)();
	pragma(msg, i);
}
