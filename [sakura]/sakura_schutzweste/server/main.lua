ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('bulletproof', function (source)

    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem('bulletproof', 1)

    TriggerClientEvent('bloodline_bulletproof:trigger', source)
end)

RegisterNetEvent('bloodline_bulletproof:trigger2')
AddEventHandler('bloodline_bulletproof:trigger2', function()

    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getInventoryItem('bulletproof').count >= 1 then
        TriggerClientEvent('ot-notify:notify', source,"#00ff00", "Schutzweste", "Du benutzt eine Weste")
        TriggerClientEvent('bloodline_bulletproof:trigger', source)
        xPlayer.removeInventoryItem('bulletproof', 1)
    else
        TriggerClientEvent('ot-notify:notify', source,"#ff0000", "Schutzweste", "Du hast keine Schutzwesten!")
    end
    
end)