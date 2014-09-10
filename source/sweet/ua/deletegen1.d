module ua.deletegen1;

import ua.uda;

string genDelete(T,P)() @trusted if(isUA!T) {
	import std.conv : to;

	string ret = "DELETE FROM " ~ getName!T ~ " ";

	string[string] namesInUse;
	P placeholdGen;
	bool first = false;

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
			}
		}
	}

	return ret ~ ";\0";
}
