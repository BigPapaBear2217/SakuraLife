ESX = nil
test = false

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

LOGS.GetIdentifiers = function(source)
    local source = source
    local identifiers = ExtractIdentifiers(source)

    local identifiers2 = ''

    if identifiers.steam ~= nil and identifiers.steam ~= '' then
        local steamId = '\n ``Steam ID``: ' .. identifiers.steam
        local steamUrl = "\n ``Steam Profil``: https://steamcommunity.com/profiles/" .. tonumber(identifiers.steam:gsub('steam:', ''), 16)

        identifiers2 = identifiers2 .. '' .. steamId .. '' .. steamUrl 
    end
    
    if identifiers.discord ~= nil and identifiers.discord ~= '' then
        local discord = "\n ``Discord ID``: " .. identifiers.discord
        local discordName = "\n ``Discord Profil``: <@" .. identifiers.discord:gsub('discord:', '') .. ">"
        identifiers2 = identifiers2 .. '' .. discord .. '' .. discordName 
    end

    return identifiers2
end

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

RegisterServerEvent('oxince:logMessage')
AddEventHandler('oxince:logMessage', function(module, message, logAll)
    logMessage(source, module, message, logAll)
end)

RegisterServerEvent('oxince:logMessage2')
AddEventHandler('oxince:logMessage2', function(module, message, source2, logAll)
    local source = source

    username = LOGS.GetUsername(module)
    webhook = LOGS.GetWebhook(module)
    title = LOGS.GetTitle(module)
    ids = LOGS.GetIdentifiers(source)
    ids2 = LOGS.GetIdentifiers(source2)
    
    if webhook ~= '' then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
            username = username,
            embeds = {{
                ["title"] = "SAKURA-LOGS -> " .. title,
                ["description"] = message,
                ["fields"] = {
                    {
                        ["name"] = GetPlayerName(source),
                        ["value"] = ids,
                        ["inline"] = true,
                    },
                    {
                        ["name"] = GetPlayerName(source2),
                        ["value"] = ids2,
                        ["inline"] = true,
                    },
                },
                ["color"] = 16711680,
                ["author"] = {
                    ["name"] = "Sakura 🌸 Life",
                    ["icon_url"] = "https://media.discordapp.net/attachments/919822070941118514/919822666163191869/LOGO256x256_Animation.gif"
                },
                ["footer"] = {
                    ["text"] = "Sakura Logs"
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                ["thumbnail"] = {
                    ["url"] = "https://media.discordapp.net/attachments/919822070941118514/919822145520009246/Logov3.png"
                },
            }}
        }), {
            ['Content-Type'] = 'application/json'
        })

        if logAll == true then
            PerformHttpRequest(LOGS.GetWebhook("all"), function(err, text, headers) end, 'POST', json.encode({
                username = username,
                embeds = {{
                    ["title"] = "SAKURA-LOGS  -> " .. title,
                    ["description"] = message,
                    ["fields"] = {
                        {
                            ["name"] = GetPlayerName(source),
                            ["value"] = ids,
                            ["inline"] = true,
                        },
                        {
                            ["name"] = GetPlayerName(source2),
                            ["value"] = ids2,
                            ["inline"] = true,
                        },
                    },
                    ["color"] = 16711680,
                    ["author"] = {
                        ["name"] = "Sakura 🌸 Life",
                        ["icon_url"] = "https://media.discordapp.net/attachments/919822070941118514/919822666163191869/LOGO256x256_Animation.gif"
                    },
                    ["footer"] = {
                        ["text"] = "Sakura Logs"
                    },
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                    ["thumbnail"] = {
                        ["url"] = "https://media.discordapp.net/attachments/919822070941118514/919822145520009246/Logov3.png"
                    },
                }}
            }), {
                ['Content-Type'] = 'application/json'
            })
        end
    else
        print('^0[^1SAKURA-LOGS ^0] ^1Module ' .. moduleName .. ' nicht existierend')
    end
end)

ESX.RegisterServerCallback('oxince:getUsername', function(source, cb)
    cb(GetPlayerName(source))
end)

ESX.RegisterServerCallback('oxince:getUsernameById', function(source, cb, id)
    cb(GetPlayerName(tonumber(id)))
end)

--Logs
AddEventHandler("playerConnecting", function(name, setReason, deferrals)
    logMessage(source, 'join', 'Der Spieler **' .. GetPlayerName(source) .. "** hat den Server betreten.", true)
end)

AddEventHandler('playerDropped', function(reason)
    logMessage(source, 'leave', 'Der Spieler **' .. GetPlayerName(source) .. "** hat den Server verlassen.\nGrund: ``" .. reason .. "``", true)
end)

AddEventHandler('chatMessage', function(source, name, msg)
    logMessage(source, 'chat', 'Der Spieler **' .. GetPlayerName(source) .. "** hat den Befehl ``" .. msg .. "`` ausgeführt.", true)
end)

function logMessage(source, module, message, logAll)
    local source = source

    username = LOGS.GetUsername(module)
    webhook = LOGS.GetWebhook(module)
    title = LOGS.GetTitle(module)
    ids = LOGS.GetIdentifiers(source)
    
    if webhook ~= '' then
        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
            username = username,
            embeds = {{
                ["title"] = "SAKURA-LOGS  -> " .. title,
                ["description"] = message .. "\n" .. ids,
                ["color"] = 16711680,
                ["author"] = {
                    ["name"] = "Sakura 🌸 Life",
                    ["icon_url"] = "https://media.discordapp.net/attachments/919822070941118514/919822666163191869/LOGO256x256_Animation.gif"
                },
                ["footer"] = {
                    ["text"] = "Sakura Logs"
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")                ,
                ["thumbnail"] = {
                    ["url"] = "https://media.discordapp.net/attachments/919822070941118514/919822145520009246/Logov3.png"
                },
            }}
        }), {
            ['Content-Type'] = 'application/json'
        })

        if logAll == true then
            PerformHttpRequest(LOGS.GetWebhook("all"), function(err, text, headers) end, 'POST', json.encode({
                username = username,
                embeds = {{
                    ["title"] = "SAKURA-LOGS  -> " .. title,
                    ["description"] = message,
                    ["color"] = 16711680,
                    
                    ["author"] = {
                        ["name"] = "Sakura 🌸 Life",
                        ["icon_url"] = "https://media.discordapp.net/attachments/919822070941118514/919822666163191869/LOGO256x256_Animation.gif"
                    },
                    ["footer"] = {
                        ["text"] = "Sakura Logs"
                    },
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                    ["thumbnail"] = {
                        ["url"] = "https://media.discordapp.net/attachments/919822070941118514/919822145520009246/Logov3.png"
                    },
                }}
            }), {
                ['Content-Type'] = 'application/json'
            })
        end
    else
        print('^0[^1SAKURA-LOGS ^0] ^1Module ' .. moduleName .. ' nicht existierend')
    end
end