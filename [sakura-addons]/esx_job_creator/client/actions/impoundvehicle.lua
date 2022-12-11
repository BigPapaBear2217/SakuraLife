local isImpoundingVehicle = false

local function impoundVehicle()
    if(isImpoundingVehicle) then return end

    local plyPed = PlayerPedId()
    
    if(IsPedInAnyVehicle(plyPed, false)) then
        return
    end

    local plyCoords = GetEntityCoords(plyPed)

    local closestVehicle, closestDistance = ESX.Game.GetClosestVehicle(plyCoords)

    if(closestDistance < 3.0) then
        isImpoundingVehicle = true

        TaskTurnPedToFaceEntity(plyPed, closestVehicle, 1500)

        Citizen.Wait(1500)

        local timeToImpound = 10000

        TaskStartScenarioInPlace(plyPed, 'PROP_HUMAN_BUM_BIN', 0, true)

        startProgressBar(timeToImpound, getLocalizedText('actions:impounding_vehicle'))

        Citizen.Wait(timeToImpound)

        if(DoesEntityExist(closestVehicle)) then
            DeleteEntity(closestVehicle)
        end

        ClearPedTasks(plyPed)

        isImpoundingVehicle = false
    else
        notifyClient(getLocalizedText('actions:no_vehicles_close'))
    end

end
RegisterNetEvent('esx_job_creator:actions:impoundVehicle', impoundVehicle)