Config                            = {}

Config.DrawDistance               = 100.0

Config.Marker                     = { type = 21, x = 1.0, y = 1.0, z = 0.5, r = 255, g = 0, b = 0, a = 0.8, rotate = false }


Config.ReviveReward               = 500  -- revive reward, set to 0 if you don't want it enabled
Config.AntiCombatLog              = true -- enable anti-combat logging?
Config.LoadIpl                    = true -- disable if you're using fivem-ipl or other IPL loaders

Config.Locale                     = 'de'

local second = 1000
local minute = 60 * second

Config.EarlyRespawnTimer          = 10 * minute  -- Time til respawn is available
Config.BleedoutTimer              = 10 * minute -- Time til the player bleeds out

Config.EnablePlayerManagement     = false

Config.RemoveWeaponsAfterRPDeath  = true
Config.RemoveCashAfterRPDeath     = true
Config.RemoveItemsAfterRPDeath    = true

-- Let the player pay for respawning early, only if he can afford it.
Config.EarlyRespawnFine           = true
Config.EarlyRespawnFineAmount     = 5000

Config.RespawnPoint = { coords = vector3(302.55, -585.64, 43.28), heading = 357.99 }

Config.Hospitals = {

	CentralLosSantos = {

		Blip = {
			coords = vector3(296.93, -584.15, 43.13),
			sprite = 153,
			scale  = 1.3,
			color  = 1
		},

		AmbulanceActions = {
			vector3(301.79, -599.54, 43.28)
		},

		Pharmacies = {
			vector3(306.45, -601.71, 43.28)
		},

		Vehicles = {
			{
				Spawner = vector3(0, 0, 0),
				InsideShop = vector3(446.7, -1355.6, 43.5),
				Marker = { type = 36, x = 1.0, y = 1.0, z = 1.0, r = 255, g = 0, b = 0, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(332.93, -590.52, 28.8), heading = 352.6, radius = 4.0 },
					{ coords = vector3(325.92, -588.82, 28.8), heading = 352.6, radius = 4.0 },
					{ vector3(319.79, -586.49, 28.8), heading = 352.6, radius = 6.0 }
				}
			}
		},

		Helicopters = {
			{
				Spawner = vector3(342.88, -581.8, 74.16),
				InsideShop = vector3(305.6, -1419.7, 41.5),
				Marker = { type = 34, x = 1.5, y = 1.5, z = 1.5, r = 255, g = 0, b = 0, a = 100, rotate = true },
				SpawnPoints = {
					{ coords = vector3(352.24, -588.15, 74.16), heading = 142.7, radius = 10.0 }
				}
			}
		},

		FastTravels = {
		--	{
		--		From = vector3(294.7, -1448.1, 29.0),
		--		To = { coords = vector3(346.02, -582.71, 28.8), heading = 0.0 },
		--		Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
		--	},

		--	{
		--		From = vector3(346.02, -582.71, 28.8),
		--		To = { coords = vector3(294.7, -1448.1, 66.0), heading = 0.0 },
		--		Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
		--	},

			{
				From = vector3(247.3, -1371.5, 23.5),
				To = { coords = vector3(333.1, -1434.9, 45.5), heading = 138.6 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(335.5, -1432.0, 45.50),
				To = { coords = vector3(249.1, -1369.6, 23.5), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(234.5, -1373.7, 20.9),
				To = { coords = vector3(320.9, -1478.6, 28.8), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			},

			{
				From = vector3(317.9, -1476.1, 28.9),
				To = { coords = vector3(238.6, -1368.4, 23.5), heading = 0.0 },
				Marker = { type = 1, x = 1.5, y = 1.5, z = 1.0, r = 102, g = 0, b = 102, a = 100, rotate = false }
			}
		},

		FastTravelsPrompt = {
			{
				From = vector3(338.59, -583.87, 73.16),
				To = { coords = vector3(345.64, -582.64, 26.8), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			},

			{
				From = vector3(345.64, -582.64, 27.8),
				To = { coords = vector3(338.59, -583.87, 72.16), heading = 0.0 },
				Marker = { type = 1, x = 2.0, y = 2.0, z = 0.5, r = 102, g = 0, b = 102, a = 100, rotate = false },
				Prompt = _U('fast_travel')
			}
		}

	}
}

Config.AuthorizedVehicles = {

	praktikant = {
		{ model = 'ambulance', label = 'Ambulance Van', price = 5000}
	},

	notarzt = {
		{ model = 'ambulance', label = 'Ambulance Van', price = 4500}
	},

	doktor = {
		{ model = 'ambulance', label = 'Ambulance Van', price = 3000}
	},

	chefarzt = {
		{ model = 'ambulance', label = 'Ambulance Van', price = 2000},
		{ model = 'dodgeems', label = 'EMS Dodge', price = 25000}
	}

}

Config.AuthorizedHelicopters = {

	ambulance = {},

	doktor = {
		{ model = 'swift', label = 'Nagasaki Buzzard', price = 500000 }
	},

	personalmanager = {
		{ model = 'swift', label = 'Nagasaki Buzzard', price = 500000 }
	},

	chefarzt = {
		{ model = 'swift', label = 'Nagasaki Buzzard', price = 500000 }
	}

}
