module typedallocator;

import std.traits;
import std.range;

struct RC(T) if(!is(T == class) && !hasIndirections!T) {
	private struct Impl {
		T payload;
		long count;
		void delegate(void[]) delFunc;
	}

	private Impl* store;

	private void initialize(A...)(void[] delegate(size_t) allo, 
			void delegate(void[]) del, auto ref A args)
	{
		import std.conv : emplace;
		import std.exception : enforce;

		this.store = cast(Impl*) enforce(allo(Impl.sizeof).ptr);
		emplace(&this.store.payload, args);
		this.store.delFunc = del;
		this.store.count = 1;
	}

	this(A...)(void[] delegate(size_t) allo, void delegate(void[]) del, 
			auto ref A args) //if(A.length > 0)
	{
		this.initialize(allo, del, args);
	}

	this(A...)(void[] delegate(size_t) shared allo, 
			void delegate(void[]) shared del, 
			auto ref A args) //if(A.length > 0)
	{
		this.initialize(cast(void[] delegate(size_t))allo, 
			cast(void delegate(void[]))del, args);
	}

    this(this) {
        if(this.store is null) return;
        ++this.store.count;
    }

    ~this() {
        if(this.store is null) return;
        assert(this.store.count > 0);
        if (--this.store.count)
            return;
        // Done, deallocate
        .destroy(this.store.payload);
		auto del = this.store.delFunc;
		del((cast(void*)this.store)[0 .. Impl.sizeof]);

        this.store = null;
    }

	ref T getPayload() {
		assert(this.store !is null);
		return this.store.payload;
	}

	alias getPayload this;
}

struct TypedAllo {
  private:
	void[] delegate(size_t) allocator;
	void delegate(void[]) deallocator;

  public:
	this(A)(A allo) {
		this(&allo.allocate, &allo.deallocate);
	}
	this(A,D)(A allo, D deallo) {
		this.allocator = cast(void[] delegate(size_t))allo;
		this.deallocator = cast(void delegate(void[]))deallo;
	}

	auto make(T,A...)(auto ref A args) if(!is(T == class)) {
		import std.conv : emplace;
		import std.exception : enforce;

		auto tPtr = cast(T*)enforce(this.allocator(T.sizeof).ptr);
		emplace(tPtr, args);

		return tPtr;
	}

	auto makeRC(T,A...)(auto ref A args) if(!is(T == class)) {
		return RC!(T)(this.allocator, this.deallocator, 
			args
		);
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
	
	    auto ptr = cast(E*)this.allocator(sizes[0] * E.sizeof);
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

	void release(T)(T* ptr) {
		void[] vPtr = (cast(void*)ptr)[0 .. T.sizeof];
		this.deallocator(vPtr);
	}
}
