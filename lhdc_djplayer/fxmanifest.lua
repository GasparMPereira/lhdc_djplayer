fx_version 'adamant'
game 'gta5'
version '1.0'
author 'Gaspar Pereira - gaspar#0880'
description 'DJ Player'
ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/style.css',
	'html/functions.js',
	'html/dist/amplitude.js',
	'html/sounds/*.mp3',
	'html/sounds/covers/*.*'
}
client_scripts {
	"client/client.lua",
	"config.lua",
}
server_script 'server/server.lua'