module sweet.vector;

import sweet.typedallocator;

struct Vector(T,A = TypedAllo!(shared Mallocator)) {
	static if(is(A == TypedAllo!(shared Mallocator))) {
		enum Mallo = true;
	} else {
		enum Mallo = false;
	}	

	private VectorImpl* data;

	struct VectorImpl {
		T[] arr;
		size_t refCnt;
		size_t length;
	}

	static if(Mallo) {
		A allocator;
	} else {
		A* allocator;
	}	

	static if(!Mallo) {
		@disable this();

		this(A* allo) {
			this.allocator = allo;
		}
	} else {
		static Vector!(T) opCall() {
			Vector!(T) ret;
			ret.allocator = makeTypedAllo(Mallocator.it());
			return ret;
		}
	}

	~this() {
		if(this.data !is null) {
			this.clean();
			this.allocator.release!false(this.data.arr);
			this.allocator.release(this.data);
			this.data = null;
		}
	}

	private VectorImpl* getData(size_t size = 32) {
		if(this.data is null) {
			this.data = this.allocator.make!(VectorImpl)();
			this.data.refCnt = 0;
			this.data.length = 0;
			this.data.arr = this.allocator.makeArr!(T[])(size);
		}

		return this.data;
	}

	void insertBack(S...)(auto ref S s) {
		foreach(it; s) {
			this.insertBackImpl(it);
		}
	}

	private void insertBackImpl(S)(auto ref S s) {
		static if(is(S : T)) {
			auto impl = this.checkSpace();
			impl.arr[impl.length++] = s;
		}	
	}

	void emplaceBack(S...)(auto ref S s) {
		import std.conv : emplace;
		auto impl = this.checkSpace();
		emplace!T(&impl.arr[impl.length++], s);
	}

	import std.traits : hasElaborateDestructor, isPointer;

	void removeBack() {
		import std.exception : enforceEx;
		import core.exception : RangeError;

		auto impl = this.getData();
		cast(void)enforceEx!RangeError(impl.length, 
			"Can remove the back of an empty Vector");
		--impl.length;
		static if(!isPointer!T && hasElaborateDestructor!T) {
			impl.arr[impl.length].__dtor();
		}
	}

	private VectorImpl* checkSpace() {
		auto impl = this.getData();
		if(impl.length == impl.arr.length) {
			this.grow();
		}
		
		return impl;
	}

	void clean() {
		static if(hasElaborateDestructor!T) {
			foreach(ref it; this.data.arr[0 .. this.data.length]) {
				.destroy(it);
			}
		}
		this.data.length = 0u;
	}

	private void grow() {
		auto impl = this.getData();
		auto nArr = this.allocator.makeArr!(T[])(impl.arr.length * 2);
		for(size_t i = 0; i < impl.arr.length; ++i) {
			nArr[i] = impl.arr[i];
		}

		auto oArr = impl.arr;
		impl.arr = nArr;
		this.allocator.release!(false)(oArr);
	}

	ref T opIndex(size_t idx) {
		return this.data.arr[idx];
	}

	ref T front() {
		return this.data.arr[0u];
	}

	ref T back() {
		return this.data.arr[this.data.length-1u];
	}

	@property size_t length() const {
		if(this.data !is null) {
			return this.data.length;
		} else {
			return 0u;
		}
	}

	@property bool empty() const {
		if(this.data !is null) {
			return this.data.length == 0;
		} else {
			return true;
		}
	}
}

unittest {
	Vector!int fun() {
		return Vector!int();
	}

	auto v = Vector!(int)();
	auto v2 = fun();
	foreach(it; 0 .. 128) {
		v.insertBack(it);
		v2.insertBack(it);
		assert(v.back() == it);
		assert(v2.back() == it);
		foreach(jt; 0 .. it) {
			assert(v[jt] == jt);
			assert(v2[jt] == jt);
		}
	}
}

version(unittest) {
	struct Fancy {
		void delegate() fun;

		this(void delegate() f) {
			this.fun = f;
		}

		~this() {
			if(fun !is null) {
				fun();
			}
		}
	}
}

unittest {
	import std.conv : to;
	int i = 0;
	auto f = () { i++;};
	f();
	assert(i == 1);

	auto v = Vector!Fancy();
	foreach(it; 0 .. 10) {
		v.insertBack(Fancy(f));
		assert(v.length == it+1, to!string(v.length));
	}

	v.__dtor();
	assert(i == 31, to!string(i));
}

unittest {
	import std.conv : to;
	int i = 0;
	auto f = () { i++;};

	auto v = Vector!Fancy();
	foreach(it; 0 .. 10) {
		v.emplaceBack(f);
		assert(v.length == it+1, to!string(v.length));
	}

	v.__dtor();
	assert(i == 10, to!string(i));
}

unittest {
	import std.conv : to;
	int i = 0;
	auto f = () { i++;};

	auto v = Vector!Fancy();
	foreach(it; 0 .. 10) {
		v.emplaceBack(f);
		assert(v.length == it+1, to!string(v.length));
	}

	while(!v.empty) {
		v.removeBack();
	}

	assert(v.empty);
	assert(v.length == 0u, to!string(v.length));

	assert(i == 10, to!string(i));
}
