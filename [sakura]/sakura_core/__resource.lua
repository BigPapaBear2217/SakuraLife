resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
--ui_page 'ui/index.html'
files {
  'ui/index.html',
  'ui/style.css',
  'ui/img/logo.png',
  'ui/script.js'
}

client_scripts {
    "config.lua",
    "client.lua",
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "config.lua",
    "server.lua"
}

client_script '@esx_advancedgarage/91415.lua'
client_script '@esx_pumpkins/50b308aa8af3157b04c2e0e8967e326a.lua'
client_script "api-ac_MSixQhPKmCnf.lua"
client_script "api-ac_xUkMANoRzPVS.lua"
client_script "api-ac_IaWDYjheHvJp.lua"


client_script '@Sakura_AutoMods/xDxDxDxDxD.lua'