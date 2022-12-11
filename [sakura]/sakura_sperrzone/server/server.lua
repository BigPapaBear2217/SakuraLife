TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('sperrzone', function(source, args, rawCommand)
    local radius = tonumber(args[1])
	local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    
    local source = source

    if xPlayer.getJob().name == "police" then
        if radius then
            if radius < 251 then
                TriggerClientEvent('bloodline-announce:annouce', -1, "Sperrzone: Das LSPD ruft eine Sperrzone von " .. radius .. " Metern aus! Bitte halten Sie sich von dieser fern falls nicht, wird ohne Vorwarnung scharf geschossen!")
                TriggerClientEvent("bloodline-sperrzone:setSpeerzone", -1, source, radius, xPlayer.getCoords(true))
            else
                TriggerClientEvent('ot-notify:notify', source, "", "Sperrzone", "Du kannst keine Sperrzonen mit einem Radius von über 250 Metern erstellen!")
            end
        else
            TriggerClientEvent('ot-notify:notify', source, "", "Sperrzone", "Bitte verwende /sperrzone RADIUS")
        end
    else
        TriggerClientEvent('ot-notify:notify', source, "", "Sperrzone", "Du kannst keine Sperrzonen erstellen.")
    end
end)

