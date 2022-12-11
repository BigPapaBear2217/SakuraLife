-- loop to despawn vehicles
Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(60000 * (Config.despawnTimer - Config.despawnNotificationTimes[1]))
        TriggerClientEvent("VehicleDespawner:notification", -1, string.format(Config.timeLeftNotification, Config.despawnNotificationTimes[1]))
        for i = 2, #Config.despawnNotificationTimes, 1 do
            Citizen.Wait(60000 * (Config.despawnNotificationTimes[i - 1] - Config.despawnNotificationTimes[i]))
            TriggerClientEvent("VehicleDespawner:notification", -1, string.format(Config.timeLeftNotification, Config.despawnNotificationTimes[i]))
        end

        DeleteAllVehicles()
    end
end)

RegisterCommand(Config.despawnCommand, function(source, args, raw)
    if (#args > 0 and tonumber(args[1])) then
        TriggerClientEvent("VehicleDespawner:notification", -1, string.format(Config.timeLeftNotification, args[1]))

        Citizen.Wait(60000 * tonumber(args[1]))
    end
    
    DeleteAllVehicles()
end, true)

function DeleteAllVehicles()
    TriggerClientEvent("VehicleDespawner:notification", -1, Config.deleteNotification)

    local peds = GetAllPeds()
    local playerPeds = {}
    for i = 1, #peds, 1 do
        if (IsPedAPlayer(peds[i])) then
            table.insert(playerPeds, peds[i])
        end
    end

    if (#playerPeds == 0) then
        return
    end
    
    local time = GetGameTimer()

    local vehicles = GetAllVehicles()
    local deleted = 0
    for i = 1, #vehicles, 1 do
        if (not IsAnyPlayerInsideVehicle(vehicles[i], playerPeds)) then
            local closestPlayer, distance = GetClosestPlayerPed(GetEntityCoords(vehicles[i]), playerPeds)
            if (closestPlayer ~= nil and distance > Config.despawnDistance) then
                DeleteEntity(vehicles[i])
                deleted = deleted + 1
            end
        end
    end
    
    Log("Deleted " .. tostring(deleted) .. "/" .. tostring(#vehicles) .. " vehicles. Took " .. tostring((GetGameTimer() - time) / 1000.0) .. "sec")
end

function IsAnyPlayerInsideVehicle(vehicle, playerPeds)
    for i = 1, #playerPeds, 1 do
        local veh = GetVehiclePedIsIn(playerPeds[i], false)

        if (DoesEntityExist(veh) and veh == vehicle) then
            return true
        end
    end

    return false
end

-- return the ped of the closest player
function GetClosestPlayerPed(position, playerPeds)
	local closestDistance = 1000000.0
	local closestPlayerPed = nil
    local closestPos = nil
	
    for k, playerPed in pairs(playerPeds) do
        local pos = GetEntityCoords(playerPed)
        local distance = Vector3DistFast(position, pos)
        
        if (distance < closestDistance) then
            closestDistance = distance
            closestPlayerPed = playerPed
            closestPos = pos
        end
	end
	
    local distance = 0.0
    if (closestPlayerPed ~= nil) then
        distance = Vector3Dist(position, closestPos)
    end
    
	return closestPlayerPed, distance
end

-- return the distance between two positions (Vector3)
function Vector3Dist(v1, v2)
	return math.sqrt( (v2.x - v1.x) * (v2.x - v1.x) + (v2.y - v1.y) * (v2.y - v1.y) + (v2.z - v1.z) * (v2.z - v1.z) )
end

-- return the distance between two positions without sqrt (Vector3)
function Vector3DistFast(v1, v2)
	return (v2.x - v1.x) * (v2.x - v1.x) + (v2.y - v1.y) * (v2.y - v1.y) + (v2.z - v1.z) * (v2.z - v1.z)
end

function Log(text)
    if (Config.isDebug) then
        print(GetCurrentResourceName() .. ": " .. text)
    end
end
