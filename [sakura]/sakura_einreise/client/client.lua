local playerHasPlayedBefore = false
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.SharedObject, function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("ot-einreise:checkIfPlayedBefore") 
AddEventHandler("ot-einreise:checkIfPlayedBefore", function(value)
    playerHasPlayedBefore = value
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if playerHasPlayedBefore then
            local ped = PlayerPedId()
                if GetDistanceBetweenCoords(GetEntityCoords(ped), Config.SpawnX, Config.SpawnY, Config.SpawnZ, true) > 250 then
                    SetEntityCoords(ped, Config.SpawnX, Config.SpawnY, Config.SpawnZ, false, false, false, true)
                else
            end
        end
    end
end)

Citizen.CreateThread(function()
  SetDeepOceanScaler(0.0)
end)
