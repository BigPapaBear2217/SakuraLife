-- Free to use / By SkurllexTV

ESX              = nil
local FirstSpawn, PlayerLoaded = true, false
IsDead = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
	ESX.PlayerData = ESX.GetPlayerData()
end)

function Respawn(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)
	SetEntityHealth(ped, 200)

	ESX.UI.Menu.CloseAll()
end

RegisterNetEvent('b-revive:healallplayer')
AddEventHandler('b-revive:healallplayer', function()
  	for i = 0, 255 do
		if NetworkIsPlayerActive(i) then
			if	 GetEntityHealth(GetPlayerPed(i)) > 0 then
					SetEntityHealth(GetPlayerPed(i), 200)
			
			end	
		end
	end
end)

RegisterNetEvent('bloodline-reviveall:reviveallplayers')
AddEventHandler('bloodline-reviveall:reviveallplayers', function()
  	for i = 1, 1000, 1 do
		if NetworkIsPlayerActive(i) then
			if GetEntityHealth(GetPlayerPed(i)) == 0 then
				TriggerServerEvent('bloodline-reviveall:revive', GetPlayerServerId(i))
			end
		end
	end
end)

RegisterNetEvent('bloodline-reviveall:revive')
AddEventHandler('bloodline-reviveall:revive', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

    StopScreenEffect('DeathFailOut')

	TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
		local formattedCoords = {
			x = ESX.Math.Round(coords.x, 1),
			y = ESX.Math.Round(coords.y, 1),
			z = ESX.Math.Round(coords.z, 1)
		}
		ESX.SetPlayerData('lastPosition', formattedCoords)
		TriggerServerEvent('esx:updateLastPosition', formattedCoords)
		Respawn(playerPed, formattedCoords, 0.0)		
end)





















