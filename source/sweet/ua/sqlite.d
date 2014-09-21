module sweet.ua.sqlite;

import sweet.ua.uda;
import sweet.ua.options;

struct Sqlite {
	import sweet.ua.sqlitebindings;
	import etc.c.sqlite3;
  private:
	string dbFilename;
	sqlite3* db;
	sqlite3_stmt* stmt;

  public:
	this(string filename, 
			int openType = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE) 
	{
		import std.string : toStringz;

		this.dbFilename = filename;

		int errCode = sqlite3_open_v2(toStringz(this.dbFilename), &this.db, 
			openType, null
		);

		if(errCode != SQLITE_OK) {
			sqliteThrowException(this.db, errCode);
		}
	}

	struct UniRange(T) {
		T currentItem;
		int sqlRsltCode;
		sqlite3_stmt* stmt;
		bool done;

		this(sqlite3_stmt* s, int rsltCode) {
			sqlRsltCode = rsltCode;
			stmt = s;
			if(sqlRsltCode == SQLITE_OK) {
				sqlRsltCode = sqlite3_step(stmt);
				if(sqlRsltCode == SQLITE_ROW) {
					this.currentItem = buildItem!T();
				} else {
					//writeln(sqlRsltCode);
					done = true;
					sqlite3_finalize(stmt);
				}
			} else {
				//writeln(sqlRsltCode);
				done = true;
				sqlite3_finalize(stmt);
			}
		}
	
		@property bool empty() const pure nothrow {
			return done;
		}

		@property T front() {
			return this.currentItem;
		}

		@property void popFront() { 
			sqlRsltCode = sqlite3_step(stmt);
			if(sqlRsltCode == SQLITE_ROW) {
				this.currentItem = buildItem!T();
			} else {
				done = true;
				sqlite3_finalize(stmt);
			}
		}

		mixin(genRangeItemFill!T());
	}

	void insert(T)(ref T arg) {
		enum insertString = genInsert1!(T,sqliteType);
		static assert(insertString[$-1] == '\0');
		int errCode = sqlite3_prepare_v2(db, insertStr.ptr,
				createString.length, &stmt, null);

		this.insertImpl(this.stmt, arg);
	}

	void insertImpl(Args...)(sqlite3_stmt* stmt, 
			auto ref Args args) 
	{
		
		if(errCode != SQLITE_OK) {
			scope(exit) sqlite3_finalize(stmt);
			sqliteThrowException(this.db, errCode);
		}
	}

	void createTable(T)() {
		import sweet.ua.tablegen1 : genCreateTable2;
		import sweet.ua.types : sqliteType;

		enum createString = genCreateTable2!(T,sqliteType);
		static assert(createString[$-1] == '\0');

		int errCode = sqlite3_prepare_v2(db, createString.ptr,
				createString.length, &stmt, null);
		
		if(errCode != SQLITE_OK) {
			scope(exit) sqlite3_finalize(stmt);
			sqliteThrowException(this.db, errCode);
		}

		errCode = sqlite3_step(stmt);
		if(errCode != SQLITE_DONE) {
			scope(exit) sqlite3_finalize(stmt);
			sqliteThrowException(this.db, errCode);
		}
	}
	
}

pure string fillDataMember(string a, string dba) @safe nothrow {
	return 
	"\tif(cStrCmp!\"" ~ dba ~ "\"(cn)) {\n" ~
	"\t\tstatic if(is(typeof(T." ~ a ~ ") == long)) {\n" ~
	"\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_INTEGER) {\n" ~
	"\t\t\t\tret." ~ a ~ " = sqlite3_column_int(stmt, i);\n" ~ 
	"\t\t\t}\n" ~
	"\t\t} else static if(isIntegral!(typeof(T." ~ a ~ "))) {\n" ~
	"\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_INTEGER) {\n" ~
	"\t\t\t\tret." ~ a ~ " = sqlite3_column_int(stmt, i);\n" ~ 
	"\t\t\t}\n" ~
	"\t\t} else static if(isFloatingPoint!(typeof(T." ~ a ~ "))) {\n" ~
	"\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE_FLOAT) {\n" ~
	"\t\t\t\tret." ~ a ~ " = sqlite3_column_double(stmt, i);\n" ~ 
	"\t\t\t}\n" ~
	"\t\t} else static if(isSomeString!(typeof(T." ~ a ~ "))) {\n" ~
	"\t\t\tif(sqlite3_column_type(stmt, i) == SQLITE3_TEXT) {\n" ~
	"\t\t\t\tret." ~ a ~ " = to!string(sqlite3_column_text(stmt, i));\n" ~
	"\t\t\t}\n" ~
	"\t\t}\n" ~
	"\t}\n";
}

private string genRangeItemFill(T)() {
	string ret = "T buildItem() {\n\t" ~
		"import sweet.ua.utils : cStrCmp;\n\t" ~
		"\n\tT ret" ~ (is(T : Object) ? " = new T();" : ";") ~
		"\n\tsize_t cc = sqlite3_column_count(stmt);\n" ~
		"\tfor(int i = 0; i < cc; ++i) {\n" ~
		"\tconst(char)* cn = sqlite3_column_name(stmt, i);\n";

	foreach(it; __traits(allMembers, T)) {
		static if(isUA!(T, it)) {
			UA ua = getUA!(T,it);
			ret ~= fillDataMember(it, ua.rename);
		}
	}

	ret ~= "\t}\n\treturn ret;\n}\n";

	return ret;
}

version(unittest) {
	@UA struct FooHH {
		@UA string a;
		@UA int b;
		@UA(PrimaryKey, "k1") int c;
		@UA(PrimaryKey, "k2") int d;
	}

	//pragma(msg, genRangeItemFill!(FooHH));
}

unittest {
	import std.file : exists, remove;
	string dbname = "__testdatabase.db";
	scope(exit) {
		if(exists(dbname)) {
			remove(dbname);
		}
	}

	auto db = Sqlite(dbname);
	db.createTable!FooHH();
}
