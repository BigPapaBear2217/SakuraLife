Config                            = {}
Config.DrawDistance               = 15
Config.MarkerColor                = {r = 120, g = 120, b = 240}
Config.EnablePlayerManagement     = false -- enables the actual car dealer job. You'll need esx_addonaccount, esx_billing and esx_society
Config.ResellPercentage           = 50

Config.Locale                     = 'en'

Config.LicenseEnable = false -- require people to own drivers license when buying vehicles? Only applies if EnablePlayerManagement is disabled. Requires esx_license

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.Zones = {
	ShopEntering = {
		Pos   = vector3(-940.26654052734,-2962.5024414062,19.845415115356-0.95),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = 1
	},

	ShopInside = {
		Pos     = vector3(-986.79309082031,-2992.0095214844,48.737030029297-0.90),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = -20.0,
		Type    = -1
	},

	ShopOutside = {
		Pos     = vector3(-1002.2913818359,-2935.9638671875,13.950291633606),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 327.19,
		Type    = -1
	},

	ResellVehicle = {
		Pos   = vector3(5544.6, -5080.7, -25.6),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = 1
	}
}
