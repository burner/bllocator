module ua.updategen1;

import ua.uda;

string genUpdate1(T,P)() @trusted if(isUA!T) {
	import std.range : take;
	import std.conv : to;

	P placeholdGen;

	string[string] namesInUse;

	string ret = "UPDATE " ~ getName!T ~ " SET ";

	size_t cnt = 0;

	// Setting the new data

	bool first = false;
	foreach(mem; __traits(allMembers, T)) {
		static if(isUA!(T, mem)) {
			UA ua = getUA!(T, mem);
			if(mem in namesInUse || ua.isPrimaryKey) {
				continue;
			} else {
				ret ~= first ? ", " : "";
				ret ~= ua.rename;
				ret ~= " = ";
				ret ~= placeholdGen.front.to!string();
				placeholdGen.popFront();
				first = true;
				++cnt;
			}
		}
	}

	ret ~= " WHERE ";

	first = false;
	foreach(k,v; namesInUse) {
		namesInUse.remove(k);
	}
	assert(!namesInUse.length);

	// Preparing the where

	foreach(mem; __traits(allMembers, T)) {
		static if(isUA!(T, mem)) {
			UA ua = getUA!(T, mem);
			if(mem !in namesInUse && ua.isPrimaryKey) {
				ret ~= first ? " AND " : "";
				ret ~= ua.rename;
				ret ~= " = ";
				ret ~= placeholdGen.front.to!string();
				placeholdGen.popFront();
				first = true;
				++cnt;
			}
		}
	}

	ret ~= ";\0";
	return ret;
}
