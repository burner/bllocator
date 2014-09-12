module sweet.ua.having;

import std.conv;

import sweet.ua.wherehavingimpl;
import sweet.ua.operator;
import sweet.ua.types;

struct Having {
	string t;
	string member;
	Op op;
	string value;
}

mixin(getHavingWhereFunctions!("having", "Having")());

unittest {
	struct Foo {
		int a;
	}

	import std.typecons, std.algorithm;
	alias TypeTuple!(char, byte, short, int, long,
		ubyte, ushort, uint, ulong, float, double, real, 
		string, wstring, dstring) UATypes;

	alias TypeTuple!(long, double, real, string) UATypesS;
	foreach(it; UATypes) {
		auto w = having!(Foo, "a", Op.EQ, to!it(10));
		assert(w.t == "Foo");
		assert(w.member == "a");
		assert(w.op == Op.EQ);
		assert(w.value.countUntil("10") != -1);

		w = having!(Foo, "a", Op.EQ)(to!it(10));
		assert(w.t == "Foo");
		assert(w.member == "a");
		assert(w.op == Op.EQ);
		if(!is(it == char) && !is(it == wchar) && !is(it == dchar)) {
			assert(w.value.countUntil("10") != -1);
		} else {
			assert(w.value == "\n");
		}

		foreach(jt; [Op.EQ, Op.LE, Op.GE, Op.NEQ]) {
			w = having!(Foo, "a")(jt, to!it(10));
			assert(w.t == "Foo");
			assert(w.member == "a");
			assert(w.op == jt);
			if(!is(it == char) && !is(it == wchar) && !is(it == dchar)) {
				assert(w.value.countUntil("10") != -1);
			} else {
				assert(w.value == "\n");
			}
		}

	}

	auto w = having!(Foo, "a", Op.EQ, true);
}
