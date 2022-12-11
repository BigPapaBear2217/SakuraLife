Config = {}
Config.Locale = 'de'

Config.Marker = {
	r = 250, g = 0, b = 0, a = 100,  -- red color
	x = 1.0, y = 1.0, z = 0.5,       -- tiny, cylinder formed circle
	DrawDistance = 15.0, Type = 1    -- default circle type, low draw distance due to indoors area
}

Config.PoliceNumberRequired = 10
Config.TimerBeforeNewRob    = 3000 -- The cooldown timer on a store after robbery was completed / canceled, in seconds

Config.MaxDistance    = 50   -- max distance from the robbary, going any longer away from it will to cancel the robbary
Config.GiveBlackMoney = true -- give black money? If disabled it will give cash instead

Stores = {
	["humane"] = {
		position = { x = 3605.57, y = 3730.62, z = 29.69 },
		reward = math.random(700000, 900000),
		nameOfStore = "Humane Labs",
		secondsRemaining = 800, -- seconds
		lastRobbed = 0
	},
}
