/** This module is about creating where statements for various sql version.

Where statements can be created at compile time, at runtime and partially at
compile time.
*/
module sweet.ua.wherehavingimpl;

import std.stdio;
import std.traits;
import std.string;
import std.algorithm;
import std.conv;
import std.typecons;
import std.format;

import sweet.ua.types;

private immutable whereHavingFuncTempAll = q{
	auto %s(T, string member, Op op, %s value)() @trusted {
		%s ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

private immutable whereHavingFuncTempValue = q{
	auto %s(T, string member, Op op, S)(S value) @trusted {
		%s ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

private immutable whereHavingFuncTempOp = q{
	auto %s(T, string member, %s value)(Op op) @trusted {
		%s ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

private immutable whereHavingFuncTempValueOp = q{
	auto %s(T, string member, S)(Op op, S value) @trusted {
		%s ret;
		ret.t = getNameOf!T;
		ret.member = member;
		ret.op = op;
		ret.value = to!string(value);
		return ret;
	}
};

string getHavingWhereFunctions(string a, string A)() pure @safe nothrow {
	string ret;
	try {
		ret ~= whereHavingFuncTempAll.format(a, long.stringof, A);
		ret ~= whereHavingFuncTempAll.format(a, double.stringof, A);
		ret ~= whereHavingFuncTempAll.format(a, string.stringof, A);
		ret ~= whereHavingFuncTempAll.format(a, wstring.stringof, A);
		ret ~= whereHavingFuncTempAll.format(a, dstring.stringof, A);
		ret ~= whereHavingFuncTempOp.format(a, long.stringof, A);
		ret ~= whereHavingFuncTempOp.format(a, double.stringof, A);
		ret ~= whereHavingFuncTempOp.format(a, string.stringof, A);
		ret ~= whereHavingFuncTempValue.format(a, A);
		ret ~= whereHavingFuncTempValueOp.format(a, A);
	} catch(Exception e) {
		assert(false, e.msg);
	}

	return ret;
}

//pragma(msg, getHavingWhereFunctions!("where", "Where"));

//pragma(msg, getWhereFunctions());
//mixin(getHavingWhereFunctions!());
