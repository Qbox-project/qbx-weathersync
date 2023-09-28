fx_version 'cerulean'
game 'gta5'

description 'Syncs weather and time of day between players'
repository 'https://github.com/Qbox-project/qbx_weathersync'
version '2.0.0'

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
	'@qbx_core/shared/locale.lua',
	'locales/en.lua',
}

server_script 'server/server.lua'
client_script 'client/client.lua'

lua54 'yes'
