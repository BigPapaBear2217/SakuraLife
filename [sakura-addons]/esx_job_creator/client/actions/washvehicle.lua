local isWashingVehicle = false

local function washVehicle()
    if(isWashingVehicle) then return end

    local plyPed = PlayerPedId()

    if(IsPedInAnyVehicle(plyPed, false)) then
        return
    end

    local plyCoords = GetEntityCoords(plyPed)

    local closestVehicle, closestDistance = ESX.Game.GetClosestVehicle(plyCoords)

    if(closestDistance < 3.0) then
        ESX.TriggerServerCallback('esx_job_creator:canWashVehicle', function(canWash)
            if(canWash) then
                isWashingVehicle = true

                TaskTurnPedToFaceEntity(plyPed, closestVehicle, 1500)
        
                Citizen.Wait(1500)
        
                TaskStartScenarioInPlace(plyPed, "world_human_maid_clean", 0, true)
        
                local dirtLevel = GetVehicleDirtLevel(closestVehicle)
        
                local timeToWash = dirtLevel * 1000
        
                startProgressBar(timeToWash, getLocalizedText('actions:washing_vehicle'))
        
                while dirtLevel >= 0.0 do
                    Citizen.Wait(1000)
        
                    dirtLevel = dirtLevel - 1.0
                    SetVehicleDirtLevel(closestVehicle, dirtLevel)
                end
        
                ClearPedTasks(plyPed)
        
                isWashingVehicle = false
            end
        end)
    else
        notifyClient(getLocalizedText('actions:no_vehicles_close'))
    end
end

RegisterNetEvent('esx_job_creator:actions:washVehicle', washVehicle)