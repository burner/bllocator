module sweet.ua.sqlitebindings;

import etc.c.sqlite3;

private immutable SqliteExceptionConstructor = q{
	this(string msg = "", string file = __FILE__, ulong line = __LINE__) pure {
		super(msg, file, line);
	}
};

immutable SQLITE_ABORT = 4;
immutable SQLITE_NOTICE = 27;
immutable SQLITE_WARNING = 28;

immutable SQLITE_ABORT_ROLLBACK         = (SQLITE_ABORT | (2<<8));
immutable SQLITE_IOERR_SHMMAP           = (SQLITE_IOERR | (21<<8));
immutable SQLITE_IOERR_SEEK             = (SQLITE_IOERR | (22<<8));
immutable SQLITE_IOERR_DELETE_NOENT     = (SQLITE_IOERR | (23<<8));
immutable SQLITE_IOERR_MMAP             = (SQLITE_IOERR | (24<<8));
immutable SQLITE_IOERR_GETTEMPPATH      = (SQLITE_IOERR | (25<<8));
immutable SQLITE_IOERR_CONVPATH         = (SQLITE_IOERR | (26<<8));
immutable SQLITE_LOCKED_SHAREDCACHE     = (SQLITE_LOCKED |  (1<<8));
immutable SQLITE_BUSY_RECOVERY          = (SQLITE_BUSY   |  (1<<8));
immutable SQLITE_BUSY_SNAPSHOT          = (SQLITE_BUSY   |  (2<<8));
immutable SQLITE_CANTOPEN_NOTEMPDIR     = (SQLITE_CANTOPEN | (1<<8));
immutable SQLITE_CANTOPEN_FULLPATH      = (SQLITE_CANTOPEN | (3<<8));
immutable SQLITE_CANTOPEN_CONVPATH      = (SQLITE_CANTOPEN | (4<<8));
immutable SQLITE_CORRUPT_VTAB           = (SQLITE_CORRUPT | (1<<8));
immutable SQLITE_READONLY_RECOVERY      = (SQLITE_READONLY | (1<<8));
immutable SQLITE_READONLY_CANTLOCK      = (SQLITE_READONLY | (2<<8));
immutable SQLITE_READONLY_ROLLBACK      = (SQLITE_READONLY | (3<<8));
immutable SQLITE_READONLY_DBMOVED       = (SQLITE_READONLY | (4<<8));
immutable SQLITE_CANTOPEN_ISDIR         = (SQLITE_CANTOPEN | (2<<8));
immutable SQLITE_CONSTRAINT_CHECK       = (SQLITE_CONSTRAINT | (1<<8));
immutable SQLITE_CONSTRAINT_COMMITHOOK  = (SQLITE_CONSTRAINT | (2<<8));
immutable SQLITE_CONSTRAINT_FOREIGNKEY  = (SQLITE_CONSTRAINT | (3<<8));
immutable SQLITE_CONSTRAINT_FUNCTION    = (SQLITE_CONSTRAINT | (4<<8));
immutable SQLITE_CONSTRAINT_NOTNULL     = (SQLITE_CONSTRAINT | (5<<8));
immutable SQLITE_CONSTRAINT_PRIMARYKEY  = (SQLITE_CONSTRAINT | (6<<8));
immutable SQLITE_CONSTRAINT_TRIGGER     = (SQLITE_CONSTRAINT | (7<<8));
immutable SQLITE_CONSTRAINT_UNIQUE      = (SQLITE_CONSTRAINT | (8<<8));
immutable SQLITE_CONSTRAINT_VTAB        = (SQLITE_CONSTRAINT | (9<<8));
immutable SQLITE_CONSTRAINT_ROWID       = (SQLITE_CONSTRAINT |(10<<8));
immutable SQLITE_NOTICE_RECOVER_WAL     = (SQLITE_NOTICE | (1<<8));
immutable SQLITE_NOTICE_RECOVER_ROLLBACK= (SQLITE_NOTICE | (2<<8));
immutable SQLITE_WARNING_AUTOINDEX      = (SQLITE_WARNING | (1<<8));

class SqliteException : Exception { mixin(SqliteExceptionConstructor); }

class Sqlite_Error : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Internal: SqliteException { mixin(SqliteExceptionConstructor); }
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
class Sqlite_Constraint: SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Mismatch : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Misuse : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Nolfs : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Auth : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Format : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Range : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Notadb : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Notice : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Warning : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Read : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Short_Read : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Write : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Fsync : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Dir_Fsync : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Truncate : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Fstat : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Unlock : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Rdlock : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Delete : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Blocked : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Nomem : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Access : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Checkreservedlock: SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Lock : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Close : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Dir_Close : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Shmopen : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Shmsize : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Shmlock : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Shmmap : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Seek : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Delete_Noent : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Mmap : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Gettemppath : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_IOErr_Convpath : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Locked_Sharedcache : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Busy_Recovery : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Busy_Snapshot : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CantOpen_NoTempDir : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CantOpen_IsDir : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CantOpen_FullPath : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_CantOpen_ConvPath : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Corrupt_Vtab : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Readonly_Recovery : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Readonly_Cantlock : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Readonly_Rollback : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Readonly_DBmoved : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Abort_Rollback : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Constraint_Check : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Constraint_Commithook : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Constraint_Foreignkey : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Constraint_Function : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Constraint_Notnull : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Constraint_Primarykey : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Constraint_Trigger : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Constraint_Unique : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Constraint_Vtab : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Constraint_Rowid : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Notice_Recover_Wal : SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Notice_Recover_Rollback: SqliteException { mixin(SqliteExceptionConstructor); }
class Sqlite_Warning_Autoindex : SqliteException { mixin(SqliteExceptionConstructor); }

void sqliteThrowException(sqlite3* db, int errCode, string msg = "", 
		int line = __LINE__, string file = __FILE__) 
{
	import std.conv : to;
	import std.string : fromStringz;
	string errString = fromStringz(sqlite3_errmsg(db));
	switch(errCode) {
		case SQLITE_ERROR: throw new Sqlite_Error(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_INTERNAL: throw new Sqlite_Internal(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_PERM: throw new Sqlite_Perm(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_ABORT: throw new Sqlite_Abort(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_BUSY: throw new Sqlite_Busy(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_LOCKED: throw new Sqlite_Locked(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_NOMEM: throw new Sqlite_Nomem(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_READONLY: throw new Sqlite_Readonly(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_INTERRUPT: throw new Sqlite_Interrupt(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_IOERR: throw new Sqlite_Ioerr(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_CORRUPT: throw new Sqlite_Corrupt(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_NOTFOUND: throw new Sqlite_Notfound(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_FULL: throw new Sqlite_Full(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_CANTOPEN: throw new Sqlite_Cantopen(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_PROTOCOL: throw new Sqlite_Protocol(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_EMPTY: throw new Sqlite_Empty(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_SCHEMA: throw new Sqlite_Schema(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_TOOBIG: throw new Sqlite_Toobig(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_CONSTRAINT: throw new Sqlite_Constraint(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_MISMATCH: throw new Sqlite_Mismatch(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_MISUSE: throw new Sqlite_Misuse(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_NOLFS: throw new Sqlite_Nolfs(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_AUTH: throw new Sqlite_Auth(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_FORMAT: throw new Sqlite_Format(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_RANGE: throw new Sqlite_Range(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_NOTADB: throw new Sqlite_Notadb(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_NOTICE: throw new Sqlite_Notice(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_IOERR_READ: throw new Sqlite_IOErr_Read(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_SHORT_READ: throw new Sqlite_IOErr_Short_Read(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_WRITE: throw new Sqlite_IOErr_Write(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_FSYNC: throw new Sqlite_IOErr_Fsync(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_DIR_FSYNC: throw new Sqlite_IOErr_Dir_Fsync(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_TRUNCATE: throw new Sqlite_IOErr_Truncate(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_FSTAT: throw new Sqlite_IOErr_Fstat(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_UNLOCK: throw new Sqlite_IOErr_Unlock(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_RDLOCK: throw new Sqlite_IOErr_Rdlock(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_DELETE: throw new Sqlite_IOErr_Delete(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_BLOCKED: throw new Sqlite_IOErr_Blocked(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_NOMEM: throw new Sqlite_IOErr_Nomem(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_ACCESS: throw new Sqlite_IOErr_Access(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_CHECKRESERVEDLOCK: 
			throw new Sqlite_IOErr_Checkreservedlock(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_IOERR_LOCK: throw new Sqlite_IOErr_Lock(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_CLOSE: throw new Sqlite_IOErr_Close(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_DIR_CLOSE: throw new Sqlite_IOErr_Dir_Close(
					msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_SHMOPEN: throw new Sqlite_IOErr_Shmopen(
						msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_SHMSIZE: throw new Sqlite_IOErr_Shmsize(
						msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_SHMLOCK: throw new Sqlite_IOErr_Shmlock(
						msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_SHMMAP: throw new Sqlite_IOErr_Shmmap(
					msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_SEEK: throw new Sqlite_IOErr_Seek(
			msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_DELETE_NOENT: 
			throw new Sqlite_IOErr_Delete_Noent(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_IOERR_MMAP: throw new Sqlite_IOErr_Mmap(
			msg ~ ":" ~ errString, file, line);
		case SQLITE_IOERR_GETTEMPPATH: 
			throw new Sqlite_IOErr_Gettemppath(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_IOERR_CONVPATH: throw new Sqlite_IOErr_Convpath(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_LOCKED_SHAREDCACHE: 
			throw new Sqlite_Locked_Sharedcache(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_BUSY_RECOVERY: throw new Sqlite_Busy_Recovery(
						msg ~ ":" ~ errString, file, line);
		case SQLITE_BUSY_SNAPSHOT: throw new Sqlite_Busy_Snapshot(
						msg ~ ":" ~ errString, file, line);
		case SQLITE_CANTOPEN_NOTEMPDIR: 
			throw new Sqlite_CantOpen_NoTempDir(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_CANTOPEN_ISDIR: throw new Sqlite_CantOpen_IsDir(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_CANTOPEN_FULLPATH: 
			throw new Sqlite_CantOpen_FullPath(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_CANTOPEN_CONVPATH: 
			throw new Sqlite_CantOpen_ConvPath(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_CORRUPT_VTAB: throw new Sqlite_Corrupt_Vtab(
					msg ~ ":" ~ errString, file, line);
		case SQLITE_READONLY_RECOVERY: 
			throw new Sqlite_Readonly_Recovery(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_READONLY_CANTLOCK: 
			throw new Sqlite_Readonly_Cantlock(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_READONLY_ROLLBACK: 
			throw new Sqlite_Readonly_Rollback(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_READONLY_DBMOVED: throw new Sqlite_Readonly_DBmoved(
						msg ~ ":" ~ errString, file, line);
		case SQLITE_ABORT_ROLLBACK: throw new Sqlite_Abort_Rollback(
				msg ~ ":" ~ errString, file, line);
		case SQLITE_CONSTRAINT_CHECK: throw new Sqlite_Constraint_Check(
						msg ~ ":" ~ errString, file, line);
		case SQLITE_CONSTRAINT_COMMITHOOK: 
			throw new Sqlite_Constraint_Commithook(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_CONSTRAINT_FOREIGNKEY: 
			throw new Sqlite_Constraint_Foreignkey(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_CONSTRAINT_FUNCTION: 
			throw new Sqlite_Constraint_Function(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_CONSTRAINT_NOTNULL: 
			throw new Sqlite_Constraint_Notnull(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_CONSTRAINT_PRIMARYKEY: 
			throw new Sqlite_Constraint_Primarykey(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_CONSTRAINT_TRIGGER: 
			throw new Sqlite_Constraint_Trigger(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_CONSTRAINT_UNIQUE: 
			throw new Sqlite_Constraint_Unique(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_CONSTRAINT_VTAB: throw new Sqlite_Constraint_Vtab(
					msg ~ ":" ~ errString, file, line);
		case SQLITE_CONSTRAINT_ROWID: throw new Sqlite_Constraint_Rowid(
						msg ~ ":" ~ errString, file, line);
		case SQLITE_NOTICE_RECOVER_WAL: 
			throw new Sqlite_Notice_Recover_Wal(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_NOTICE_RECOVER_ROLLBACK:
			throw new Sqlite_Notice_Recover_Rollback(msg ~ ":" ~ errString,
			 file, line);
		case SQLITE_WARNING_AUTOINDEX: 
			throw new Sqlite_Warning_Autoindex(msg ~ ":" ~ errString,
			 file, line);
		default: throw new Exception(to!string(errCode) ~ " " ~ msg ~ ":" 
			~ errString, file, line);
	}
}
