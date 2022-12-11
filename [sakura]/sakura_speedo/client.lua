local ESX = nil
local PlayerData = {}
-- STATUS
local isDriving = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
		PlayerData = ESX.GetPlayerData()

    end
end)

CreateThread(function()
    Citizen.Wait(150)
    while true do
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        local lockstatus = GetVehicleDoorLockStatus(vehicle)

        Citizen.Wait(150)
        SetRadarZoom(1150)

        if IsPedInAnyVehicle(ped, false) then
            pedInVeh = true
        else
            -- Reset states when not in car
            pedInVeh = false
        end

        if pedInVeh then
            local vehicleSpeed = GetEntitySpeed(vehicle)*3.6
            local vehicleFuel = GetVehicleFuelLevel(vehicle)

            SendNUIMessage({
                action = "showCar";
                showSpeed = vehicleSpeed,
                showFuel = vehicleFuel
            })

            local inMenu = IsPauseMenuActive()
		    if inMenu then
			    SendNUIMessage({
                    action = "hideCar";
                })
		    end
		    if not inMenu then
                SendNUIMessage({
                    action = "showCar";
                    showSpeed = vehicleSpeed,
                    showFuel = vehicleFuel
            })
            end
        else

            SendNUIMessage({
                action = "hideCar";
            })
        end

        if GetIsVehicleEngineRunning(vehicle) == false then
            SendNUIMessage({action = "toggleEngine", status = false})
        else
            SendNUIMessage({action = "toggleEngine", status = true})
        end

        if (lockstatus == 0 or lockstatus == 1) then
            SendNUIMessage({action = "toggleLock", status = true})
        elseif lockstatus ~= 0 and lockstatus ~= 1 then
            SendNUIMessage({action = "toggleLock", status = false})
        end

    end
end)