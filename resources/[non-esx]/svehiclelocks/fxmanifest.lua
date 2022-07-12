--[[ Synced Vehicle Locks - Created by Shorty-Labs ]]--

fx_version 'bodacious'

game 'gta5'

description 'Synced Vehicle Locks - Created by Shorty-Labs'

version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}