fx_version 'cerulean'
game 'gta5'

description 'Syncs weather and time of day between players'
repository 'https://github.com/Qbox-project/qbx-weathersync'
version '2.0.0'

shared_scripts {
	'@qbx-core/import.lua',
	'config.lua',
	'@qbx-core/shared/locale.lua',
	'locales/en.lua',
  	'@ox_lib/init.lua'
}

server_script 'server/server.lua'
client_script 'client/client.lua'

modules {
	'qbx-core:core'
}

lua54 'yes'
