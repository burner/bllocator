module ua.types;

import std.datetime : Date, DateTime;

string getNameOf(T)() pure @safe nothrow {
	import std.traits : fullyQualifiedName;
	import std.string : lastIndexOf;

	auto fully = fullyQualifiedName!T;
	ptrdiff_t point;
	try {
   		point = fully.lastIndexOf('.');
	} catch(Exception e) {
		assert(false);
	}
	if(point != -1 && point+1 < fully.length) {
		return fully[point+1 .. $];
	} else {
		return fully;
	}
}

version(unittest) {
	struct Foo {
	}
}

unittest {
	static assert(getNameOf!Foo == "Foo", getNameOf!Foo);
}

string mysqlType(T)() pure @safe {
	import std.traits : isStaticArray, isSomeChar;
	import std.range : ElementType;
	import std.string : format;

	static if(is(T == byte)) return "TINYINT";
	else static if(is(T == ubyte)) return "TINYINT";
	else static if(is(T == bool)) return "BIT";
	else static if(is(T == short)) return "SMALLINT";
	else static if(is(T == ushort)) return "SMALLINT";
	else static if(is(T == int)) return "INT";
	else static if(is(T == uint)) return "INT";
	else static if(is(T == long)) return "BIGINT";
	else static if(is(T == ulong)) return "BIGINT";
	else static if(is(T == float)) return "FLOAT";
	else static if(is(T == double)) return "DOUBLE";
	else static if(is(T == char)) return "CHAR";
	else static if(is(T == string)) return "VARCHAR";
	else static if(is(T == wstring)) return "VARCHAR";
	else static if(is(T == dstring)) return "VARCHAR";
	else static if(isStaticArray!T && isSomeChar!(ElementType!T) 
		&& T.length < 255) return format("CHAR(%u)", T.length);
	else static if(is(T == Date)) return "DATE";
	else static if(is(T == DateTime)) return "DATETIME";
	else assert(false, "MYSQL has not type for \"" ~ getNameOf!T() ~ '"');
}

unittest {
	assert(mysqlType!int() == "INT");
	assert(mysqlType!(char[128])() == "CHAR(128)");
	assert(mysqlType!(DateTime)() == "DATETIME");
	assert(mysqlType!(Date)() == "DATE");
}
