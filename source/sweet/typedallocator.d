module sweet.typedallocator;

public import std.allocator;

import std.traits;
import std.typetuple;
import std.range;

struct RC(T,A) if(!is(T == class)) {
	private struct Impl {
		T payload;
		long count;
		A* allocator;
	}

	private Impl* store;

	private void initialize(bool empla, A, U...)(A* a, auto ref U args)
	{
		import std.conv : emplace;
		import std.exception : enforce;

		this.store = enforce(a.make!(Impl));

		static if(empla) {
			emplace(&this.store.payload, args);
		}

		this.store.allocator = a;
		this.store.count = 1;
	}

	this(A, U...)(A* a, auto ref U args) if(!isArray!T)
	{
		this.initialize!true(a, args);
	}

	this(A)(A* a, T t) if(isArray!T)
	{
		this.initialize!false(a);

		this.store.payload = t;
	}

    this(this) {
        if(this.store is null) return;
        ++this.store.count;
    }

    ~this() {
        if(this.store is null) return;
        assert(this.store.count > 0);
        if(--this.store.count) {
            return;
		}
        // Done, deallocate
		static if(!isArray!T) {
        	.destroy(this.store.payload);
		} else {
			this.store.allocator.release(this.store.payload);
		}
		//pragma(msg, typeof(this.store.allocator));
		auto del = this.store.allocator;
		del.release(this.store);

        this.store = null;
    }

	ref T getPayload() {
		assert(this.store !is null);
		return this.store.payload;
	}

	alias getPayload this;
}

auto makeTypedAllo(T)(auto ref T t) {
	TypedAllo!T ret;
	ret.allo = &t;
	return ret;
}

struct TypedAllo(A) {
  //private:
	A* allo;

	this(A)(ref A allo) {
		this.allo = &allo;
	}

	this(A)(ref shared(A) allo) {
		this.allo = &allo;
	}

	auto make(T,A...)(auto ref A args) if(!is(T == class)) {
		import std.conv : emplace;
		import std.exception : enforce;

		auto tPtr = cast(T*)enforce(this.allo.allocate(T.sizeof).ptr);
		emplace(tPtr, args);

		return tPtr;
	}

	auto makeRC(T,U...)(auto ref U args) if(!is(T == class)) {
		alias AT = typeof(this);
		return RC!(T,AT)(&this, args);
	}

	auto makeArrRC(T,L...)(L sizes) {
		auto aPtr = this.makeArr!T(sizes);
		alias AT = typeof(this);
		return RC!(T,AT)(&this, aPtr);
	}

	auto makeArr(T,L...)(L sizes) if(!is(T == class) && 
		allSatisfy!(isIntegral, L))
	{
		import std.conv : to;
		template nDimensions(T) {
		    static if(isArray!T) {
		        enum nDimensions = 1 + nDimensions!(typeof(T.init[0]));
		    } else {
		        enum nDimensions = 0;
		    }
		}

	    static assert(sizes.length >= 1,
	        "Cannot allocate an array without the size of at least the " ~
			"first  dimension.");
	    static assert(sizes.length == nDimensions!T,
	        to!string(sizes.length) ~ " dimensions specified for a " ~
	        to!string(nDimensions!T) ~ " dimensional array.");
	
	    alias typeof(T.init[0]) E;
	
	    auto ptr = cast(E*)this.allo.allocate(sizes[0] * E.sizeof).ptr;
	    auto ret = ptr[0..sizes[0]];
	
	    static if(sizes.length > 1) {
	        foreach(ref elem; ret) {
	            elem = makeArr!(E)(sizes[1..$]);
	        }
	    } else {
	        ret[] = E.init;
	    }
	
	    return ret;
	}

	void release(T)(T ptr) if(isPointer!T) {
		void[] vPtr = (cast(void*)ptr)[0 .. T.sizeof];
		this.allo.deallocate(vPtr);
	}

	void release(bool des = true, T)(T arr) if(isArray!T) {
	    alias typeof(T.init[0]) E;

		static if(des) {
			static if(isArray!E) {
				foreach(it; arr) {
					this.release!des(it);
				}
			}

			foreach(ref it; arr) {
				.destroy(it);
			}
		}

		void[] vPtr = (cast(void*)arr.ptr)[0 .. (E.sizeof * arr.length)];
		this.allo.deallocate(vPtr);
	}
}
