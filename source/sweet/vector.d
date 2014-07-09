module sweet.vector;

import sweet.typedallocator;

struct Vector(T,A = TypedAllo!(shared Mallocator)) {
	static if(is(A == TypedAllo!(shared Mallocator))) {
		enum Mallo = true;
	} else {
		enum Mallo = false;
	}	

	private T[] arr;
	private static size_t initSize = 16;
	public size_t length = 0;

	static if(Mallo) {
		A allocator;
	} else {
		A* allocator;
	}	

	private void makeImpl() {
		static bool once = false;
		static if(Mallo) {
			if(!once) {
				this.allocator = makeTypedAllo(Mallocator.it);
				once = true;
			}
		}
	}

	static if(!Mallo) {
		@disable this();

		this(A* allo) {
			this.allocator = allo;
		}
	}

	~this() {
		if(this.arr !is null) {
			this.allocator.release(this.arr);
		}
	}

	private void buildCap(const size_t toInsert) {
		this.makeImpl();

		if(this.arr.length == 0) {
			this.arr = this.allocator.makeArr!(T[])(Vector.initSize);
		} else if(this.length + toInsert >= this.arr.length) {
			auto nArr = this.allocator.makeArr!(T[])(this.arr.length * 2);
			nArr[0 .. this.arr.length] = this.arr[];
			this.allocator.release!(false)(this.arr);
			this.arr = nArr;
		}
	}

	public void insertBack(S...)(auto ref S s) {
		foreach(it; s) {
			this.insertBackImpl(it);
		}
	}

	private void insertBackImpl(S)(auto ref S s) {
		static if(is(S : T)) {
			this.buildCap(1);
			this.arr[this.length++] = s;
		}	
	}

	public ref T opIndex(size_t idx) {
		return this.arr[idx];
	}
}
