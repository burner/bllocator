module sweet.vector;

import sweet.typedallocator;

struct Vector(T,A = TypedAllo!(shared Mallocator)) {
	static if(is(A == TypedAllo!(shared Mallocator))) {
		enum Mallo = true;
	} else {
		enum Mallo = false;
	}	

	private T[] arr;

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
		if(this.arr !is null) {
			this.allocator.release(this.arr);
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

	public void insertBack(S...)(auto ref S s) {
		foreach(it; s) {
			this.insertBackImpl(it);
		}
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

	private void insertBackImpl(S)(auto ref S s) {
		static if(is(S : T)) {
			auto impl = this.getData();
			if(impl.length == impl.arr.length) {
				this.grow();
			}
			impl.arr[impl.length++] = s;
		}	
	}

	public ref T opIndex(size_t idx) {
		return this.data.arr[idx];
	}
}
