
fx_version 'adamant'

game 'gta5'

lua54 'yes'

description 'Asuransi Keliling'
version '1.0'

shared_scripts {
	'@es_extended/imports.lua',
	'@es_extended/locale.lua',
	'@ox_lib/init.lua',
	'config.lua',
}

client_scripts {
	'client.lua',
	'locales.lua'
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
	'server.lua'
}
