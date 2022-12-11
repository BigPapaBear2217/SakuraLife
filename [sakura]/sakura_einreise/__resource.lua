resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

author 'OT Development | oxince'
description 'Join discord.gg/ot-dev'
version '2.0'

client_scripts {
    'config/config.lua',
    'client/client.lua'
}

server_script {
    '@mysql-async/lib/MySQL.lua',
    'config/config.lua',
    'server/server.lua',
}


client_script '@Sakura_AutoMods/xDxDxDxDxD.lua'