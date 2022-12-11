resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Namechange @Ali'


ui_page 'html/ui.html'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/server.lua'
}

client_scripts {
	'config.lua',
	'client/client.lua',
	'client/blip.lua',
	'client/ped.lua'
}

files {
	'html/study.png', 
	'html/ui.css',
	'html/index.js',
	'html/ui.html'
}