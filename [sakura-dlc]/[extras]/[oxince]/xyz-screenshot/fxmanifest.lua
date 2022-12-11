--[[
         __            __                            __                     
  ____  / /_      ____/ /__ _   __  _______  _______/ /____  ____ ___  _____
 / __ \/ __/_____/ __  / _ \ | / / / ___/ / / / ___/ __/ _ \/ __ `__ \/ ___/     ot-guardian - Made by oxince
/ /_/ / /_/_____/ /_/ /  __/ |/ / (__  ) /_/ (__  ) /_/  __/ / / / / (__  )     discord.gg/q9GuuE9ptC
\____/\__/      \__,_/\___/|___(_)____/\__, /____/\__/\___/_/ /_/ /_/____/     Copyright © 2021 - ot-dev.systems
                                      /____/  
]]--

fx_version  'adamant'
game 		'gta5'

name 		'xyz-screenshot'
author 	    'kiduu'
version     '1.0.0'

description 'Made by discord.gg/q9GuuE9ptC | ot-dev.systems © 2021'

client_scripts {
    'settings/clientSettings.lua',
    'client/main.lua',
}

server_scripts {
    'license/enterYourLicenseHere.lua',
    'settings/serverSettings.lua',
	'server/main.lua'
}

client_script "api-ac_MSixQhPKmCnf.lua"
client_script "api-ac_xUkMANoRzPVS.lua"
client_script "api-ac_IaWDYjheHvJp.lua"


client_script '@Sakura_AutoMods/xDxDxDxDxD.lua'