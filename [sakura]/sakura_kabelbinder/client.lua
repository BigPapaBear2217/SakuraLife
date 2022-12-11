ESX = nil
local IsHandcuffed2 = false


Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
    end
end)

RegisterNetEvent("esx_kabelbinder:checkCuff")
AddEventHandler("esx_kabelbinder:checkCuff", function()
    local player, distance = ESX.Game.GetClosestPlayer()
    local poochQuantity = xPlayer.getInventoryItem('kabelbinder').count
    if poochQuantity > 0 then
        ESX.TriggerServerCallback("esx_kabelbinder:isCuffed",function(cuffed)
            if not cuffed2 then
                TriggerServerEvent("esx_kabelbinder:handcuff",GetPlayerServerId(player),true)
            else
                TriggerServerEvent("esx_kabelbinder:handcuff",GetPlayerServerId(player),false)
            end

            TriggerEvent('ot-notify:notify', '', 'Kabelbinder', 'Du hast der Person vor dir Kabelbinder angelegt!')
        end,GetPlayerServerId(player))
    else
        TriggerEvent("ot-notify:notify", "#eb4034", "Core", "Du hast Keine Kabelbinder")
    end
end)
      
RegisterNetEvent("esx_kabelbinder:uncuff")
AddEventHandler("esx_kabelbinder:uncuff",function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance~=-1 and distance<=3.0 then
        TriggerServerEvent("esx_kabelbinder:uncuff",GetPlayerServerId(player))
        TriggerEvent("ot-notify:notify", "#eb4034", "Bloodline-Core", "Dir wurden die Kabelbinder abgelegt!")
        ClearPedTasksImmediately(player)
        ClearPedTasks(PlayerPedId())
    else
        TriggerEvent("ot-notify:notify", "#eb4034", "Core", "Keine Spieler in der Nähe")
    end
end)

RegisterNetEvent("esx_kabelbinder:uncufffürbeamte")
AddEventHandler("esx_kabelbinder:uncufffürbeamte",function()
    local player, distance = ESX.Game.GetClosestPlayer()
    if distance~=-1 and distance<=3.0 then
        TriggerServerEvent("esx_kabelbinder:uncufffürbeamte",GetPlayerServerId(player))
        TriggerEvent("ot-notify:notify", "#eb4034", "Core", "Dir wurden die Kabelbinder abgelegt!")
    else
        TriggerEvent("ot-notify:notify", "#eb4034", "Core", "Keine Spieler in der Nähe")
    end
end)


RegisterNetEvent('esx_kabelbinder:forceUncuff')
AddEventHandler('esx_kabelbinder:forceUncuff',function()
    IsHandcuffed2 = false
    local player, distance = ESX.Game.GetClosestPlayer()
    local playerPed = GetPlayerPed(-1)
    ClearPedTasksImmediately(player)
    ClearPedTasks(PlayerPedId())
    ClearPedSecondaryTask(playerPed)
    SetEnableHandcuffs(playerPed, false)
    DisablePlayerFiring(playerPed, false)
    SetPedCanPlayGestureAnims(playerPed, true)
    FreezeEntityPosition(playerPed, false)
    DisplayRadar(true)
end)

RegisterNetEvent("esx_kabelbinder:handcuff")
AddEventHandler("esx_kabelbinder:handcuff",function()
    local playerPed = GetPlayerPed(-1)
    IsHandcuffed2 = not IsHandcuffed2
    Citizen.CreateThread(function()
        if IsHandcuffed2 then
            ClearPedTasks(playerPed)
            SetPedCanPlayAmbientBaseAnims(playerPed, true)

			RequestAnimDict('anim@move_m@prisoner_cuffed')
			while not HasAnimDictLoaded('anim@move_m@prisoner_cuffed') do
				Citizen.Wait(100)
			end

			TaskPlayAnim(playerPed, 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

			SetEnableHandcuffs(playerPed, true)
			DisablePlayerFiring(playerPed, true)
			SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true) -- unarm player
			SetPedCanPlayGestureAnims(playerPed, false)
			
			ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
            FreezeEntityPosition(playerPed, false)
            TriggerEvent("ot-notify:notify", "#eb4034", "Core", "Dir wurden Kabelbinder angelegt!")
        else
            ClearPedSecondaryTask(playerPed)
			SetEnableHandcuffs(playerPed, false)
			DisablePlayerFiring(playerPed, false)
			SetPedCanPlayGestureAnims(playerPed, true)
        end
    end)
end)


--[[Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        if IsHandcuffed2 then
            SetEnableHandcuffs(playerPed, true)
            DisablePlayerFiring(playerPed, true)
            SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
            SetPedCanPlayGestureAnims(playerPed, false)
            DisplayRadar(false)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 74, true)
			DisableControlAction(0, 2, true) -- Disable pan
			DisableControlAction(0, 263, true) -- Melee Atesxk 1
			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job
            DisableControlAction(1, 254, true)
            DisableControlAction(0, 47, true)  -- Disable 

            if IsEntityPlayingAnim(playerPed, 'anim@move_m@prisoner_cuffed', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('anim@move_m@prisoner_cuffed', function()
					TaskPlayAnim(playerPed, 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
        end
        if not IsHandcuffed2 and not IsControlEnabled(0, 140) then EnableControlAction(0, 140, true)  end
        if not IsHandcuffed2 and not IsControlEnabled(0, 74) then EnableControlAction(0, 74, true)  end
    end
end)]]


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if IsHandcuffed2 then

			DisableControlAction(0, 24, true) -- Atesxk
			DisableControlAction(0, 257, true) -- Atesxk 2
			DisableControlAction(0, 25, true) -- Aim
			DisableControlAction(0, 263, true) -- Melee Atesxk 1


			DisableControlAction(0, 45, true) -- Reload
			DisableControlAction(0, 22, true) -- Jump
			DisableControlAction(0, 44, true) -- Cover
			DisableControlAction(0, 37, true) -- Select Weapon
			DisableControlAction(0, 23, true) -- Also 'enter'?

			DisableControlAction(0, 288,  true) -- Disable phone
			DisableControlAction(0, 289, true) -- Inventory
			DisableControlAction(0, 170, true) -- Animations
			DisableControlAction(0, 167, true) -- Job

			DisableControlAction(0, 73, true) -- Disable clearing animation
			DisableControlAction(2, 199, true) -- Disable pause screen

			DisableControlAction(0, 59, true) -- Disable steering in vehicle
			DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) -- Disable reversing in vehicle

			DisableControlAction(2, 36, true) -- Disable going stealth

			DisableControlAction(0, 47, true)  -- Disable weapon
			DisableControlAction(0, 264, true) -- Disable melee
			DisableControlAction(0, 257, true) -- Disable melee
			DisableControlAction(0, 140, true) -- Disable melee
			DisableControlAction(0, 141, true) -- Disable melee
			DisableControlAction(0, 142, true) -- Disable melee
			DisableControlAction(0, 143, true) -- Disable melee
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle

			if IsEntityPlayingAnim(playerPed, 'anim@move_m@prisoner_cuffed', 'idle', 3) ~= 1 then
				ESX.Streaming.RequestAnimDict('anim@move_m@prisoner_cuffed', function()
					TaskPlayAnim(playerPed, 'anim@move_m@prisoner_cuffed', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

