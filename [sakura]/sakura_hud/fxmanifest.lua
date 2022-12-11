fx_version 'cerulean'

game 'gta5'

ui_page "html/html.html"
files {
	"html/html.html",
	"html/js/*.js",
	"html/img/*.svg",
	"html/img/*.ttf",
	"html/img/*.png",
	"html/css/*.css"
}

client_scripts {
	"config.lua",
	"client.lua",
}
server_scripts {
	"server.lua",
}