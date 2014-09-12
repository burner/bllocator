module sweet.ua.postgresql;

struct PostgreSQLPlaceholderGen {
	int i = 1;
	@property string front() @trusted {
		import std.string : format;
		try {
			return format("$%d", i);
		} catch(Exception e) {
			assert(false, e.toString());
		}
	}

	bool empty = false;

	void popFront() pure @safe nothrow { ++i; }
}
