Config = {}

Config.UsingESX = true -- if true, you must create an item in your database called `scratchcard`

Config.CurrencySymbol = '$' -- default `$`
Config.Items = {"🌴", "❤️", "⚡️", "💎", "💰", "🔥", "⚜️", "🌀", "👑", "💸", "💲"} -- add more to increase the probability of getting a prize
Config.Prizes = {100, 500, 1000, 3000, 2500}

-- Discord
Config.Discord = true -- enables discord logs
Config.WebhookURL = "https://discordapp.com/api/webhooks/890542815992504320/QvCkGrG3wM9l4ecgPfCuVri9jkNngTpIBmcPBpS6g0WF8WIyeAyuF4fHjI3J1u3LOD4w" -- discord webhook url