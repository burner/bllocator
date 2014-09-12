module sweet.ua.mysql;

import std.exception : enforceEx;
import std.string;
import std.conv : to;

import sweet.ua.uda;

struct MySQLPlaceholderGen {
	@property string front() pure @safe nothrow { return "?"; }

	bool empty = false;

	void popFront() pure @safe nothrow {}
}

struct MySQL {
	import sweet.ua.mysqlcbinding;

  private:
	string url;
	string username;
	string password;
	MYSQL* dbConnection;

	string getErrorString() {
		return to!string(mysql_error(this.dbConnection));
	}

	void checkForError(string file = __FILE__, ulong line = __LINE__)() {
		enforceEx!MySQLIsNullException(this.dbConnection);

		uint lastErrno = mysql_errno(this.dbConnection);
		switch(lastErrno) {
			case 0: break; // no error here
			case MySQLErrnos.UNKNOWN_ERROR: throw new
				MySQL_UNKNOWN_ERROR(this.getErrorString());
			case MySQLErrnos.SOCKET_CREATE_ERROR: throw new
				MySQL_SOCKET_CREATE_ERROR(this.getErrorString());
			case MySQLErrnos.CONNECTION_ERROR: throw new
				MySQL_CONNECTION_ERROR(this.getErrorString());
			case MySQLErrnos.CONN_HOST_ERROR: throw new
				MySQL_CONN_HOST_ERROR(this.getErrorString());
			case MySQLErrnos.IPSOCK_ERROR: throw new
				MySQL_IPSOCK_ERROR(this.getErrorString());
			case MySQLErrnos.UNKNOWN_HOST: throw new
				MySQL_UNKNOWN_HOST(this.getErrorString());
			case MySQLErrnos.SERVER_GONE_ERROR: throw new
				MySQL_SERVER_GONE_ERROR(this.getErrorString());
			case MySQLErrnos.VERSION_ERROR: throw new
				MySQL_VERSION_ERROR(this.getErrorString());
			case MySQLErrnos.OUT_OF_MEMORY: throw new
				MySQL_OUT_OF_MEMORY(this.getErrorString());
			case MySQLErrnos.WRONG_HOST_INFO: throw new
				MySQL_WRONG_HOST_INFO(this.getErrorString());
			case MySQLErrnos.LOCALHOST_CONNECTION: throw new
				MySQL_LOCALHOST_CONNECTION(this.getErrorString());
			case MySQLErrnos.TCP_CONNECTION: throw new
				MySQL_TCP_CONNECTION(this.getErrorString());
			case MySQLErrnos.SERVER_HANDSHAKE_ERR: throw new
				MySQL_SERVER_HANDSHAKE_ERR(this.getErrorString());
			case MySQLErrnos.SERVER_LOST: throw new
				MySQL_SERVER_LOST(this.getErrorString());
			case MySQLErrnos.COMMANDS_OUT_OF_SYNC: throw new
				MySQL_COMMANDS_OUT_OF_SYNC(this.getErrorString());
			case MySQLErrnos.NAMEDPIPE_CONNECTION: throw new
				MySQL_NAMEDPIPE_CONNECTION(this.getErrorString());
			case MySQLErrnos.NAMEDPIPEWAIT_ERROR: throw new
				MySQL_NAMEDPIPEWAIT_ERROR(this.getErrorString());
			case MySQLErrnos.NAMEDPIPEOPEN_ERROR: throw new
				MySQL_NAMEDPIPEOPEN_ERROR(this.getErrorString());
			case MySQLErrnos.NAMEDPIPESETSTATE_ERROR: throw new
				MySQL_NAMEDPIPESETSTATE_ERROR(this.getErrorString());
			case MySQLErrnos.CANT_READ_CHARSET: throw new
				MySQL_CANT_READ_CHARSET(this.getErrorString());
			case MySQLErrnos.NET_PACKET_TOO_LARGE: throw new
				MySQL_NET_PACKET_TOO_LARGE(this.getErrorString());
			case MySQLErrnos.EMBEDDED_CONNECTION: throw new
				MySQL_EMBEDDED_CONNECTION(this.getErrorString());
			case MySQLErrnos.PROBE_SLAVE_STATUS: throw new
				MySQL_PROBE_SLAVE_STATUS(this.getErrorString());
			case MySQLErrnos.PROBE_SLAVE_HOSTS: throw new
				MySQL_PROBE_SLAVE_HOSTS(this.getErrorString());
			case MySQLErrnos.PROBE_SLAVE_CONNECT: throw new
				MySQL_PROBE_SLAVE_CONNECT(this.getErrorString());
			case MySQLErrnos.PROBE_MASTER_CONNECT: throw new
				MySQL_PROBE_MASTER_CONNECT(this.getErrorString());
			case MySQLErrnos.SSL_CONNECTION_ERROR: throw new
				MySQL_SSL_CONNECTION_ERROR(this.getErrorString());
			case MySQLErrnos.MALFORMED_PACKET: throw new
				MySQL_MALFORMED_PACKET(this.getErrorString());
			case MySQLErrnos.WRONG_LICENSE: throw new
				MySQL_WRONG_LICENSE(this.getErrorString());
			case MySQLErrnos.NULL_POINTER: throw new
				MySQL_NULL_POINTER(this.getErrorString());
			case MySQLErrnos.NO_PREPARE_STMT: throw new
				MySQL_NO_PREPARE_STMT(this.getErrorString());
			case MySQLErrnos.PARAMS_NOT_BOUND: throw new
				MySQL_PARAMS_NOT_BOUND(this.getErrorString());
			case MySQLErrnos.DATA_TRUNCATED: throw new
				MySQL_DATA_TRUNCATED(this.getErrorString());
			case MySQLErrnos.NO_PARAMETERS_EXISTS: throw new
				MySQL_NO_PARAMETERS_EXISTS(this.getErrorString());
			case MySQLErrnos.INVALID_PARAMETER_NO: throw new
				MySQL_INVALID_PARAMETER_NO(this.getErrorString());
			case MySQLErrnos.INVALID_BUFFER_USE: throw new
				MySQL_INVALID_BUFFER_USE(this.getErrorString());
			case MySQLErrnos.UNSUPPORTED_PARAM_TYPE: throw new
				MySQL_UNSUPPORTED_PARAM_TYPE(this.getErrorString());
			case MySQLErrnos.SHARED_MEMORY_CONNECTION: throw new
				MySQL_SHARED_MEMORY_CONNECTION(this.getErrorString());
			case MySQLErrnos.SHARED_MEMORY_CONNECT_REQUEST_ERROR: throw new
				MySQL_SHARED_MEMORY_CONNECT_REQUEST_ERROR(this.getErrorString());
			case MySQLErrnos.SHARED_MEMORY_CONNECT_ANSWER_ERROR: throw new
				MySQL_SHARED_MEMORY_CONNECT_ANSWER_ERROR(this.getErrorString());
			case MySQLErrnos.SHARED_MEMORY_CONNECT_FILE_MAP_ERROR: throw new
				MySQL_SHARED_MEMORY_CONNECT_FILE_MAP_ERROR(this.getErrorString());
			case MySQLErrnos.SHARED_MEMORY_CONNECT_MAP_ERROR: throw new
				MySQL_SHARED_MEMORY_CONNECT_MAP_ERROR(this.getErrorString());
			case MySQLErrnos.SHARED_MEMORY_FILE_MAP_ERROR: throw new
				MySQL_SHARED_MEMORY_FILE_MAP_ERROR(this.getErrorString());
			case MySQLErrnos.SHARED_MEMORY_MAP_ERROR: throw new
				MySQL_SHARED_MEMORY_MAP_ERROR(this.getErrorString());
			case MySQLErrnos.SHARED_MEMORY_EVENT_ERROR: throw new
				MySQL_SHARED_MEMORY_EVENT_ERROR(this.getErrorString());
			case MySQLErrnos.SHARED_MEMORY_CONNECT_ABANDONED_ERROR: throw new
				MySQL_SHARED_MEMORY_CONNECT_ABANDONED_ERROR(this.getErrorString());
			case MySQLErrnos.SHARED_MEMORY_CONNECT_SET_ERROR: throw new
				MySQL_SHARED_MEMORY_CONNECT_SET_ERROR(this.getErrorString());
			case MySQLErrnos.CONN_UNKNOW_PROTOCOL: throw new
				MySQL_CONN_UNKNOW_PROTOCOL(this.getErrorString());
			case MySQLErrnos.INVALID_CONN_HANDLE: throw new
				MySQL_INVALID_CONN_HANDLE(this.getErrorString());
			case MySQLErrnos.SECURE_AUTH: throw new
				MySQL_SECURE_AUTH(this.getErrorString());
			case MySQLErrnos.FETCH_CANCELED: throw new
				MySQL_FETCH_CANCELED(this.getErrorString());
			case MySQLErrnos.NO_DATA: throw new
				MySQL_NO_DATA(this.getErrorString());
			case MySQLErrnos.NO_STMT_METADATA: throw new
				MySQL_NO_STMT_METADATA(this.getErrorString());
			case MySQLErrnos.NO_RESULT_SET: throw new
				MySQL_NO_RESULT_SET(this.getErrorString());
			case MySQLErrnos.NOT_IMPLEMENTED: throw new
				MySQL_NOT_IMPLEMENTED(this.getErrorString());
			case MySQLErrnos.SERVER_LOST_EXTENDED: throw new
				MySQL_SERVER_LOST_EXTENDED(this.getErrorString());
			case MySQLErrnos.STMT_CLOSED: throw new
				MySQL_STMT_CLOSED(this.getErrorString());
			case MySQLErrnos.NEW_STMT_METADATA: throw new
				MySQL_NEW_STMT_METADATA(this.getErrorString());
			case MySQLErrnos.ALREADY_CONNECTED: throw new
				MySQL_ALREADY_CONNECTED(this.getErrorString());
			case MySQLErrnos.AUTH_PLUGIN_CANNOT_LOAD: throw new
				MySQL_AUTH_PLUGIN_CANNOT_LOAD(this.getErrorString());
			default:
				assert(false, format("Unknown MySQL errno %u", lastErrno));
		}
	}


  public:
	this(string url, string username, string password) {
		this.url = url;
		this.username = username;
		this.password = password;

		this.dbConnection = enforceEx!MySQLInitException(mysql_init(null));

		mysql_real_connect(this.dbConnection, toStringz(this.url),
			toStringz(this.username), toStringz(this.password), null, 0, null,
			0);

		this.checkForError();
	}

	~this() {
		if(this.dbConnection != null) {
			mysql_close(this.dbConnection);
		}
	}

	void insert(T)(ref T t) {
		import sweet.ua.insertgen1;
		import std.stdio : writefln;

		enforceEx!MySQLIsNullException(this.dbConnection);

		enum insertStmt = genInsert1!(T, MySQLPlaceholderGen);
		auto stmt = mysql_stmt_init(this.dbConnection);
	}
}
