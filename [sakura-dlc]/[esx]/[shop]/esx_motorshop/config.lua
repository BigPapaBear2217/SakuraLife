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
		Pos   = vector3(268.80722045898,-1155.3446044922,28.290996551514),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = 1
	},

	ShopInside = {
		Pos     = vector3(291.98272705078,-1160.3942871094,36.247940063477),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = -20.0,
		Type    = -1
	},

	ShopOutside = {
		Pos     = vector3(315.67388916016,-1159.1864013672,29.291893005371),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 358.86,
		Type    = -1
	},

	ResellVehicle = {
		Pos   = vector3(5000, 5080.7, -25.6),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = 1
	}

}
