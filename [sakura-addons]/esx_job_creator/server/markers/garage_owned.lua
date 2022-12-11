function getPlayerOwnedVehicles(playerId, cb, markerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local identifier = xPlayer.identifier

    local spawnData = fullMarkerData[markerId].data

    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE `owner`=@identifier", {
        ["@identifier"] = identifier
    }, function(results)
        cb(results, spawnData)
    end)
end

function garageOwnedUpdateVehicleProps(playerId, cb, markerId, props, plate)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local identifier = xPlayer.identifier

    MySQL.Async.execute("UPDATE owned_vehicles SET vehicle=@props, `stored`=1 WHERE plate=@plate AND `owner`=@identifier", {
        ["@props"] = json.encode(props),
        ["@plate"] = plate,
        ["@identifier"] = identifier,
    }, function(affectedRows)
        cb(affectedRows > 0)
    end)
end

local function spawnedVehicle(plate)
    local playerId = source
    local identifier = ESX.GetPlayerFromId(playerId).identifier

    MySQL.Async.execute("UPDATE owned_vehicles SET `stored`=0 WHERE plate=@plate AND `owner`=@identifier", {
        ["@plate"] = plate,
        ["@identifier"] = identifier,
    })
end
RegisterNetEvent('esx_job_creator:garage_owned:spawnedVehicle', spawnedVehicle)