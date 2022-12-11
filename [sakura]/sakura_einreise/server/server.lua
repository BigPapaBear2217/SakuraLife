ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source)
    local _source = source
    local xPlayerz = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()
    local steamname = GetPlayerName(_source)
        MySQL.Async.fetchAll('SELECT neu FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayerz.identifier}, function(result)
            if result[1] then
                local resultfrommysql = json.encode(result[1].neu)
                if resultfrommysql == "1" then
                    for i=1, #xPlayers, 1 do
                        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        		if xPlayer.getGroup() == "guide" or xPlayer.getGroup() == "supporter" or xPlayer.getGroup() == "moderator" or xPlayer.getGroup() == "admin" or xPlayer.getGroup() == "superadmin" then
                            TriggerClientEvent('ot-notify:notify', xPlayer.source, "red", "Spieler Online", "Der Spieler ist nun Online: " .. steamname .. " | ID: " .. source)
                        end
                    end
                    TriggerClientEvent("isneu", _source, true)
                    --TriggerClientEvent('ichfickdeinedimensionenindenarschdudummerhurensohnwiesomoddestdulgnopesdunutten', _source, 1)
                elseif result[1].neu == "0" then
                    TriggerClientEvent("isneu", _source, false)
                    --TriggerClientEvent('ichfickdeinedimensionenindenarschdudummerhurensohnwiesomoddestdulgnopesdunutten', _source, 0)
                end
            end
        end)
end)