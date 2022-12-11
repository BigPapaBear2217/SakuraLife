local clientrender = false
local tickcount = 0
local servertime = {h = 0, m = 0, s = 0}
Citizen.CreateThread(function()
	Wait(250)
	while true do
		Wait(33)
		if clientrender == true then
			local tick = GetGameTimer()
			if tickcount <= tick then
				local y, m, d, h, M, s = GetLocalTime()
				servertime = {h = h, m = M, s = s}
				tickcount = tick+1500
			end
		end
		NetworkOverrideClockTime(servertime.h, servertime.m, servertime.s)
    end
end)

SetMillisecondsPerGameMinute(60000)
RegisterNetEvent("realtime:event")
AddEventHandler("realtime:event", function(h, m, s)
    servertime = {h = h, m = m, s = s}
	NetworkOverrideClockTime(h, m, s)
end)

TriggerServerEvent("realtime:event")

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerServerEvent("realtime:event")
    end
end)
