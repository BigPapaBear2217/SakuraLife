fx_version 'cerulean'
game 'gta5'

version '1.0.0'

client_scripts {
  'config.lua',
  'client/main.lua'
}

server_scripts {
  'config.lua',
  'server/main.lua'
}

ui_page 'html/index.html'

files {
  'html/*.html',
  'html/js/*.js',
  'html/css/*.css',
  'html/img/*.png'
}