Config = {}
Config.Locale = 'en'

Config.DrawDistance = 100
Config.MarkerColor  = {r = 120, g = 120, b = 240}

Config.ResellPercentage = 50
Config.LicenseEnable    = false
Config.LicensePrice     = 25000

-- looks like this: 'LLL NNN'
-- The maximum plate length is 8 chars (including spaces & symbols), don't go past it!
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true

Config.Zones = {
	ShopEntering = { -- Marker for Accessing Shop
		Pos   = vector3(-774.58, -2632.43, 13.94),
		Size  = {x = 1.5, y = 1.5, z = 1.0},
		Type  = 1
	},
	ShopInside = { -- Marker for Viewing Vehicles
		Pos     = vector3(-803.81, -2690.88, 13.39), -- vector3(-1075.0, -2933.2, 14.5),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 329.95, -- 59.9
		Type    = -1
	},
	ShopOutside = { -- Marker for Purchasing Vehicles
		Pos     = vector3(-851.86, -2690.96, 13.39),
		Size    = {x = 1.5, y = 1.5, z = 1.0},
		Heading = 62.9,
		Type    = -1
	},
	ResellVehicle = { -- Marker for Selling Vehicles
		Pos   = vector3(136.39422607422,-2477.462890625,6.0),
		Size  = {x = 3.0, y = 3.0, z = 1.0},
		Type  = 1
	}
}
