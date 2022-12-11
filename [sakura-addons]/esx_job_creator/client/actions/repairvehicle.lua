local isRepairingVehicle = false

local function repairVehicle()
    if(isRepairingVehicle) then return end
    
    local plyPed = PlayerPedId()

    if(IsPedInAnyVehicle(plyPed, false)) then
        return
    end

    local plyCoords = GetEntityCoords(plyPed)

    local closestVehicle, closestDistance = ESX.Game.GetClosestVehicle(plyCoords)

    if(closestDistance < 3.0) then
        ESX.TriggerServerCallback('esx_job_creator:canRepairVehicle', function(canRepair)
            if(canRepair) then
                isRepairingVehicle = true

                TaskTurnPedToFaceEntity(plyPed, closestVehicle, 1500)
        
                Citizen.Wait(1500)
        
                local timeToRepairVehicle = 15000
        
                TaskStartScenarioInPlace(plyPed, 'PROP_HUMAN_BUM_BIN', 0, true)
        
                startProgressBar(timeToRepairVehicle, getLocalizedText('actions:repairing_vehicle'))
        
                Citizen.Wait(timeToRepairVehicle)
        
                SetVehicleFixed(closestVehicle)
                SetEntityHealth(closestVehicle, GetEntityMaxHealth(closestVehicle))
                SetVehicleDeformationFixed(closestVehicle)
        
                ClearPedTasks(plyPed)
        
                isRepairingVehicle = false
            end
        end)
    else
        notifyClient(getLocalizedText('actions:no_vehicles_close'))
    end
end
RegisterNetEvent('esx_job_creator:actions:repairVehicle', repairVehicle)