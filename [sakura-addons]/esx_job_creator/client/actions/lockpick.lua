local function isVehicleLocked(vehicle)
    local vehicleDoorsState = GetVehicleDoorLockStatus(vehicle)

    return vehicleDoorsState == 2 or vehicleDoorsState == 3 or GetVehicleDoorsLockedForPlayer(vehicle)
end

local function lockpickCar()
    local plyPed = PlayerPedId()
    local plyCoords = GetEntityCoords(plyPed)

    local closestVehicle, closestDistance = ESX.Game.GetClosestVehicle(plyCoords)

    if(closestVehicle > 0 and closestDistance < 2.0) then
        if(isVehicleLocked(closestVehicle)) then
            ESX.TriggerServerCallback('esx_job_creator:canLockpickVehicle', function(canLockpickVehicle)
                if(canLockpickVehicle) then
                    local lockpickTime = config.carLockpickTime * 1000
                    TaskEnterVehicle(plyPed, closestVehicle, 2000, -1, 1.0, 1, 0)
                    
                    Citizen.Wait(2000)
    
                    startProgressBar(lockpickTime, getLocalizedText('actions:lockpick:lockpickingVehicle'))
                    TaskStartScenarioInPlace(plyPed, 'PROP_HUMAN_BUM_BIN', 0, true)
    
                    if(config.enableAlarmWhenLockpicking) then
                        SetVehicleAlarm(closestVehicle, true)
                        SetVehicleAlarmTimeLeft(closestVehicle, lockpickTime)
                        StartVehicleAlarm(closestVehicle)
                    end
    
                    Citizen.Wait(lockpickTime)
                    ClearPedTasks(plyPed)
    
                    SetVehicleDoorsLockedForAllPlayers(closestVehicle, false)
                    SetVehicleDoorsLocked(closestVehicle, 1)
                else
                    notifyClient(getLocalizedText('you_need_lockpick'))
                end
            end)
        else
            notifyClient(getLocalizedText('not_locked_vehicle'))
        end
    else
        notifyClient(getLocalizedText('no_car_found'))
    end
end

RegisterNetEvent('esx_job_creator:actions:lockpickCar', lockpickCar)