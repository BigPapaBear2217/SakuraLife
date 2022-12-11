RegisterNetEvent('scratchcard:OpenCard')
AddEventHandler('scratchcard:OpenCard', function()
    OpenCard()
end)

function OpenCard()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openScratchCard',
        prizes = Config.Prizes,
        items = Config.Items,
        currency = Config.CurrencySymbol
    }) 
end

RegisterNUICallback('wonScratchCard', function(data)
    Notif('Gewonnen! Dir wurden  ~w~~b~'.. Config.CurrencySymbol ..'~w~' .. comma_value(data.prize) .. ' ~g~gutgeschrieben!')
    if Config.UsingESX then 
        TriggerServerEvent('scratchcard:givePrizeMoney', data.prize)
    end
end)

RegisterNUICallback('lostScratchCard', function()
 Notif('Eine Niete! Schade')
end)

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

function Notif(msg) 
    SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

function comma_value(amount)
    local formatted = amount
    while true do  
      formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
      if (k==0) then
        break
      end
    end
    return formatted
end