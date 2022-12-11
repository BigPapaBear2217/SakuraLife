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

Config.PoliceStations = {
	LSPD = {
		Blip = {
			Coords  = vector3(617.8, 1.65, 76.63),
			Sprite  = 60,
			Display = 4,
			Scale   = 1.0,
			Colour  = 29
		},

		Cloakrooms = {
			vector3(623.93, -3.42, 76.63),
			vector3(623.14, -7.38, 76.63),

			vector3(625.31, 4.46, 76.63),
			vector3(624.12, 0.32, 76.63),
		},
        
		Armories = {
			vector3(607.78, -20.49, 76.63)
		},
        
		Vehicles = {
			{
				Spawner = vector3(0, 0, 0),
				InsideShop = vector3(462.75900268555, -1015.7895507812, 41.007099151611),
				SpawnPoints = {
					{
                        coords = vector3(594.9, 3.87, 70.63), heading = 171.09, radius = 2.0
                    },
                    
					{
                        coords = vector3(591.13, 5.3, 70.63), heading = 173.51, radius = 2.0
                    },

					{
                        coords = vector3(587.06, 6.11, 70.63), heading = 169.39, radius = 2.0
                    },

					{
                        coords = vector3(583.08, 7.02, 70.63), heading = 171.75, radius = 2.0
                    },

					{
                        coords = vector3(591.89, -11.38, 70.63), heading = 347.51, radius = 2.0
                    },

					{
                        coords = vector3(588.36, -10.9, 70.63), heading = 351.63, radius = 2.0
                    },

					{
                        coords = vector3(584.17, -10.49, 70.63), heading = 351.42, radius = 2.0
                    },

					{
                        coords = vector3(582.75, -15.29, 70.63), heading = 167.79, radius = 2.0
                    },

					{
                        coords = vector3(586.55, -15.52, 70.63), heading = 185.2, radius = 2.0
                    },

					{
                        coords = vector3(590.68, -16.76, 70.63), heading = 170.72, radius = 2.0
                    },
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(570.29, 12.31, 103.23),
				InsideShop = vector3(477.0, -1106.4, 43.0),
				SpawnPoints = {
					{
                        coords = vector3(449.5, -981.2, 43.6),
                        heading = 92.6, radius = 10.0
                    }
				}
			}
		},

		BossActions = {
			vector3(627.1, -31.69, 90.51)
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
    
    officer = {
        {weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_COMBATPDW', components = { 0, 4000, 8000, nil }, price = 0},
	},
    
    detective = {
        {weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_COMBATPDW', components = { 0, 4000, 8000, nil }, price = 0},
    },
    
    sergeant = {
        {weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_COMBATPDW', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_CARBINERIFLE', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
    },
    
    lieutnant = {
        {weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SPECIALCARBINE', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_CARBINERIFLE', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_COMBATPDW', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_BULLPUPRIFLE', components = { 0, 4000, 8000, nil }, price = 0},
    },
    
    commander = {
        {weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_CARBINERIFLE', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SPECIALCARBINE', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_COMBATPDW', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_BULLPUPRIFLE', components = { 0, 4000, 8000, nil }, price = 0},
    },
    
    deputychief = {
        {weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_CARBINERIFLE', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SPECIALCARBINE', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_BULLPUPRIFLE', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_COMBATPDW', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
    },
    
    assistantchief = {
        {weapon = 'WEAPON_FLASHLIGHT', price = 0},
		{weapon = 'WEAPON_NIGHTSTICK', price = 0},
		{weapon = 'WEAPON_STUNGUN', price = 0},
		{weapon = 'WEAPON_COMBATPISTOL', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_CARBINERIFLE', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SPECIALCARBINE', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_BULLPUPRIFLE', components = { 0, 4000, 8000, nil }, price = 0},
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
        {weapon = 'WEAPON_BULLPUPRIFLE', components = { 0, 4000, 8000, nil }, price = 0},
        {weapon = 'WEAPON_COMBATPDW', components = { 0, 4000, 8000, nil }, price = 0},
		{weapon = 'WEAPON_SMG', components = { 0, 4000, 8000, nil }, price = 0},
    },
}

Config.AuthorizedVehicles = {
	car = {
		recruit = {
			{model = 'police3', price = 1},
		},

		officer = {
			{model = 'police3', price = 1},
		},
        
        officer2 = {
			{model = 'police3', price = 1},

		},
        
        officer3 = {
			{model = 'police3', price = 1},
		},

        detective = {
			{model = 'police3', price = 1},

		},
        
        detective2 = {
			{model = 'police3', price = 1},
            {model =  'fib2', price = 1},

		},
        
        detective3 = {
			{model = 'police3', price = 1},
            {model = 'fib2', price = 1},
		},
        
        sergeant = {
            {model =  'fib2', price = 1},
            {model = 'police3', price = 1},
		},
        
        sergeant2 = {
			{model = 'fib2', price = 1},
			{model = 'police3', price = 1},
			{model = 'rmodzl1police', price = 1},
		},
        
        sergeant = {
			{model = 'fib2', price = 1},
			{model = 'police3', price = 1},
			{model = 'rmodzl1police', price = 1},
		},        
        
        lieutnant = {
			{model = 'fib2', price = 1},
			{model = 'police3', price = 1},
			{model = 'rmodzl1police', price = 1},
		},
        
        lieutnant2 = {
			{model = 'fib2', price = 1},
			{model = 'police3', price = 1},
			{model = 'rmodzl1police', price = 1},
		},
        
        commander = {
			{model = 'fib2', price = 1},
			{model = 'police3', price = 1},
			{model = 'rmodzl1police', price = 1},
		},
        
        deputychief = {
			{model = 'fib2', price = 1},
			{model = 'police3', price = 1},
			{model = 'rmodzl1police', price = 1},
		},
        
        assistantchief = {
			{model = 'fib2', price = 1},
			{model = 'police3', price = 1},
			{model = 'rmodzl1police', price = 1},
            {mode = 'pol718', price = 1},
		},
        
        boss = {
			{model = 'fib2', price = 1},
			{model = 'police3', price = 1},
			{model = 'rmodzl1police', price = 1},
            {mode = 'pol718', price = 1},
		},
        
        

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
		}
	},

	helicopter = {
		recruit = {},

		officer = {},

		swat = {
            {model = 'polmav', props = {modLivery = 0}, price = 1}
		},

		lieutenant = {
			{model = 'polmav', props = {modLivery = 0}, price = 1}
		},

		boss = {
			{model = 'polmav', props = {modLivery = 0}, price = 1}
		},
        
        boss = {
            {model = 'polmav', props = {modLivery = 0}, price = 1}
        }
	}
}

Config.CustomPeds = {
	shared = {
	},

	recruit = {},

	officer = {},

	sergeant = {},

	lieutenant = {},

	boss = {
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