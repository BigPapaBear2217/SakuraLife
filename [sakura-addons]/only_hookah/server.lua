ESX = nil 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
local shishaSpawned = false


RegisterServerEvent("eff_smokes")
AddEventHandler("eff_smokes", function(entity)
	TriggerClientEvent("c_eff_smokes", -1, entity)
end)

ESX.RegisterUsableItem('hookah', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem('hookah', 1)
	xPlayer.showNotification('Es wurde eine Shisha platziert!')
	TriggerClientEvent("only_hooka:spawn", playerId, entity)
	shishaSpawned = true
end)

RegisterCommand("shishaweg", function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent("only_hooka:delete", source)
	if shishaSpawned == true then
		xPlayer.addInventoryItem("hookah", 1)
		shishaSpawned = false
	end
end)