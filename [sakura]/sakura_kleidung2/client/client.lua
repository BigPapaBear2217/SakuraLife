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

RegisterNetEvent("ot-einreise:teleportOutOfAirport") 
AddEventHandler("ot-einreise:teleportOutOfAirport", function(source)
    local ped = PlayerPedId()
    local currentPos = GetEntityCoords(ped)
    SetEntityCoords(ped, -1043.2307128906, -2746.9499511719, 21.358695983887, false, false, false, true)
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


RegisterNetEvent("ot-einreise:teleportIntoAirport")
AddEventHandler("ot-einreise:teleportIntoAirport", function(coords)
    local x, y, z = table.unpack(coords)
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, true)
end)

Citizen.CreateThread(function()
  SetDeepOceanScaler(0.0)
end)
