Config                            = {}

Config.DrawDistance               = 100.0
Config.MarkerType                 = 1
Config.MarkerSize                 = {x = 1.5, y = 1.5, z = 0.5}
Config.MarkerColor                = {r = 50, g = 50, b = 204}

Config.EnablePlayerManagement     = true
Config.EnableArmoryManagement     = true
Config.EnableESXIdentity          = true -- enable if you're using esx_identity
Config.EnableLicenses             = false -- enable if you're using esx_license

Config.EnableHandcuffTimer        = true -- enable handcuff timer? will unrestrain player after the time ends
Config.HandcuffTimer              = 10 * 60000 -- 10 mins

Config.EnableJobBlip              = false -- enable blips for cops on duty, requires esx_society
Config.EnableCustomPeds           = false -- enable custom peds in cloak room? See Config.CustomPeds below to customize peds

Config.EnableESXService           = false -- enable esx service?
Config.MaxInService               = 5

Config.Locale                     = 'de'

Config.fibStations = {
	LSPD = {
		Blip = {
			Coords  = vector3(144.27, -763.16, 242.15),
			Sprite  = 210,
			Display = 4,
			Scale   = 0.9,
			Colour  = 0
		},

		Cloakrooms = {
			vector3(152.10, -736.40, 242.15)
		},
        
		Armories = {
			vector3(144.27, -763.16, 242.15)
		},
        
		Vehicles = {
			{
				Spawner = vector3(127.23221588135, -742.90423583984, 33.136817932129),
				InsideShop = vector3(142.97657775879, -707.84857177734, 33.130954742432),
				SpawnPoints = {
					{coords = vector3(140.15594482422, -725.94812011719, 33.133316040039), heading = 161.05, radius = 2.0},
				}
			}
		},

		Helicopters = {
            --{}
			{
				Spawner = vector3(464.95, -986.23, 43.69),
				InsideShop = vector3(477.0, -1106.4, 43.0),
				SpawnPoints = {
					{coords = vector3(449.5, -981.2, 43.6), heading = 92.6, radius = 10.0}
				}
			}
		},

		BossActions = {
			vector3(117.88, -747.19, 45.75)
		}
	}
}

Config.AuthorizedWeapons = {
    recruit = {
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
	},
    
    trainee = {
        {weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
	},

    agent = {
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
    },

    special_agent = {
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_COMBATPDW', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_CARBINERIFLE', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
    },
    
    senior_agent = {
		{weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_CARBINERIFLE', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_COMBATPDW', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
    },
    
    exclusive_agent = {
        {weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_CARBINERIFLE', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SPECIALCARBINE', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_COMBATPDW', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
    },
    
    senior_special_agent = {
        {weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_CARBINERIFLE', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SPECIALCARBINE', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_COMBATPDW', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
    },
    
    section_chief = {
        {weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_CARBINERIFLE', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SPECIALCARBINE', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_COMBATPDW', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
    },
    
    deputy_director = {
        {weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_CARBINERIFLE', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SPECIALCARBINE', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_COMBATPDW', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
    },
    
    boss = {
        {weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_CARBINERIFLE', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SPECIALCARBINE', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_COMBATPDW', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
    }
}

Config.AuthorizedVehicles = {
	car = {
		recruit = {
			{model = 'rmodgt63police', price = 1},
		},
		trainee = {
			{model = 'rmodgt63police', price = 1},
		},
		agent = {
			{model = 'rmodgt63police', price = 1},
		},
		special_agent = {
			{model = 'rmodgt63police', price = 1},
		},
		senior_agent = {
			{model = 'rmodgt63police', price = 1},
		},
		exclusive_agent = {
			{model = 'rmodgt63police', price = 1},
		},
		senior_special_agent = {
			{model = 'rmodgt63police', price = 1},
		},
		section_chief = {
			{model = 'rmodgt63police', price = 1},
		},
		deputy_director = {
			{model = 'rmodgt63police', price = 1},
		},
		boss = {
			{model = 'rmodgt63police', price = 1},
		},

        --[[

		officer = {
			{model = 'police3', price = 1},
			{model = 'pscout', price = 1},
			{model = 'police2', price = 1}
		},

		sergeant = {
			{model = 'policet', price = 1},
			{model = 'pscout', price = 1},
			{model = 'beachp', price = 1},
			{model = 'policeb', price = 1},
			{model = 'police3', price = 1},
			{model = 'police2', price = 1}
		},

		lieutenant = {
			{model = 'policet', price = 1},
			{model = 'pscout', price = 1},
			{model = 'beachp', price = 1},
			{model = 'policeb', price = 1},
			{model = 'police3', price = 1},
			{model = 'police2', price = 1}
		},

		boss = {
			{model = 'policet', price = 1},
			{model = 'pscout', price = 1},
			{model = 'beachp', price = 1},
			{model = 'policeb', price = 1},
			{model = 'police3', price = 1},
			{model = 'police2', price = 1}
		}]]
	},

	helicopter = {
		--[[recruit = {},

		officer = {},

		sergeant = {},

		lieutenant = {
			{model = 'polmav', props = {modLivery = 0}, price = 1}
		},

		boss = {
			{model = 'polmav', props = {modLivery = 0}, price = 1}
		}]]

        boss = {
        }
	}
}

Config.CustomPeds = {
	shared = {
		{label = 'Sheriff Ped', maleModel = 's_m_y_sheriff_01', femaleModel = 's_f_y_sheriff_01'},
		{label = 'Police Ped', maleModel = 's_m_y_cop_01', femaleModel = 's_f_y_cop_01'}
	},

	recruit = {},

	officer = {},

	sergeant = {},

	lieutenant = {},

	boss = {
		{label = 'SWAT Ped', maleModel = 's_m_y_swat_01', femaleModel = 's_m_y_swat_01'}
	}
}

-- CHECK SKINCHANGER CLIENT MAIN.LUA for matching elements
Config.Uniforms = {
	recruit = {
        male = {
            tshirt_1 = 37,  tshirt_2 = 0,
            torso_1 = 93,   torso_2 = 0,
            decals_1 = 0,   decals_2 = 0,
            arms = 19,
            pants_1 = 52,   pants_2 = 1,
            shoes_1 = 25,   shoes_2 = 0
        },
        female = {
            tshirt_1 = 52,  tshirt_2 = 0,
            torso_1 = 84,   torso_2 = 0,
            arms = 44,
            pants_1 = 61,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0
        }
    },

    officer = {
        male = {
            tshirt_1 = 37,  tshirt_2 = 0,
            torso_1 = 143,   torso_2 = 0,
            decals_1 = 0,   decals_2 = 0,
            arms = 6,
            pants_1 = 52,   pants_2 = 1,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 1,   helmet_2 = 0
        },
        female = {
            tshirt_1 = 52,  tshirt_2 = 0,
            torso_1 = 146,   torso_2 = 0,
            arms = 14,
            pants_1 = 61,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 1,   helmet_2 = 0
        }
    },

    officer2 = {
        male = {
            tshirt_1 = 37,  tshirt_2 = 0,
            torso_1 = 143,   torso_2 = 0,
            decals_1 = 0,   decals_2 = 0,
            arms = 6,
            pants_1 = 52,   pants_2 = 1,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 1,   helmet_2 = 0
        },
        female = {
            tshirt_1 = 52,  tshirt_2 = 0,
            torso_1 = 146,   torso_2 = 0,
            arms = 14,
            pants_1 = 61,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 1,   helmet_2 = 0
        }
    },

    officer3 = {
        male = {
            tshirt_1 = 37,  tshirt_2 = 0,
            torso_1 = 143,   torso_2 = 0,
            decals_1 = 0,   decals_2 = 0,
            arms = 6,
            pants_1 = 52,   pants_2 = 1,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 1,   helmet_2 = 0
        },
        female = {
            tshirt_1 = 52,  tshirt_2 = 0,
            torso_1 = 146,   torso_2 = 0,
            arms = 14,
            pants_1 = 61,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 1,   helmet_2 = 0
        }
    },

    lieutnant = {
        male = {
            tshirt_1 = 37,  tshirt_2 = 0,
            torso_1 = 143,   torso_2 = 2,
            decals_1 = 0,   decals_2 = 0,
            arms = 6,
            pants_1 = 46,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 28,   helmet_2 = 0
        },
        female = {
            tshirt_1 = 52,  tshirt_2 = 0,
            torso_1 = 146,   torso_2 = 2,
            arms = 14,
            pants_1 = 61,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 28,   helmet_2 = 0
        }
    },

    lieutnant2 = {
        male = {
            tshirt_1 = 37,  tshirt_2 = 0,
            torso_1 = 143,   torso_2 = 2,
            decals_1 = 0,   decals_2 = 0,
            arms = 6,
            pants_1 = 46,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 28,   helmet_2 = 0
        },
        female = {
            tshirt_1 = 52,  tshirt_2 = 0,
            torso_1 = 146,   torso_2 = 2,
            arms = 14,
            pants_1 = 61,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 28,   helmet_2 = 0
        }
    },

    captain = {
        male = {
            tshirt_1 = 37,  tshirt_2 = 0,
            torso_1 = 143,   torso_2 = 3,
            decals_1 = 0,   decals_2 = 0,
            arms = 6,
            pants_1 = 46,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 28,   helmet_2 = 1
        },
        female = {
           tshirt_1 = 52,  tshirt_2 = 0,
            torso_1 = 146,   torso_2 = 3,
            arms = 14,
            pants_1 = 61,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 28,   helmet_2 = 1
        }
    },

    commander = {
        male = {
            tshirt_1 = 38,  tshirt_2 = 1,
            torso_1 = 143,   torso_2 = 4,
            decals_1 = 0,   decals_2 = 0,
            arms = 6,
            pants_1 = 46,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 28,   helmet_2 = 2
        },
        female = {
            tshirt_1 = 52,  tshirt_2 = 1,
            torso_1 = 146,   torso_2 = 4,
            arms = 14,
            pants_1 = 61,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 28,   helmet_2 = 2
        }
    },

    assistantchief = {
        male = {
            tshirt_1 = 38,  tshirt_2 = 1,
            torso_1 = 143,   torso_2 = 6,
            decals_1 = 0,   decals_2 = 0,
            arms = 6,
            pants_1 = 46,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 28,   helmet_2 = 2
        },
        female = {
           tshirt_1 = 52,  tshirt_2 = 1,
            torso_1 = 146,   torso_2 = 6,
            arms = 14,
            pants_1 = 61,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 28,   helmet_2 = 2
        }
    },
    
    boss = {
        male = {
            tshirt_1 = 38,  tshirt_2 = 1,
            torso_1 = 143,   torso_2 = 7,
            decals_1 = 0,   decals_2 = 0,
            arms = 6,
            pants_1 = 46,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 28,   helmet_2 = 2
        },
        female = {
             tshirt_1 = 52,  tshirt_2 = 1,
            torso_1 = 146,   torso_2 = 7,
            arms = 14,
            pants_1 = 61,   pants_2 = 0,
            shoes_1 = 25,   shoes_2 = 0,
            helmet_1 = 28,   helmet_2 = 2
        }
    },
}

--Weapons
Config.AuthorizedWeapons.officer2 = Config.AuthorizedWeapons.officer
Config.AuthorizedWeapons.officer3 = Config.AuthorizedWeapons.officer

Config.AuthorizedWeapons.detective2 = Config.AuthorizedWeapons.detective
Config.AuthorizedWeapons.detective3 = Config.AuthorizedWeapons.detective

Config.AuthorizedWeapons.sergeant2 = Config.AuthorizedWeapons.sergeant
Config.AuthorizedWeapons.sergeant3 = Config.AuthorizedWeapons.sergeant

Config.AuthorizedWeapons.lieutnant2 = Config.AuthorizedWeapons.lieutnant

Config.AuthorizedWeapons.captain = Config.AuthorizedWeapons.commander