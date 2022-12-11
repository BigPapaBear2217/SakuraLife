if Config.UsingESX then 
    ESX = nil

    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    
    ESX.RegisterUsableItem('scratchcard', function(source)
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.removeInventoryItem('scratchcard', 1)
        TriggerClientEvent('scratchcard:OpenCard', source)
    end)
    
    RegisterNetEvent('scratchcard:givePrizeMoney')
    AddEventHandler('scratchcard:givePrizeMoney', function(prize)
        local player = ESX.GetPlayerFromId(source)
        player.addMoney(prize)
        DiscordLog(player.getName(), prize)
    end)
end

function DiscordLog(player, prize)
    if not Config.Discord then return end

    local content = {
        {
            ["color"] = '5015295',
            ["title"] = "Scratch Card Log",
            ["fields"] = {
                {name = "Name"; value = "```" .. player .. "```"; inline = true},
                {name = "Won"; value = "```" .. '$' .. prize .. "```"; inline = true}
            },
            ["footer"] = {
                ["text"] = 'Cheeza Studios™',
                ["icon_url"] = 'https://imgur.com/dtJHO4X.png'
            },
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S')
        }
    }
    
    PerformHttpRequest(Config.WebhookURL, function(err, text, headers) end, 'POST', json.encode({embeds = content}), { ['Content-Type'] = 'application/json' })
end