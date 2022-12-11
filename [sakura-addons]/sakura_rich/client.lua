ESX = nil
local jobGrade = ''
local job = ''
local playerName = nil
local playerLoaded = false
local firstSpawn = true
-- ESX Stuff----
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	playerLoaded = true
end)

AddEventHandler('playerSpawned', function()
 if firstSpawn then
    for _, v in pairs(RichPresence.Buttons) do
          SetDiscordRichPresenceAction(v.index, v.ButtonName, v.url)
    end
    firstSpawn = false
 end	
end)

RegisterNetEvent('Kuuzoo-RichPresence:SetPresence')
AddEventHandler('Kuuzoo-RichPresence:SetPresence', function(data)
	local data = data
	local player = PlayerId()
	if RichPresence.JobSystem then
		SetDiscordRichPresenceAssetSmall(data['Job'].jobName)
		SetDiscordRichPresenceAssetSmallText(data['Job'].jobLabel .. " - " .. data['Job'].jobGrade)	
	end	
	SetDiscordAppId(RichPresence.ClientID)
	SetDiscordRichPresenceAsset(RichPresence.BigLogoName)
	if RichPresence.useIdentity then
		SetRichPresence((RichPresence.RichPresenceFormat):format(data['firstname'], data['lastname'], GetPlayerServerId(player), RichPresence.PlayerText, data['ActivePlayers'], tostring(RichPresence.MaxSlots)))
	else
		SetRichPresence((RichPresence.RichPresenceFormat):format(GetPlayerServerId(player), data['PlayerName'], RichPresence.PlayerText, data['ActivePlayers'], tostring(RichPresence.MaxSlots)))
	end
	SetDiscordRichPresenceAssetText(RichPresence.BigLogoText)
end)

Citizen.CreateThread(function()
	while not playerLoaded do
		Citizen.Wait(10)
	end
	while true do
		TriggerServerEvent('Kuuzoo-RichPresence:UpdatePresence')
		Citizen.Wait(RichPresence.RefreshTimer*1000)
	end
end)