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
	TriggerEvent('esx:setMoneyDisplay', 0.0)
	ESX.UI.HUD.SetDisplay(0.0)

end)

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)

		local coords      = GetEntityCoords(GetPlayerPed(-1))
		local isInMarker  = false
		local currentZone = nil

	
			if(GetDistanceBetweenCoords(coords, Config.ortx, Config.orty, Config.ortz, true) <  2) then
				isInMarker  = true
				currentZone = k
				if IsControlPressed(0, 38) then
					TriggerEvent('ali_moneywash:show')
					Wait(1000)
				end
			
			end
	

		if isInMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
			lastZone				= currentZone
			TriggerEvent('ali_moneywash:hasEnteredMarker', currentZone)
		end

		if not isInMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('ali_moneywash:hasExitedMarker', lastZone)
		end
	end
end)

AddEventHandler('ali_moneywash:hasEnteredMarker', function(zone)

	ESX.UI.Menu.CloseAll()
	

		CurrentAction     = zone
		                ESX.ShowHelpNotification("Drücke ~INPUT_CONTEXT~ um dein Geld zu Waschen!")
	
end)



Citizen.CreateThread(function()
	while true do
		Wait(0)
		DrawMarker(27, Config.ortx, Config.orty, Config.ortz, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 255, false, true, 2, false, false, false, false)
	end
end)









RegisterNetEvent('ali_moneywash:show')
AddEventHandler('ali_moneywash:show', function()

    

    SendNUIMessage({
        title = title,
	
		 
    })



    SetNuiFocus(true, true)
end)


RegisterNUICallback('exit', function(data)
   SetNuiFocus(false, false)
   TriggerServerEvent("ali_moneywash:deny")
	PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end)

RegisterNUICallback('error', function(data)
   TriggerEvent('ot-notify:notify', "#7b5fdd", data.error)
	PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end)

RegisterNUICallback('v', function(data)
   TriggerEvent('ot-notify:notify', "#7b5fdd", "GELDWÄSCHE", "Du hast den Vorgang abgebrochen.")
   SetNuiFocus(false, false)
	PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end)

RegisterNUICallback('join', function(data, cb)
	amount = data.input
	
	print(amount)
	TriggerServerEvent('esx_moneywash:washMoney', amount)
   SetNuiFocus(false, false)
	PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end)


RegisterNUICallback('join3', function(data, cb)
	amount = 100000
	
	print(amount)
	TriggerServerEvent('esx_moneywash:washMoney', amount)
   SetNuiFocus(false, false)
	PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end)


RegisterNUICallback('join4', function(data, cb)
	amount = 1000000
	
	print(amount)
	TriggerServerEvent('esx_moneywash:washMoney', amount)
   SetNuiFocus(false, false)
	PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
end)