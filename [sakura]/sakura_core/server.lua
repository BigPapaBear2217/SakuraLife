local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) 
    ESX = obj 
end)

ESX.RegisterServerCallback("SakuraLife:getSource", function(source, cb)
    cb(source)
end)

ESX.RegisterServerCallback("SakuraLife:getPlayers", function(source, cb)
    cb(GetNumPlayerIndices())
end)

ESX.RegisterServerCallback("SakuraLife:fetchUserRank", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

ESX.RegisterServerCallback("SakuraLife:getCops", function(source, cb)
    local xPlayers = ESX.GetPlayers()
    local cops = 0

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end

    cb(cops)
end)

ESX.RegisterServerCallback("SakuraLife:getGangMembers", function(source, cb)
    local playerShea = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    local cops = 0

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.getGang() == playerShea.getGang() then
            cops = cops + 1
        end
    end

    cb(cops)
end)

ESX.RegisterServerCallback("SakuraLife:getMedics", function(source, cb)
    local xPlayers = ESX.GetPlayers()
    local cops = 0

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == 'ambulance' then
            cops = cops + 1
        end
    end
    
    cb(cops)
end)

ESX.RegisterServerCallback("SakuraLife:getFib", function(source, cb)
    local xPlayers = ESX.GetPlayers()
    local cops = 0

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.job.name == 'fib' then
            cops = cops + 1
        end
    end
    
    cb(cops)
end)

Citizen.CreateThread(function()
    
end)

ESX.RegisterServerCallback("SakuraLife:isPedAllowed", function(source, cb)
    local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

RegisterCommand("group", function(source, args)
    --[[local xPlayers = ESX.GetPlayers()
    
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        
        TriggerClientEvent('shesh', xPlayer.source)
    end]]

    local xPlayer = ESX.GetPlayerFromId(source)            
    
    TriggerClientEvent('ot-notify:notify', source, "#db2a91", "SakuraLife-Core", "Dein Rang: " .. xPlayer.getGroup())
end, false)

RegisterServerEvent('ot-notify:tc')
AddEventHandler('ot-notify:tc', function(title, message)
    local xPlayer1 = ESX.GetPlayerFromId(source)
    
    if xPlayer1.getGroup() ~= "user" then
        local xPlayers = ESX.GetPlayers()

        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

            if xPlayer.getGroup() ~= "user" then
                TriggerClientEvent('ot-notify:notify', xPlayers[i], "#db2a91", "TeamChat", xPlayer1.getName() .. ": " .. message)
            end
        end
    end
end)

RegisterServerEvent('kidu:notify')
AddEventHandler('kidu:notify', function()
    DropPlayer(source, "Bitte deaktiviere deinen Stretch...")
end)

RegisterServerEvent('ot-notify:support')
AddEventHandler('ot-notify:support', function(message)
    local xPlayers = ESX.GetPlayers()
    local xPlayer1 = ESX.GetPlayerFromId(source)
    TriggerClientEvent('ot-notify:notify', xPlayer1.source, "#db2a91", "Support Anfrage", "Du hast deine Support Anfrage erfolgreich versendet.")

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.getGroup() ~= "user" then
            TriggerClientEvent('ot-notify:notify', xPlayers[i], "#db2a91", "Support Anfrage", "ID: " .. xPlayer1.source .. " | " .. xPlayer1.getName() .. ": " ..  message)
        end
    end
end)

--fix
RegisterCommand("repair", function(source, args, rawCommand)
    if source > 0 then
        if checkAllowed(source) == "superadmin" then
            TriggerClientEvent('fixv', source)
        end
    else
        print("This is console!")
    end
end, false)

RegisterCommand("clean", function(source, args, rawCommand)
    if source > 0 then
        if checkAllowed(source) == "superadmin" then
            TriggerClientEvent('clearv', source)
        end
    else
        print("This is console!")
    end
end, false)

RegisterCommand("lsc", function(source, args, rawCommand)
    if source > 0 then
        if checkAllowed(source) == "superadmin" then
            TriggerClientEvent('doThatFuckingMechanic', source)
        end
    else
        print("This is console!")
    end
end, false)

--==--==--==--==--==--==--==--
   --[[    Whitelist    ]]--
--==--==--==--==--==--==--==--
local pedWhitelist = {
    "license:05c0b7d6256df05caffffcd3d6ab32f99e4074c4",
    --[["license:88d7090fe35877152abb0d9518d9b6018112034f",
    "license:45cf1af6baa4168ad6ab68ba48698d298e7d081d",
    "license:5c7ded54795aacece56c8592f5c00af0a0d93952",]]
    --"steam:1100001412a5464",
}

function isAdmin(player)
    local allowed = false
    for i,id in ipairs(pedWhitelist) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

local loadOutWhitelist = {
    "license:3f696b9e70a348e6aafecf0b2e7f1dc754fe22c1",
    "license:88a3fa346c678c2e53a9dcc64ef770c437be9492",
    "license:57de9b0cb7342eb6b0a14921a51c7d314392e125",
    "steam:11000011cc100d0",
    --[["license:88d7090fe35877152abb0d9518d9b6018112034f",
    "license:45cf1af6baa4168ad6ab68ba48698d298e7d081d",
    "license:5c7ded54795aacece56c8592f5c00af0a0d93952",]]
    --"steam:1100001412a5464",
}

function isAdmin(player)
    local allowed = false
    for i,id in ipairs(pedWhitelist) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end

function isLoadouted(player)
    local allowed = false
    for i,id in ipairs(loadOutWhitelist) do
        for x,pid in ipairs(GetPlayerIdentifiers(player)) do
            if string.lower(pid) == string.lower(id) then
                allowed = true
            end
        end
    end
    return allowed
end


RegisterCommand('tier', function(source, args, rawCommand)
    --[[ESX.TriggerServerCallback("SakuraLife:fetchUserRank", function(playerRank)
        if playerRank == "admin" or playerRank == "superadmin" then]]
            if isAdmin(source) then
                TriggerClientEvent('SakuraLife-core:pedMenu', source)
            else
                TriggerClientEvent('ot-notify:notify', source, "", "SakuraLife-Core", "Du stehst nicht auf der Whitelist! Deine Identifiers: \n" .. GetPlayerIdentifiers(source))
            end
        --end
    --end)
end, false)

RegisterCommand("resetloadout", function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)            
    
    if args[1] == nil then
        return
    end
    
    if isLoadouted(source) then
        print(args[1])
        MySQL.Async.fetchScalar('SELECT COUNT(1) FROM users WHERE license = @identifier', {
            ['@identifier'] = args[1]
        }, function(users)
            if users > 0 then
                MySQL.Async.execute('UPDATE users SET loadout = NULL WHERE license = "' .. args[1] .. '"', {}, function(rowsChanged)
                    --callback()
                end)
                TriggerClientEvent('ot-notify:notify', source, "#db2a91", "SakuraLife-Core", "Loadout von " .. args[1] .. " resetted!")
            else
                TriggerClientEvent('ot-notify:notify', source, "#db2a91", "SakuraLife-Core", "Bitte gebe eine gültige Steam ID an!")
            end
        end)
    end
end, true)

RegisterCommand("_resetloadout", function(source, args)
    if source ~= 0 then
        return
    end

    MySQL.Async.fetchScalar('SELECT COUNT(1) FROM users WHERE license = @identifier', {
        ['@identifier'] = args[1]
    }, function(users)
        if users > 0 then
            MySQL.Async.execute('UPDATE users SET loadout = NULL WHERE license = "' .. args[1] .. '"', {}, function(rowsChanged)
                --callback()
            end)
            --TriggerClientEvent('ot-notify:notify', source, "#db2a91", "SakuraLife-Core", "Loadout von " .. args[1] .. " resetted!")
            print("Loadout von " .. args[1] .. " resetted!")
        else
            print("Bitte gebe eine gültige Steam ID an!")
            --TriggerClientEvent('ot-notify:notify', source, "#db2a91", "SakuraLife-Core", "Bitte gebe eine gültige Steam ID an!")
        end
    end)
end, true)

--[[RegisterCommand('koki', function(source, args, rawCommand)
    --[[ESX.TriggerServerCallback("SakuraLife:fetchUserRank", function(playerRank)
        if playerRank == "admin" or playerRank == "superadmin" then
            local xPlayer1 = ESX.GetPlayerFromId(source)
    
                local xPlayers = ESX.GetPlayers()
        
                for i=1, #xPlayers, 1 do
                    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        
                    xPlayer.addInventoryItem('koks', 5)
                end
        --end
    --end)
end, false)
]]
--==--==--==--==--==--==--==--
   --[[    Whitelist    ]]--
--==--==--==--==--==--==--==--

function checkAllowed(source)
	local player = ESX.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            return playerGroup
        else
            return "user"
        end
    else
        return "user"
    end
end