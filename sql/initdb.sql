CREATE TABLE IF NOT EXISTS message_cache (
	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	message_id int8 NULL,
	channel_id int8 NULL,
	server_id int8 NULL,
	user_id int8 NULL,
	message_time timestamptz NULL,
	"content" varchar(4000) NULL,
	attachments varchar(2000) NULL
);

CREATE TABLE IF NOT EXISTS event_log_channels (
	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	server_id int8 NOT NULL,
	channel_id int8 NOT NULL
);

CREATE TABLE IF NOT EXISTS event_log_blacklist_channels (
	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	server_id int8 NOT NULL,
	channel_id int8 NOT NULL
);

CREATE TABLE IF NOT EXISTS self_roles_blacklist (
	id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	server_id int8 NOT NULL,
	role_id int8 NOT NULL
);