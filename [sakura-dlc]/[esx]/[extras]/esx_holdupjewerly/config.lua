Config = {}
Config.Locale = 'de'

Config.Marker = {
	r = 250, g = 0, b = 0, a = 100,  -- red color
	x = 1.0, y = 1.0, z = 0.5,       -- tiny, cylinder formed circle
	DrawDistance = 15.0, Type = 1    -- default circle type, low draw distance due to indoors area
}

Config.PoliceNumberRequired = 6
Config.TimerBeforeNewRob    = 3000 -- The cooldown timer on a store after robbery was completed / canceled, in seconds

Config.MaxDistance    = 30   -- max distance from the robbary, going any longer away from it will to cancel the robbary
Config.GiveBlackMoney = true -- give black money? If disabled it will give cash instead

Stores = {
	["jewerly"] = {
		position = { x = -622.21, y = -230.66, z = 38.06 },
		reward = math.random(80000, 200000),
		nameOfStore = "Juwelier",
		secondsRemaining = 800, -- seconds
		lastRobbed = 0
	},
}
