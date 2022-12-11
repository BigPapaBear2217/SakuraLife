local garagesData = {}
local vehiclesNetIDs = {}
local outsideVehicles = {}

function getGarageBuyableData(playerId, cb, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    cb(fullMarkerData[markerId].data or {})
end

RegisterNetEvent('esx_job_creator:buyVehicleFromGarage')
AddEventHandler('esx_job_creator:buyVehicleFromGarage', function(markerId, vehicleName)
    local playerId = source

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local identifier = xPlayer.identifier

    local garageData = fullMarkerData[markerId].data or {}

    local price = garageData.vehicles[vehicleName]

    if (price) then
        if (payInSomeWay(playerId, price)) then
            notify(xPlayer.source, getLocalizedText("bought_vehicle"))

            log(playerId, 
                getLocalizedText('log_bought_vehicle'),
                getLocalizedText('log_bought_vehicle_description',
                    vehicleName,
                    price,
                    markerId
                ),
                'success',
                'permanent_garage'
            )

            MySQL.Async.insert(
                'INSERT INTO jobs_garages(identifier, marker_id, vehicle, vehicle_props) VALUES (@identifier, @markerId, @vehicle, "{}")',
                {
                    ['@identifier'] = identifier,
                    ['@markerId'] = markerId,
                    ['@vehicle'] = vehicleName
                }, function(vehicleId)
                    if(vehicleId > 0) then
                        garagesData[identifier] = garagesData[identifier] or {}
                        garagesData[identifier][markerId] = garagesData[identifier][markerId] or {}

                        garagesData[identifier][markerId][vehicleId] = {
                            vehicleId = vehicleId,
                            vehicle = vehicleName,
                            identifier = xPlayer.identifier,
                            vehicleProps = {},
                            markerId = markerId
                        }
                    end
                end)
        else
            notify(xPlayer.source, getLocalizedText("not_enough_money"))
        end
    else
        log(playerId, 
            getLocalizedText('log_not_existing_vehicle'),
            getLocalizedText('log_not_existing_vehicle_description', 
                vehicleName,
                markerId
            ),
            'error',
            'permanent_garage'
        )
    end
end)

function getAllGaragesData()
    MySQL.Async.fetchAll("SELECT * FROM jobs_garages", {}, function(vehicles)
        if(vehicles) then
            for k, vehicleData in pairs(vehicles) do
                local identifier = vehicleData.identifier
                local markerId = vehicleData.marker_id
                local vehicleId = vehicleData.vehicle_id

                garagesData[identifier] = garagesData[identifier] or {} 
                garagesData[identifier][markerId] = garagesData[identifier][markerId] or {}
                
                garagesData[identifier][markerId][vehicleId] = {
                    plate = vehicleData.plate,
                    markerId = markerId,
                    vehicle = vehicleData.vehicle,
                    vehicleProps = json.decode(vehicleData.vehicle_props),
                    vehicleId = vehicleId
                }
            end
        end
    end)
end

function getGarageOwnedVehicles(playerId, cb, markerId)
    local identifier = ESX.GetPlayerFromId(playerId).identifier

    local playerVehicles = {}

    local garageData = fullMarkerData[markerId].data

    local playerGarage = garagesData[identifier] and garagesData[identifier][markerId] or {}

    for vehicleId, vehicleData in pairs(playerGarage) do
        vehicleData.isOutside = outsideVehicles[vehicleId]

        if(vehicleData.isOutside) then
            local vehicle = NetworkGetEntityFromNetworkId(outsideVehicles[vehicleId])
            
            -- If vehicle disappears the player can take it again
            if(not DoesEntityExist(vehicle)) then
                vehicleData.isOutside = false
            end
        end
        
        playerVehicles[vehicleId] = vehicleData
    end

    if(garageData) then
        cb({
            vehicles = playerVehicles,
            spawnCoords = garageData.spawnCoords,
            heading = garageData.heading
        })
    else
        cb({
            vehicles = {}
        })
    end
end

function updateVehicleProps(playerId, cb, markerId, vehicleNetId, props, plate)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local identifier = xPlayer.identifier

    local vehicleId = vehiclesNetIDs[vehicleNetId]

    if(not vehicleId) then
        cb(false)
        return
    else
        vehiclesNetIDs[vehicleNetId] = nil
        outsideVehicles[vehicleId] = nil
        
        cb(true)
    end

    MySQL.Async.execute('UPDATE jobs_garages SET vehicle_props=@props, marker_id=@markerId WHERE vehicle_id=@vehicleId AND identifier=@identifier', {
        ['@props'] = json.encode(props),
        ['@vehicleId'] = vehicleId,
        ['@identifier'] = identifier,
        ['@markerId'] = markerId
    }, function(affectedRows)
        if(affectedRows > 0) then
            
            local vehicleFound = false

            -- Moves vehicle to another marker
            for currentMarkerId, vehicles in pairs(garagesData[identifier]) do
                if(vehicleFound) then break end

                for currentVehicleId, vehicleData in pairs(vehicles) do
                    if(currentVehicleId == vehicleId) then
                        garagesData[identifier][vehicleData.markerId][vehicleId] = nil

                        vehicleData.markerId = markerId -- Updates the vehicle marker id
                        vehicleData.vehicleProps = props 

                        garagesData[identifier][markerId] = garagesData[identifier][markerId] or {}

                        garagesData[identifier][markerId][vehicleId] = vehicleData

                        vehicleFound = true
                        break
                    end
                end
            end

            MySQL.Async.execute( 'UPDATE jobs_garages SET plate=@plate WHERE plate IS NULL AND vehicle_id=@vehicleId AND identifier=@identifier',
            {
                ['@plate'] = plate,
                ['@vehicleId'] = vehicleId,
                ['@identifier'] = identifier
            }, function(affectedRows)
                if(affectedRows > 0) then
                    garagesData[identifier][markerId][vehicleId].plate = plate
                end
            end)
        end
    end)
end

local function vehicleIdSpawned(vehicleId, vehNetId)
    vehiclesNetIDs[vehNetId] = vehicleId
    outsideVehicles[vehicleId] = vehNetId
end
RegisterNetEvent('esx_job_creator:permanent_garage:vehicleIdSpawned', vehicleIdSpawned)