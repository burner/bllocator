module sweet.vector;

import sweet.typedallocator;

struct Vector(T,A = TypedAllo!(shared Mallocator)) {
	static if(is(A == TypedAllo!(shared Mallocator))) {
		enum Mallo = true;
	} else {
		enum Mallo = false;
	}	

	private struct Impl {
		T[] arr;
		size_t idx;
	}

	private Impl* impl;

	static if(Mallo) {
		A allocator;
	} else {
		A* allocator;
	}	

	private void makeImpl() {
		static if(Mallo) {
			this.allocator = makeTypedAllo(Mallocator.it);
		}	
		this.impl = this.allocator.make!Impl();
	}

	static if(!Mallo) {
		@disable this();

		this(A* allo) {
			this.allocator = allo;
		}
	}
}
