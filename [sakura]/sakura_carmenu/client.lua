local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
ESX = nil


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent("close")
AddEventHandler("close", function()
	SendNUIMessage({
		action = 'close'
	})
end)

local enable = false
function toggleField(enable)
    SetNuiFocus(enable, enable)
    enableField = enable
 
        if enable then
            SendNUIMessage({
                action = 'open'
            })
        else
            SendNUIMessage({
                action = 'close'
            })
        end
   
end

AddEventHandler('onResourceStop', function(name)
    if GetCurrentResourceName() ~= name then
        return
    end
 
    toggleField(false)
end)

RegisterNUICallback('Autoaufundzu', function(data, cb)
    toggleField(false)
    local coords = GetEntityCoords(GetPlayerPed(-1))
    local hasAlreadyLocked = false
    cars = ESX.Game.GetVehiclesInArea(coords, 10)
    local carstrie = {}
    local cars_dist = {}		
    notowned = 0
    if #cars == 0 then
        TriggerEvent("ot-notify:notify", "#ff0000", "Cockpit", 'Es sind keine deiner Fahrzeuge in der nähe.')
    else
        for j=1, #cars, 1 do
            local coordscar = GetEntityCoords(cars[j])
            local distance = Vdist(coordscar.x, coordscar.y, coordscar.z, coords.x, coords.y, coords.z)
            table.insert(cars_dist, {cars[j], distance})
        end
        for k=1, #cars_dist, 1 do
            local z = -1
            local distance, car = 999
            for l=1, #cars_dist, 1 do
                if cars_dist[l][2] < distance then
                    distance = cars_dist[l][2]
                    car = cars_dist[l][1]
                    z = l
                end
            end
            if z ~= -1 then
                table.remove(cars_dist, z)
                table.insert(carstrie, car)
            end
        end
        for i=1, #carstrie, 1 do
            local plate = ESX.Math.Trim(GetVehicleNumberPlateText(carstrie[i]))
            ESX.TriggerServerCallback('carlock:isVehicleOwner', function(owner)
                if owner and hasAlreadyLocked ~= true then
                    local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(carstrie[i]))
                    vehicleLabel = GetLabelText(vehicleLabel)
                    local lock = GetVehicleDoorLockStatus(carstrie[i])
                    if lock == 1 or lock == 0 then
                        SetVehicleDoorShut(carstrie[i], 0, false)
                        SetVehicleDoorShut(carstrie[i], 1, false)
                        SetVehicleDoorShut(carstrie[i], 2, false)
                        SetVehicleDoorShut(carstrie[i], 3, false)
                        SetVehicleDoorsLocked(carstrie[i], 2)
                        PlayVehicleDoorCloseSound(carstrie[i], 1)
                        TriggerEvent("ot-notify:notify", "#ff0000", "Cockpit", "Fahrzeug abgeschlossen")
                        if not IsPedInAnyVehicle(PlayerPedId(), true) then
                            TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                        end
                        SetVehicleLights(carstrie[i], 2)
                        Citizen.Wait(150)
                        SetVehicleLights(carstrie[i], 0)
                        Citizen.Wait(150)
                        SetVehicleLights(carstrie[i], 2)
                        Citizen.Wait(150)
                        SetVehicleLights(carstrie[i], 0)
                        hasAlreadyLocked = true
                    elseif lock == 2 then
                        SetVehicleDoorsLocked(carstrie[i], 1)
                        PlayVehicleDoorOpenSound(carstrie[i], 0)
                        TriggerEvent("ot-notify:notify", "#33ff00", "Cockpit", "Fahrzeug aufgeschlossen")
                        if not IsPedInAnyVehicle(PlayerPedId(), true) then
                            TaskPlayAnim(PlayerPedId(), dict, "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
                        end
                        SetVehicleLights(carstrie[i], 2)
                        Citizen.Wait(150)
                        SetVehicleLights(carstrie[i], 0)
                        Citizen.Wait(150)
                        SetVehicleLights(carstrie[i], 2)
                        Citizen.Wait(150)
                        SetVehicleLights(carstrie[i], 0)
                        hasAlreadyLocked = true
                    end
                else
                    notowned = notowned + 1
                end
                if notowned == #carstrie then
                    TriggerEvent("ot-notify:notify", "#ff0000", "Cockpit", 'Es sind keine deiner Fahrzeuge in der nähe.')
                end	
            end, plate)
        end			
    end
end)

RegisterNUICallback('Radio', function(data, cb)
    toggleField(false)
    if Citizen.InvokeNative(0x5F43D83FD6738741, Citizen.ReturnResultAnyway()) == 1 then
        TriggerEvent("ot-notify:notify", "#ff0000", "Cockpit", 'Du hast das Radio deines Fahrzeugs ausgeschaltet.')
        SetVehicleRadioEnabled(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
    else
        SetVehicleRadioEnabled(GetVehiclePedIsIn(GetPlayerPed(-1), false), true)
        TriggerEvent("ot-notify:notify", "#ff0000", "Cockpit", 'Du hast das Radio deines Fahrzeugs eingeschaltet.')
    end
end)

RegisterNUICallback('Motor', function(data, cb)
    toggleField(false)
	local plyVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)

	if GetIsVehicleEngineRunning(plyVeh) then
		SetVehicleEngineOn(plyVeh, false, false, true)
		SetVehicleUndriveable(plyVeh, true)
		TriggerEvent("ot-notify:notify", "#ff0000", "Cockpit", 'Du hast den Motor deines Fahrzeugs ausgeschaltet.')
	elseif not GetIsVehicleEngineRunning(plyVeh) then
		SetVehicleEngineOn(plyVeh, true, false, true)
		SetVehicleUndriveable(plyVeh, false)
		TriggerEvent("ot-notify:notify", "#ff0000", "Cockpit", "Du hast den Motor deines Fahrzeug eingeschaltet")
	end
end)

RegisterNUICallback('escape', function(data, cb)
    toggleField(false)
    SetNuiFocus(false, false)
end)

RegisterNUICallback('ichhabgarnixgemacht', function(data, cb)
    toggleField(false)
    SetNuiFocus(false, false)
end)

CreateThread(function()
    while true do
        Citizen.Wait(0)
		if IsControlJustPressed(0, 73) then
            if IsPedInAnyVehicle(GetPlayerPed(-1), true) then 
            toggleField(true)
            end

        end
    end
end)