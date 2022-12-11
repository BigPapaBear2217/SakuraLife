local display = false
local v = 'n'
local lastplate = 1

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

    while jobName == nil do
        Citizen.Wait(0)
        jobName = ESX.GetPlayerData().job.name
    end

    while true do 
        Citizen.Wait(10000)
        jobName = ESX.GetPlayerData().job.name
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        if v == 'n' and IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
            v = 's'
            checkluzes()
        elseif v == 's' and IsPedOnFoot(GetPlayerPed(-1)) then
            v = 'n'
        end
    end
end)

function checkluzes()
        Citizen.Wait(200)
        local plate = ESX.Math.Trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1),false)))
        if plate ~= nil then
                ESX.TriggerServerCallback('matif_headlights:check', function(result)
                        if result ~= nil and result ~= 'NOT' then
                            lastplate = plate
                            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1),false)
                            ToggleVehicleMod(vehicle, 22, true)
                            SetVehicleHeadlightsColour(vehicle, tonumber(result))    
                        end
                end, plate)
        end
end

RegisterCommand("headlights", function(source, args)
    if jobName == "mechanic" then
        if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
            local plate = ESX.Math.Trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1),false)))

            if plate ~= lastplate then
                ESX.TriggerServerCallback('matif_headlights:check', function(result)
                    print(result)
                    if result ~= nil and result == 'NOT' then
                        print('doesnt have')
                        TriggerEvent('esx:showNotification', 'Dieses Fahrzeug untersützt keine Bunten Lichter!')
                    elseif result ~= nil and result ~= 'NOT' then
                        lastplate = plate
                        SetDisplay(not display)
                    else
                        TriggerEvent('esx:showNotification', 'Etwas ist fehlgeschlagen.')
                    end
                end, plate)
            else
                SetDisplay(not display)
            end   
        else
            TriggerEvent('esx:showNotification', 'Du bist in keinem Fahrzeug!')
        end
    else
        print(jobName)
    end
end)

RegisterCommand("installheadlights", function(source, args)
    if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
        local plate = ESX.Math.Trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1),false)))
        TriggerServerEvent('matif_headlights:install', plate)
    else
        TriggerEvent('esx:showNotification', 'Du bist in keinem Fahrzeug!')
    end
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("setcolor", function(data)
    print(data.color)
    local plate = ESX.Math.Trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1),false)))
    ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1)), 22, true)
    SetVehicleHeadlightsColour(GetVehiclePedIsIn(GetPlayerPed(-1)), tonumber(data.color))
	TriggerServerEvent('matif_headlights:set', plate, data.color)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
	        control --integer , 
            disable -- boolean 
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)

