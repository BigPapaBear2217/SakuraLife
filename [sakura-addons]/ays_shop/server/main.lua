ESX = nil

TriggerEvent(AYS.esxgetSharedObjectevent, function(obj) ESX = obj end)

RegisterNetEvent('ays_shop:buy')
AddEventHandler('ays_shop:buy', function(price, korb, state)
	local s = source
	local x = ESX.GetPlayerFromId(s)

    if price > 0 then
        if state == "bar" then
            if x.getMoney() >= price then
                x.removeMoney(price)
                for k,v in pairs(korb) do
                    x.addInventoryItem(v.name, v.amount)
                end
                AYS.notfication(s, string.format(AYS.messages[1], price))
                TriggerClientEvent("ays_shop:close", s, false)
            else
                AYS.notfication(s, AYS.messages[2])
            end
        elseif state == "card" then
            if x.getAccount('bank').money >= price then
                x.removeAccountMoney('bank', price)
                for k,v in pairs(korb) do
                    x.addInventoryItem(v.name, v.amount)
                end
                AYS.notfication(s, string.format(AYS.messages[1], price))
                TriggerClientEvent("ays_shop:close", s, false)
            else
                AYS.notfication(s, AYS.messages[3])
            end
        end
    else
        return
    end
end)