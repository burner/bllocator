import std.stdio;
import std.array;
import std.allocator;

import typedallocator;

unittest {
	auto allo = Mallocator.it;
	auto a = makeTypedAllo(allo);

	auto someInt = a.makeRC!int(42);
	assert(someInt == 42);

	int* ip = a.make!int(42);
	assert(someInt == 42);
	
	a.release(ip);

	int[] arr = a.makeArr!(int[])(42);
	assert(arr !is null);
	assert(arr.length == 42);
	foreach(it; arr) assert(it == 0);

	int[][][] arr2 = a.makeArr!(int[][][])(42,32,22);
	assert(arr2 !is null);
	assert(arr2.length == 42);
}

unittest {
	auto allo = Mallocator.it;
	auto a = makeTypedAllo(allo);

	auto someInt = a.makeRC!int(42);
	assert(someInt == 42);

	int* ip = a.make!int(42);
	assert(someInt == 42);
	
	a.release(ip);

	int[] arr = a.makeArr!(int[])(42);
	assert(arr !is null);
	assert(arr.length == 42);
	foreach(it; arr) assert(it == 0);
	a.release(arr);

	int[][][] arr2 = a.makeArr!(int[][][])(42,32,22);
	assert(arr2 !is null);
	assert(arr2.length == 42);
	a.release(arr2);
}

version(unittest) {
	struct F {
		int v;
		~this() { writefln("F %d is ending", this.v); }
	}
}

unittest {
	void fun(T)(T t) {
	}

	auto allo = Mallocator.it;
	auto a = makeTypedAllo(allo);

	auto f = a.makeRC!F();
	fun(f);
}

unittest {
	auto allo = Mallocator.it;

	int[] arr = (cast(int*)allo.allocate(int.sizeof * 32))[0 .. 32];
	assert(arr.length == 32);

	allo.deallocate((cast(void*)arr.ptr)[0 .. int.sizeof * 32]);
}

unittest {
	auto allo = Mallocator.it;
	auto a = makeTypedAllo(allo);

	auto arrRC = a.makeArrRC!(F[])(32);
	assert(arrRC.length == 32);
}

unittest {
	auto allo = Mallocator.it;
	auto a = makeTypedAllo(allo);

	auto arrRC = a.makeArrRC!(F[])(32);
	F[] arr = arrRC;
	foreach(idx, ref it; arr) {
		it.v = cast(int)idx;
	}
	assert(arr.length == 32);
}

void main() {
	auto p = GCAllocator.it.allocate(10);
	assert(p !is null);
	assert(p.length == 10);
}
