Config = {}
Config.Locale = 'de'

Config.Marker = {
	r = 250, g = 0, b = 0, a = 100,  -- red color
	x = 1.5, y = 1.5, z = 0.5,       -- tiny, cylinder formed circle
	DrawDistance = 30.0, Type = 1    -- default circle type, low draw distance due to indoors area
}

Config.PoliceNumberRequired = 6
Config.TimerBeforeNewRob    = 6000 -- The cooldown timer on a store after robbery was completed / canceled, in seconds

Config.MaxDistance    = 30   -- max distance from the robbary, going any longer away from it will to cancel the robbary
Config.GiveBlackMoney = true -- give black money? If disabled it will give cash instead

Stores = {
	["staatsbank"] = {
		position = { x = 254.09, y = 225.44, z = 101.88 },
		reward = math.random(100000, 350000),
		nameOfStore = "Staatsbank (Los Santos)",
		secondsRemaining = 1000, -- seconds
		lastRobbed = 0
	},
}
