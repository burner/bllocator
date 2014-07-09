import std.stdio;
import std.array;
import std.allocator;

import sweet.typedallocator;
import sweet.vector;

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

unittest {
	auto allo = Mallocator.it;
	TypedAllo!(shared Mallocator) a = makeTypedAllo(allo);

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
		~this() { /*writefln("F %d is ending", this.v);*/ }
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

unittest {
	Vector!int v;

    alias FList = Freelist!(GCAllocator, 0, unbounded);
    alias A = Segregator!(
        8, Freelist!(GCAllocator, 0, 8),
        128, Bucketizer!(FList, 1, 128, 16),
        256, Bucketizer!(FList, 129, 256, 32),
        512, Bucketizer!(FList, 257, 512, 64),
        1024, Bucketizer!(FList, 513, 1024, 128),
        2048, Bucketizer!(FList, 1025, 2048, 256),
        3584, Bucketizer!(FList, 2049, 3584, 512),
        4072 * 1024, CascadingAllocator!(
            () => HeapBlock!(4096)(GCAllocator.it.allocate(4072 * 1024))),
        GCAllocator
    );
    A tuMalloc;
	auto a = makeTypedAllo(tuMalloc);

	auto v2 = Vector!(int, TypedAllo!A)(&a);
	v2.insertBack(1);
	assert(v2[0] == 1);
}

void main() {
	auto p = GCAllocator.it.allocate(10);
	assert(p !is null);
	assert(p.length == 10);
}
