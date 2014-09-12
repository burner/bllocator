module sweet.ua.sqlitebindings;

private immutable SqliteExceptionConstructor = q{
	this(string msg = "", string file = __FILE__, ulong line = __LINE__) {
		super(msg, file, line);
	}
};

class SqliteException : Exception { mixin(SqliteExceptionConstructor); }

class Sqlite_Error : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Intern: SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Perm : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Abort : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Busy : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Locked: SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Nomem : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Readonly : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Interrupt : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Ioerr : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Corrupt : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Notfound : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Full : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Cantopen : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Protocol : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Empty : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Schema : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Toobig : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_ConstrainT: SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Mismatch : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Misuse : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Nolfs : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Auth : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Format : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Range : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Notadb : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Notice : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Warning : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_READ : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_SHORT_READ : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_WRITE : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_FSYNC : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_DIR_FSYNC : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_TRUNCATE : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_FSTAT : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_UNLOCK : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_RDLOCK : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_DELETE : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_BLOCKED : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_NOMEM : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_ACCESS : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_CHECKRESERVEDLOCK: SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_LOCK : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_CLOSE : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_DIR_CLOSE : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_SHMOPEN : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_SHMSIZE : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_SHMLOCK : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_SHMMAP : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_SEEK : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_DELETE_NOENT : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_MMAP : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_GETTEMPPATH : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOERR_CONVPATH : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_LOCKED_SHAREDCACHE : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_BUSY_RECOVERY : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_BUSY_SNAPSHOT : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CANTOPEN_NOTEMPDIR : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CANTOPEN_ISDIR : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CANTOPEN_FULLPATH : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CANTOPEN_CONVPATH : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CORRUPT_VTAB : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_READONLY_RECOVERY : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_READONLY_CANTLOCK : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_READONLY_ROLLBACK : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_READONLY_DBMOVED : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_ABORT_ROLLBACK : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CONSTRAINT_CHECK : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CONSTRAINT_COMMITHOOK : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CONSTRAINT_FOREIGNKEY : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CONSTRAINT_FUNCTION : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CONSTRAINT_NOTNULL : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CONSTRAINT_PRIMARYKEY : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CONSTRAINT_TRIGGER : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CONSTRAINT_UNIQUE : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CONSTRAINT_VTAB : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CONSTRAINT_ROWID : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_NOTICE_RECOVER_WAL : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_NOTICE_RECOVER_ROLLBACK: SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_WARNING_AUTOINDEX : SqliteException { mixin(SqliteExceptionConstructor); }
