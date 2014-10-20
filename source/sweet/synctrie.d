module sweet.synctrie;

import std.array : empty, front;
import core.sync.mutex;

synchronized class Trie(K,V) {
	private Mutex lock;
	private shared Trie!(K,V)[K] follow;
	private bool isSet;
	private shared V value;

	this() {
		this.lock = cast(shared(Mutex))new Mutex();
	}

	void insert(K[] keys, V value) {
		shared Trie!(K,V) next;
		synchronized(lock) {
			if(keys.empty && this.isSet) {
			} else if(!keys.empty) {
				auto tmp = keys[0] in this.follow;
				if(tmp is null) {
					next = new shared Trie!(K,V)();
					this.follow[keys.front] = next;
				} else {
					next = *tmp;
				}
			} else {
				this.value = value;
				this.isSet = true;
				return;
			}
		}

		next.insert(keys[1 .. $], value);
	}

	ref shared(V) opIndex(K[] keys) {
		shared(V)* value;
		bool exists = this.hasValueImpl(keys, &value);
		if(!exists) {
			throw new Exception("Values does not exists");
		} else {
			return *value;	
		}
	}

	bool hasValue(K[] keys) {
		shared(V)* value;
		return this.hasValueImpl(keys, &value);
	}

	bool hasValueImpl(K[] keys, shared(V)** value) {
		shared Trie!(K,V) next;
		synchronized(lock) {
			if(keys.empty) {
				*value = &this.value;
				return true;
			} else {
				auto tmp = keys.front in this.follow;
				if(tmp is null) {
					next = null;
				} else {
					next = *tmp;	
				}
			}
		}
		if(next is null) {
			return false;
		} else {
			return next.hasValueImpl(keys[1 .. $], value);	
		}
	}
}

unittest {
	auto t = new shared Trie!(string,int)();
	t.insert(["hello", "world"], 1337);
	assert(t.hasValue(["hello", "world"]));
	assert(t[["hello", "world"]] == 1337);
}
