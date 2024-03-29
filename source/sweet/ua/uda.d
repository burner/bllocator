module sweet.ua.uda;

import std.conv;
import std.traits;
import std.string;
import std.array;
import std.traits;

import sweet.ua.options;
import sweet.ua.types;

private pure void buildUARecursive(Args...)(ref UA ua, Args args) {
	static if(args.length > 0) {
		//auto v = args[0];
		static if(isSomeString!(typeof(args[0]))) {
			ua.rename = args[0];
		} else {
			if(args[0] == PrimaryKey) {
				ua.isPrimaryKey = true;
			} else if(args[0] == NotNull) {
				ua.isNotNull = true;
			} else if(args[0] == ForeignKey 
					|| args[0] == OneToMany
					|| args[0] == ManyToOne
					|| args[0] == ManyToMany) {
				ua.relation = uaToUARelation(args[0]);
			} else {
				assert(false, "Unexpected value \"" ~ to!string(args[0]) ~ '"');
			}
		}
	}

	static if(args.length > 1) {
		buildUARecursive(ua, args[1 .. $]);
	}
}

/** By default all data member of an struct or class will be considered when
used in UniformAccess, the UA attribute makes the usage more verbose and
allows to provide additional options.
*/
struct UA {
	pure static UA opCall(T...)(T args) {
		UA ret;
		buildUARecursive(ret, args);
		return ret;
	}

	string rename;
	bool isPrimaryKey;
	bool isNotNull;

	UARelation relation;
	string relationTable;
}

/** Whatever has an NoUA attribute will not be considered in UniformAccess
*/
enum {
	NoUA
}

enum UARelation {
	None,
	ForeignKey,
	OneToMany,
	ManyToOne,
	ManyToMany
}

UARelation uaToUARelation(T)(T v) {
	if(v == ForeignKey) {
		return UARelation.ForeignKey;
	} else if(v == OneToMany) {
		return UARelation.OneToMany;
	} else if(v == ManyToOne) {
		return UARelation.ManyToOne;
	} else if(v == ManyToMany) {
		return UARelation.ManyToMany;
	}
	assert(false);
}

unittest {
	static assert(uaToUARelation(ForeignKey) == UARelation.ForeignKey);
	static assert(uaToUARelation(OneToMany) == UARelation.OneToMany);
	static assert(uaToUARelation(ManyToOne) == UARelation.ManyToOne);
	static assert(uaToUARelation(ManyToMany) == UARelation.ManyToMany);
}

version(unittest) {
	@UA("AName") struct SomeCrazyNameYouShouldNeverWrite {
		@UA int a;
		@NoUA float b;
		@UA("foo") string c;

		@UA(PrimaryKey) @property int fun() { return fun_; }
		@UA(PrimaryKey) @property void fun(int f) { fun_ = f; }

		private int fun_;

		@UA(ForeignKey) SomeCrazyNameYouShouldNeverWrite1 other;
	}

	@UA struct SomeCrazyNameYouShouldNeverWrite1 {
		@UA int a;
		@NoUA float b;
		@UA("foo") string c;

		@UA(PrimaryKey) @property int fun() { return fun_; }
		@UA(PrimaryKey) @property void fun(int f) { fun_ = f; }

		private int fun_;
	}
}

template UDATuple (T...)
{
    alias Tuple = T;
}

pure UA getUA(T)() {
	static assert(isUA!(T));

	UA ret;

	//pragma(msg, __LINE__, " ", __traits(getAttributes, T));
	foreach(it; __traits(getAttributes, T)) {
		static if(is(typeof(it) == UA)) {
			ret.rename = it.rename;
			ret.isPrimaryKey = it.isPrimaryKey;
			ret.isNotNull = it.isNotNull;
			ret.relation = it.relation;
			break;
		}
	}

	if(ret.rename.empty()) {
		ret.rename = getNameOf!T();
	}

	return ret;
}

unittest {
	enum u = getUA!SomeCrazyNameYouShouldNeverWrite();
	static assert(u.rename == "AName");
	enum u2 = getUA!(SomeCrazyNameYouShouldNeverWrite,"other")();
	static assert(u2.relation == UARelation.ForeignKey, to!string(u2.relation));

}

UA getUA(T, string member)() {
	static assert(isUA!(T, member));

	UA ret;
	//pragma(msg, __LINE__, " ", __traits(getAttributes, __traits(getMember, T, member)));
	foreach(it; __traits(getAttributes, __traits(getMember, T, member))) {
		static if(is(typeof(it) == UA)) {
			ret.rename = it.rename;
			ret.isPrimaryKey = it.isPrimaryKey;
			ret.isNotNull = it.isNotNull;
			ret.relation = it.relation;
			break;
		}
	}

	if(ret.rename.empty()) {
		ret.rename = member;
	}

	return ret;
}

unittest {
	UA u = getUA!(SomeCrazyNameYouShouldNeverWrite, "c")();
	assert(u.rename == "foo", to!string(u));
}

bool isUAImpl(T)() {
	string ua = getNameOf!T;
	string noUA = to!string(NoUA);

	foreach(it; __traits(getAttributes, T)) {
		if(is(typeof(it) == UA)) {
			return true;
		}
	}

	return true;
}

bool isUAImpl(T, string member)() {
	string ua = getNameOf!T;
	string noUA = to!string(NoUA);

	foreach(it; __traits(getAttributes, __traits(getMember, T, member))) {
		if(is(typeof(it) == UA)) {
			return true;
		}
	}

	return true;
}

pure bool isUA(T)() {
	return isUAImpl!(T)();
}

pure bool isNotUA(T)() {
	return !isUAImpl!(T)();
}

unittest {
	static assert(isUA!(SomeCrazyNameYouShouldNeverWrite));
	static assert(!isNotUA!(SomeCrazyNameYouShouldNeverWrite));
}

bool isUA(T, string member)() {
	return isUAImpl!(T,member)();
}

bool isNotUA(T, string member)() {
	return !isUAImpl!(T,member)();
}

unittest {
	static assert(isUA!(SomeCrazyNameYouShouldNeverWrite,"a"));
	static assert(!isNotUA!(SomeCrazyNameYouShouldNeverWrite,"a"));
}

string getName(T)() nothrow @trusted if(isUA!T) {
	UA ua = getUA!T();
	
	if(!ua.rename.empty()) {
		return ua.rename;
	} else {
		string s = fullyQualifiedName!T;	
		try {
			auto idx = s.lastIndexOf('.') + 1;
			return s[idx .. $];
		} catch(Exception e) {
			assert(false, e.toString());
		}
	}
}

unittest {
	static assert(getName!SomeCrazyNameYouShouldNeverWrite() == "AName",
		getName!SomeCrazyNameYouShouldNeverWrite()
	);
	static assert(getName!SomeCrazyNameYouShouldNeverWrite1() == 
		"SomeCrazyNameYouShouldNeverWrite1",
		getName!SomeCrazyNameYouShouldNeverWrite1()
	);
}
