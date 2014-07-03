import std.stdio;
import std.array;
import std.allocator;

import typedallocator;

unittest {
	auto allo = Mallocator.it;

	auto ptr = RC!(int)(&allo.allocate, &allo.deallocate, 10);

	assert(ptr == 10);
}

unittest {
	auto allo = Mallocator.it;
	auto a = TypedAllo(&allo.allocate, &allo.deallocate);

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
	auto a = TypedAllo(&allo);

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
	struct F {
		~this() { writeln("F is ending"); }
	}

	void fun(RC!F r) {
	}

	auto allo = Mallocator.it;
	auto a = TypedAllo(&allo.allocate, &allo.deallocate);

	auto f = a.makeRC!F();
	fun(f);
}

unittest {
	auto allo = Mallocator.it;

	int[] arr = (cast(int*)allo.allocate(int.sizeof * 32))[0 .. 32];
	assert(arr.length == 32);

	allo.deallocate((cast(void*)arr.ptr)[0 .. int.sizeof * 32]);
}

void main() {
	auto p = GCAllocator.it.allocate(10);
	assert(p !is null);
	assert(p.length == 10);
}
