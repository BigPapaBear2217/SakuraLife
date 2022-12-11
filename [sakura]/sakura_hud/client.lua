local ESX = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
		ESX.PlayerData = ESX.GetPlayerData()
		updateMoney()
	end
	StartShowHudThread()
	TriggerEvent('esx:setMoneyDisplay', 0.0)
	ESX.UI.HUD.SetDisplay(0.0)
	SendNUIMessage({action = "setVoiceLevel", level = 2});
end)

-- VOICE CHANGE BUTTON
RegisterNetEvent('SaltyChat_VoiceRangeChanged')
AddEventHandler('SaltyChat_VoiceRangeChanged', function(voiceRange)
    if voiceRange == 3 then
        SendNUIMessage({action = "setVoiceLevel", level = 1});
		exports['okokNotify']:Alert("Sprachweite", "Srpachweite: " .. voiceRange, 3500, 'info')
    elseif voiceRange == 8 then
        SendNUIMessage({action = "setVoiceLevel", level = 2});
		exports['okokNotify']:Alert("Sprachweite", "Srpachweite: " .. voiceRange, 3500, 'info')
    elseif voiceRange == 15 then
        SendNUIMessage({action = "setVoiceLevel", level = 3});
		exports['okokNotify']:Alert("Sprachweite", "Srpachweite: " .. voiceRange, 3500, 'info')
    end
end)

-- SALTY RADIO 
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local data = exports['saltychat']:GetRadioChannel(true)
		if data == nil or data == '' then
			SendNUIMessage({
                action = "setFunk", 
                val = data, 
                funk = data
            });
		else
			SendNUIMessage({
                action = "setFunk", 
                val = data, 
                funk = data
            });
		end
	end
end)

  -- Pause menu disable hud display
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if IsPauseMenuActive() and not isPaused then
			isPaused = true
			SendNUIMessage({action = "hideHud"})
		elseif not IsPauseMenuActive() and isPaused then
			isPaused = false
			SendNUIMessage({action = "showHud"})
		end
	end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	if account.name == "money" then
        SendNUIMessage({
            action = "setMoney",
            money = account.money
        })
    end
end)

RegisterNetEvent('SaltyChat_TalkStateChanged')
AddEventHandler('SaltyChat_TalkStateChanged', function(SaltyisTalking)
    SendNUIMessage({action = "setVoiceTalking", val = SaltyisTalking});
end)


RegisterNetEvent('SaltyChat_MicStateChanged')
AddEventHandler('SaltyChat_MicStateChanged', function(isMicrophoneMuted)

    if isMicrophoneMuted == true then
            SendNUIMessage({action = "muted", muted = true})
    else
            SendNUIMessage({action = "nomuted"})
    end
        
    if exports.saltychat:GetVoiceRange() == 3 then
        SendNUIMessage({action = "setVoiceLevel", level = 1});
    elseif exports.saltychat:GetVoiceRange() == 8 then
        SendNUIMessage({action = "setVoiceLevel", level = 2});
    elseif exports.saltychat:GetVoiceRange() == 15 then
        SendNUIMessage({action = "setVoiceLevel", level = 3});
    end

end)

RegisterNetEvent('esx:activateMoney')
AddEventHandler('esx:activateMoney', function(e)
	SendNUIMessage({action = "setMoney", money = e})
end)

function StartShowHudThread()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            updateMoney()
        end
    end)
end

function updateMoney()
	SendNUIMessage({action = "setMoney", money = ESX.GetPlayerData().money})

end

RegisterCommand("togglehud",function()  SendNUIMessage({action = "togglehud"}) end, false)