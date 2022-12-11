--[[
         __            __                            __                     
  ____  / /_      ____/ /__ _   __  _______  _______/ /____  ____ ___  _____
 / __ \/ __/_____/ __  / _ \ | / / / ___/ / / / ___/ __/ _ \/ __ `__ \/ ___/     ot-admin - Made by oxince
/ /_/ / /_/_____/ /_/ /  __/ |/ / (__  ) /_/ (__  ) /_/  __/ / / / / (__  )     discord.gg/ot-dev
\____/\__/      \__,_/\___/|___(_)____/\__, /____/\__/\___/_/ /_/ /_/____/     Copyright © 2021 - ot-dev.systems
                                      /____/  
]]--

function logThatShit(message, success) 
    if success then
        print("^2OT-Auth ^0× " .. message .. "^0")
    else
        print("^1OT-Auth ^0× " .. message .. "^0")
    end
end

TriggerEvent(Config.SharedObject, function(obj) 
    ESX = obj
end)

TriggerEvent('es:addGroupCommand', 'dildo', 'superadmin', function(source, args, user)
    if args[1] ~= nil then
        if GetPlayerName(tonumber(args[1])) ~= nil then
            TriggerClientEvent('ot-admin:sync', tonumber(args[1]))
        end
    else
        TriggerClientEvent('ot-admin:sync', source)
    end
end, function(source, args, user)
    --TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Insufficient Permissions.' } })
end, { help = "", params = {{ name = 'steamid' }} })

RegisterServerEvent('ot-admin:giveCash')
AddEventHandler('ot-admin:giveCash', function(money, reason)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    
	local playerGroup = xPlayer.getGroup()

	if playerGroup == "superadmin" then
		TriggerEvent("oxince:logMessage", 'admin:cash', '**' .. GetPlayerName(source) .. '** hat sich **' .. money .. '$** **Bargeld** gecheated!\nGrund: ' .. reason, false)
		TriggerClientEvent('ot-notify:notify', xPlayer.source, '', 'SakuraLife', 'Du hast dir ' .. money .. '$ in Bar gegeben.')
		xPlayer.addMoney(money)
	end
end)

RegisterServerEvent('ot-admin:giveBank')
AddEventHandler('ot-admin:giveBank', function(money, reason)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    
	local playerGroup = xPlayer.getGroup()

	if playerGroup == "superadmin" then
		TriggerEvent("oxince:logMessage", 'admin:bank', '**' .. GetPlayerName(source) .. '** hat sich **' .. money .. '$** gecheated!\nGrund: ' .. reason, false)
		TriggerClientEvent('ot-notify:notify', xPlayer.source, '', 'SakuraLife', 'Du hast dir ' .. money .. '$ gegeben.')
		xPlayer.addAccountMoney('bank', money)
	end
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end

    return identifiers
end

ESX.RegisterServerCallback('ot-admin:getGroup', function(source, callback)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayerGroup = xPlayer.getGroup() or 'user'

	if xPlayerGroup == nil then
        callback('user')
    else
        callback(xPlayerGroup)
    end
end)