ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('spielechipspack', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem('spielechipspack', 1)
    xPlayer.addInventoryItem('jetons', 25)
    TriggerEvent('ot-notify:notify', source, "", "Inventar", "Du hast 50 Spielechips ausgepackt!")
end)

ESX.RegisterUsableItem('simkarte', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    xPlayer.removeInventoryItem('simkarte', 1)
    TriggerClientEvent('ot-notify:notify', source, "", "Handy", "Du hast eine neue Simkarte eingelegt - Deine Nummer hat sich geändert!")
	TriggerClientEvent("d-phone:client:changenumber", source, stringnumber)

end)