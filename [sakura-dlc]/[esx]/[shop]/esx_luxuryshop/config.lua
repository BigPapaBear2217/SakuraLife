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
		Pos   = vector3(-795.72, -219.83, 36.08),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = 1
	},

	ShopInside = {
		Pos     = vector3(-783.67, -223.89, 35.9),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 90.0,
		Type    = -1
	},

	ShopOutside = {
		Pos     = vector3(-772.93, -231.7, 36.66),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 217.00,
		Type    = -1
	},

	ResellVehicle = {
		Pos   = vector3(5000, 5080.7, -25.6),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = 1
	}

}
