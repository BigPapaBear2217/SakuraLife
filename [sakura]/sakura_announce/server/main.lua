ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

    TriggerEvent('es:addGroupCommand', 'announce', 'admin', function(source, args, user)
    TriggerClientEvent('bloodline-announce:annouce', -1, table.concat(args, ' '))
end)

    RegisterCommand("cannounce", function(source, args)
    if source == 0 then
        TriggerClientEvent('bloodline-announce:annouce', -1, table.concat(args, ' '))
    end
end, false)

    AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 1800 then
        TriggerClientEvent('bloodline-announce:annouce', -1, "txAdmin: Der Server wird in 30 Minuten neu gestartet.")
    elseif eventData.secondsRemaining == 900 then
        TriggerClientEvent('bloodline-announce:annouce', -1, "txAdmin: Der Server wird in 15 Minuten neu gestartet.")
    elseif eventData.secondsRemaining == 600 then
        TriggerClientEvent('bloodline-announce:annouce', -1, "txAdmin: Der Server wird in 10 Minuten neu gestartet.")
    elseif eventData.secondsRemaining == 300 then
        TriggerClientEvent('bloodline-announce:annouce', -1, "txAdmin: Der Server wird in 5 Minuten neu gestartet.")
    elseif eventData.secondsRemaining == 240 then
        TriggerClientEvent('bloodline-announce:annouce', -1, "txAdmin: Der Server wird in 4 Minuten neu gestartet.")
    elseif eventData.secondsRemaining == 180 then
        TriggerClientEvent('bloodline-announce:annouce', -1, "txAdmin: Der Server wird in 3 Minuten neu gestartet.")
    elseif eventData.secondsRemaining == 120 then
        TriggerClientEvent('bloodline-announce:annouce', -1, "txAdmin: Der Server wird in 2 Minuten neu gestartet.")
    elseif eventData.secondsRemaining == 60 then
        TriggerClientEvent('bloodline-announce:annouce', -1, "txAdmin: Der Server wird in einer Minute neu gestartet.")

        local xPlayers = ESX.GetPlayers()
    
        
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            ESX.SavePlayer(xPlayer)
        end
    end

end)
AddEventHandler('txAdmin:omegaLul', function(test, test2)
    TriggerClientEvent('ot-notify:notify', -1, "[WICHTIG] " .. test2 ..  " | Gesendet von " .. test)
end)
AddEventHandler('txAdmin:events:playerBanned', function(eventData)
    TriggerClientEvent('ot-notify:notify', -1, "", "Information", "txAdmin: Der Spieler " .. GetPlayerName(tonumber(eventData.target)) .. " wurde von " .. eventData.author .. " gebannt! Grund: " .. eventData.reason)
end)


AddEventHandler('txAdmin:events:playerWarned', function(eventData)
    TriggerClientEvent('ot-notify:notify', -1, "", "Information", "txAdmin: Der Spieler " .. GetPlayerName(tonumber(eventData.target)) .. " wurde von " .. eventData.author .. " verwarnt! Grund: " .. eventData.reason)
end)

AddEventHandler('txAdmin:events:playerKicked', function(eventData)
    if eventData.reason ~= nil and eventData.reason ~= "" then
        TriggerClientEvent('ot-notify:notify', -1, "", "Information", "txAdmin: Der Spieler " .. eventData.target .. " wurde von " .. eventData.author .. " gekickt!")
    else
        TriggerClientEvent('ot-notify:notify', -1, "", "Information", "txAdmin: Der Spieler " .. eventData.target .. " wurde von " .. eventData.author .. " gekickt! Grund: " .. eventData.reason)
    end
end)