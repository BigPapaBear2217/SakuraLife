ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source)
    local _source = source
    local xPlayerz = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    local steamname = GetPlayerName(_source)
        MySQL.Async.fetchAll('SELECT hasPlayedBefore FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayerz.identifier}, function(result)
            if result[1] then
                local resultfrommysql = json.encode(result[1].hasPlayedBefore)
                local resultfrommysql2 = result[1].hasPlayedBefore
                if resultfrommysql2 == "1" then
                    for i=1, #xPlayers, 1 do
                        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
                        if xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "guide" or xPlayer.getGroup() == "supporter" or xPlayer.getGroup() == "admin" then
                            TriggerClientEvent('ot-notify:notify', xPlayer.source, "#ff0000", "Einreiseamt", "Neuer Spieler in der Einreise: " .. steamname .. " | ID: " .. source)
                        end
                    end
                    TriggerClientEvent("ot-einreise:checkIfPlayedBefore", _source, true)
                elseif result[1].hasPlayedBefore == "0" then
                    TriggerClientEvent("ot-einreise:checkIfPlayedBefore", _source, false)
                end
            end
        end)
end)

RegisterCommand("visum", function(source, args)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local targetSource = args[1]
    local xTarget = ESX.GetPlayerFromId(targetSource)

    if xTarget then
        if xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "guide" or xPlayer.getGroup() == "supporter" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin" then
            TriggerClientEvent('ot-einreise:teleportOutOfAirport', xTarget.source)
            TriggerClientEvent("ot-einreise:checkIfPlayedBefore", targetSource, false)

            TriggerClientEvent(Config.NotificationTrigger, xPlayer.source, "#0088ff", "Einreiseamt", "Du hast dein Visum erhalten!")
            TriggerClientEvent(Config.NotificationTrigger, xPlayer.source, "#0088ff", "Einreiseamt", "Du hast einer Person ihr Visum zugestellt!")

            MySQL.Sync.execute("UPDATE users SET hasPlayedBefore = 0 WHERE identifier = @identifier", {
                ['@identifier'] = xTarget.identifier
            })
        else
            TriggerClientEvent(Config.NotificationTrigger, xPlayer.source, "#ff0000", "Einreiseamt", "Du bist kein Teammitglied.")
        end
    else
        TriggerClientEvent(Config.NotificationTrigger, xPlayer.source, "#0088ff", "Einreiseamt", "Du musst eine ID angeben!")
    end
end)

RegisterCommand("rein", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)            
    local targetSource = args[1]
    local xTarget = ESX.GetPlayerFromId(targetSource)

    if xPlayer then    
        if xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "guide" or xPlayer.getGroup() == "supporter" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin" then
            if xTarget then
		        TriggerClientEvent("ot-einreise:teleportIntoAirport", xTarget.source, Config.AirportInside)
		        TriggerClientEvent(Config.NotificationTrigger, xTarget.source, "#0088ff", "Einreiseamt", "Du befindest dich nun im Einreiseamt")
            else
                TriggerClientEvent("ot-einreise:teleportIntoAirport", xPlayer.source, Config.AirportInside)
		        TriggerClientEvent(Config.NotificationTrigger, xPlayer.source, "#0088ff", "Einreiseamt", "Du hast das Einreiseamt betreten!")
            end
        else
		    TriggerClientEvent(Config.NotificationTrigger, xPlayer.source, "#ff0000", "Einreiseamt", "Du bist kein Teammitglied.")
        end
    end
end, false)

RegisterCommand("raus", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)            
    local targetSource = args[1]
    local xTarget = ESX.GetPlayerFromId(targetSource)

    if xPlayer then    
        if xPlayer.getGroup() == "mod" or xPlayer.getGroup() == "guide" or xPlayer.getGroup() == "supporter" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin" then
            if xTarget then
                TriggerClientEvent("ot-einreise:teleportOutOfAirport", xTarget.source, Config.AirportOutside)
                TriggerClientEvent('ot-notify:notify', xTarget.source, "#0088ff", "Einreiseamt", "Du wurdest raus geschickt!")
            else
                TriggerClientEvent("ot-einreise:teleportOutOfAirport", xPlayer.source, Config.AirportOutside)
		        TriggerClientEvent('ot-notify:notify', xPlayer.source, "#0088ff", "Einreiseamt", "Du hast das Einreiseamt verlassen!")
            end
        else
            TriggerClientEvent('ot-notify:notify', xPlayer.source, "#ff0000", "Einreiseamt", "Du bist kein Teammitglied.")
        end
    end
end, false)
