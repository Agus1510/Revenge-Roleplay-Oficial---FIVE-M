resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX AIO Menu'

version '3.0.1'

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

dependencies {
    'es_extended',
    'esx_billing',
    'esx_voice',
    'esx_animations',
    'esx_policejob',
    'esx_mecanojob',
    'esx_taxijob',
	'clothesmerfik',
	'dpemotes',
    'idcard'
}
