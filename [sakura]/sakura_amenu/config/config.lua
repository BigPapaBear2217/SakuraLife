Config = {}

Config.Locale = 'de'
Config.SharedObject = "esx:getSharedObject"

Config.Menu = {
    serverName = "Administrator Menü",
    --custom heading of rageui
    customHeading = false,
    --Custom Image (Gifs also Working)
    customHeadingUrl = "https://media.discordapp.net/attachments/918096952502157353/920138795700064256/1024.png",
    --leave it false if you are using a custom Heading
    customHeadingText = false,
    headingText = "Sakura"
}

Config.DefaultKeys = {
    -- KeyBinds in QWERTY and lowercase
    openMenu = 'F4',
    noClip = '+' 
}

Config.Modules = {
    {
        name = 'ot-admin',
        auhorizedGroups = {
            'superadmin',
            'admin',
            'guide',
            'supporter',
            'management',
            'mod'
        },
    },
    {
        name = 'aduty',
        auhorizedGroups = {
            'mod',
            'management',
            'supporter',
            'admin',
            'superadmin'
        },
    }, 
    {
        name = 'godmode',
        auhorizedGroups = {
            'superadmin',
            'mod'
        },
    }, 
    {
        name = 'vanish',
        auhorizedGroups = {
            'mod',
            'management',
            'admin',
            'superadmin'
        },
    }, 
    {
        name = 'nametags',
        auhorizedGroups = {
            'guide',
            'management',
            'supporter',
            'mod',
            'admin',
            'superadmin'
        },
    }, 
    {
        name = 'coords',
        auhorizedGroups = {
            'mod',
            'management',
            'supporter',
            'admin',
            'superadmin'
        },
    }, 
    {
        name = 'noclip',
        auhorizedGroups = {
            'mod',
            'supporter',
            'management',
            'admin',
            'superadmin'
        },
    }     
}

--You must configure this for your Groups!
Config.AdminDuty = {
    ["superadmin"] = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 287,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 3,
            ['pants_1'] = 114,   ['pants_2'] = 2,
            ['shoes_1'] = 78,   ['shoes_2'] = 2,
            ['helmet_1'] = -1,  ['helmet_2'] = 2,
            ['mask_1'] = 135,  ['mask_2'] = 2,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 0,     ['bags_2'] = 0,
            ['hair_1'] = 0,     ['hair_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0
        },

        female = {
            ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
            ['torso_1'] = 300,   ['torso_2'] = 13,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 8,
            ['pants_1'] = 121,   ['pants_2'] = 13,
            ['shoes_1'] = 82,   ['shoes_2'] = 13,
            ['helmet_1'] = -1,  ['helmet_2'] = 13,
            ['mask_1'] = 135,  ['mask_2'] = 13,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 0,     ['bags_2'] = 0,
            ['hair_1'] = 0,     ['hair_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0
        }
    },

    ["admin"] = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 287,   ['torso_2'] = 7,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 3,
            ['pants_1'] = 114,   ['pants_2'] = 7,
            ['shoes_1'] = 78,   ['shoes_2'] = 7,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['mask_1'] = 135,  ['mask_2'] = 7,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 0,     ['bags_2'] = 0,
            ['hair_1'] = 0,     ['hair_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0
        },

        female = {
            ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
            ['torso_1'] = 300,   ['torso_2'] = 7,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 8,
            ['pants_1'] = 121,   ['pants_2'] = 7,
            ['shoes_1'] = 82,   ['shoes_2'] = 7,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['mask_1'] = 135,  ['mask_2'] = 7,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 0,     ['bags_2'] = 0,
            ['hair_1'] = 0,     ['hair_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0
        } 
    },

    ["supporter"] = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 287,   ['torso_2'] = 5,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 3,
            ['pants_1'] = 114,   ['pants_2'] = 5,
            ['shoes_1'] = 78,   ['shoes_2'] = 5,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['mask_1'] = 135,  ['mask_2'] = 5,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 0,     ['bags_2'] = 0,
            ['hair_1'] = 0,     ['hair_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0
        },

        female = {
            ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
            ['torso_1'] = 300,   ['torso_2'] = 5,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 8,
            ['pants_1'] = 121,   ['pants_2'] = 2,
            ['shoes_1'] = 82,   ['shoes_2'] = 2,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['mask_1'] = 135,  ['mask_2'] = 2,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 0,     ['bags_2'] = 0,
            ['hair_1'] = 0,     ['hair_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0
        } 
    },

    ["management"] = {
        male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 287,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 3,
            ['pants_1'] = 114,   ['pants_2'] = 2,
            ['shoes_1'] = 78,   ['shoes_2'] = 2,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['mask_1'] = 135,  ['mask_2'] = 2,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 0,     ['bags_2'] = 0,
            ['hair_1'] = 0,     ['hair_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0
        },

        female = {
            ['tshirt_1'] = 14,  ['tshirt_2'] = 0,
            ['torso_1'] = 300,   ['torso_2'] = 2,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 8,
            ['pants_1'] = 121,   ['pants_2'] = 2,
            ['shoes_1'] = 82,   ['shoes_2'] = 2,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['mask_1'] = 135,  ['mask_2'] = 2,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = -1,     ['ears_2'] = 0,
            ['bags_1'] = 0,     ['bags_2'] = 0,
            ['hair_1'] = 0,     ['hair_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0
        } 
    },

    ["mod"] = {
       male = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 287,   ['torso_2'] = 4,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 3,
            ['pants_1'] = 114,   ['pants_2'] = 4,
            ['shoes_1'] = 78,   ['shoes_2'] = 4,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['mask_1'] = 135,  ['mask_2'] = 4,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = 0,     ['ears_2'] = 0,
            ['bags_1'] = 0,     ['bags_2'] = 0,
            ['hair_1'] = 0,     ['hair_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0
        },
        female = {
            ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
            ['torso_1'] = 300,   ['torso_2'] = 9,
            ['decals_1'] = 0,   ['decals_2'] = 0,
            ['arms'] = 8,
            ['pants_1'] = 121,   ['pants_2'] = 9,
            ['shoes_1'] = 82,   ['shoes_2'] = 9,
            ['helmet_1'] = -1,  ['helmet_2'] = 0,
            ['mask_1'] = 153,  ['mask_2'] = 9,
            ['chain_1'] = 0,    ['chain_2'] = 0,
            ['ears_1'] = 0,     ['ears_2'] = 0,
            ['bags_1'] = 0,     ['bags_2'] = 0,
            ['hair_1'] = 0,     ['hair_2'] = 0,
            ['bproof_1'] = 0,  ['bproof_2'] = 0
        } 
    }
}
