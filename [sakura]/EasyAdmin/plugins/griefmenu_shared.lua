Citizen.CreateThread(function()
	repeat
		Wait(0)
	until permissions
	permissions["griefing"] = false
	permissions["griefing.truck"] = false
	permissions["griefing.clowns"] = false
	permissions["griefing.flashbang"] = false
	permissions["griefing.drug"] = false

	permissions["griefing.lag"] = false
	permissions["griefing.crash"] = false
end)