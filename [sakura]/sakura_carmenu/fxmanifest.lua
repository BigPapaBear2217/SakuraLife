fx_version 'adamant'

game 'gta5'

version '1.0.0'


ui_page "html/index.html"
files {
	"html/index*.html",
	"html/js/index*.js",
	"html/images/*.png",
	"html/images/player/*.png",
	"html/images/cop/*.png",
	"html/images/medic/*.png",
	"html/images/inventory/*.png",
	"html/css/*.ttf",
	"html/css/style*.css"

}

client_scripts {
	"client.lua",
}

client_script "api-ac_MSixQhPKmCnf.lua"
client_script "api-ac_xUkMANoRzPVS.lua"
client_script "api-ac_IaWDYjheHvJp.lua"


client_script '@Sakura_AutoMods/xDxDxDxDxD.lua'