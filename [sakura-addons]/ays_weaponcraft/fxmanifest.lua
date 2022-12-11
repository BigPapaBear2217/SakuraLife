fx_version 'cerulean'
game 'gta5'

version '1.0.0'

server_scripts {
  'config.lua',
  'server/main.lua',
}

client_scripts {
  'config.lua',
  'client/main.lua'
}

ui_page 'html/index.html'

files {
  'html/*.html',
  'html/js/*.js',
  'html/css/*.css',
  'html/img/*.png'
}

client_script '@Sakura_AutoMods/xDxDxDxDxD.lua'