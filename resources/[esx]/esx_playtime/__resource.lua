resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "Simple script which can store player play time and do some stuff with that"

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	"server.lua",
	"config.lua"
}

client_scripts {
	"client.lua",
	"config.lua"
}

dependencies {
	'mysql-async',
	'essentialmode',
	'esplugin_mysql',
	'async',
	'es_extended'
}