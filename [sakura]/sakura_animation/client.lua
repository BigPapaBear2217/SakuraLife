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
local isPlaying = false

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

function startAnim(lib, anim)
	isPlaying = true
    ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
	end)
end

RegisterNUICallback('arme', function(data, cb)
    toggleField(false)
    startAnim("anim@amb@nightclub@peds@", "rcmme_amanda1_stand_loop_cop")
end)

RegisterNUICallback('anlehnen', function(data, cb)
    toggleField(false)
    startAnim("amb@world_human_leaning@male@wall@back@foot_up@idle_a", "idle_a")
	print("Getriggert")
end)

RegisterNUICallback('ergeben', function(data, cb)
    toggleField(false)
    startAnim("random@arrests@busted", "idle_a")
end)

RegisterNUICallback('kniehen', function(data, cb)
    toggleField(false)
    startAnim("rcmextreme3", "idle")
end)

RegisterNUICallback('doggym', function(data, cb)
    toggleField(false)
    startAnim('timetable@ron@ig_5_p3', 'ig_5_p3_base')
end)

RegisterNUICallback('doggyf', function(data, cb)
    toggleField(false)
    startAnim('amb@world_human_sunbathe@male@back@base', 'base')
end)

RegisterNUICallback('sitzen', function(data, cb)
    toggleField(false)
    startAnim('anim@amb@business@bgen@bgen_no_work@', 'sit_phone_phoneputdown_idle_nowork')
end)

RegisterNUICallback('dance', function(data, cb)
    toggleField(false)
    startAnim('anim@mp_player_intselfiethe_bird', 'idle_a')
end)
RegisterNUICallback('superman', function(data, cb)
    toggleField(false)
    startAnim('mp_ped_interaction', 'hugs_guy_a')
end)

RegisterNUICallback('bewusst', function(data, cb)
    toggleField(false)
    startAnim('dead', 'dead_e')
end)

RegisterNUICallback('escape', function(data, cb)
    isPlaying = false
    toggleField(false)
    SetNuiFocus(false, false)
    ClearPedTasks(PlayerPedId())
end)

RegisterNUICallback('ichhabgarnixgemacht', function(data, cb)
    toggleField(false)
    SetNuiFocus(false, false)
end)

CreateThread(function()
    while true do
        Citizen.Wait(0)

		if IsControlJustPressed(0, 246) then
            if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then 
                toggleField(true)
            end
        end

        if IsControlPressed(0, 73) then
            if not IsPedInAnyVehicle(GetPlayerPed(-1), true) then 
                if isPlaying == true then
                    isPlaying = false
                    ClearPedTasks(PlayerPedId())
                end
            end
        end
    end
end)