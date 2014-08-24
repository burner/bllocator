module sweet.trie;

import sweet.typedallocator;
import sweet.hashmap;

struct TrieNode(K,V,A) {
	V value;
	bool isValue;
	HashMap!(K,TrieNode!(K,V,A),A) follow;
	A* allocator;
}

struct Trie(K,V,A = TypedAllo!(shared Mallocator)) {
	static if(is(A == TypedAllo!(shared Mallocator))) {
		enum Mallo = true;
	} else {
		enum Mallo = false;
	}	

	static if(Mallo) {
		A allocator;
	} else {
		A* allocator;
	}

	HashMap!(K,TrieNode!(K,V,A),A) trie;

	static if(!Mallo) {
		@disable this();

		this(A* allo) {
			this.allocator = allo;
			this.trie = HashMap!(K,TrieNode!(K,V,A),A)(&this.allocator);
		}
	} else {
		static auto opCall() {
			Trie!(K,V,A) ret;
			ret.allocator = makeTypedAllo(Mallocator.it());
			ret.trie = HashMap!(K,TrieNode!(K,V,A),A)();
			return ret;
		}
	}
}

unittest {
	auto m = Trie!(string,int)();
}
