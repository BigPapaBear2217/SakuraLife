Citizen.CreateThread(function()
    --Wait(3000)
    PerformHttpRequest("https://api.ipify.org", function (errorCode, resultData, resultHeaders)
        local ip = resultData
        --PerformHttpRequest("https://meerbi.design/banking.txt", function (errorCode, resultData, resultHeaders)
            --if string.find(resultData, ip) then
                print("^0SakuraLife ^2Erfolgreich gestartet!^0")
                print("Discord.gg/SakuraLife")
                activate()
            --else
                --print("MEERBI.DESIGN - Lizenz ungültig.")
            --end
        --end)
    end)
end)
function activate()
    RegisterServerEvent('client:activate')
    AddEventHandler('client:activate', function()
        local _source = source
        TriggerClientEvent('client:activate2', _source)
    end)

    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

    RegisterServerEvent('bank:deposit')
    AddEventHandler('bank:deposit', function(amount)
        local _source = source

        local xPlayer = ESX.GetPlayerFromId(_source)
        if amount == nil or amount <= 0 then
            TriggerClientEvent('chatMessage', _source, _U('invalid_amount'))
        else
            if amount > xPlayer.getMoney() then
                amount = xPlayer.getMoney()
            end
            xPlayer.removeMoney(amount)
            xPlayer.addAccountMoney('bank', tonumber(amount))
 	TriggerClientEvent('ot-notify:notify', source, "", "Banking", "Du hast erfolgreich Geld eingezahlt!") 
        end
    end)

    RegisterServerEvent('bank:withdraw')
    AddEventHandler('bank:withdraw', function(amount)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local base = 0
        amount = tonumber(amount)
        base = xPlayer.getAccount('bank').money
        if amount == nil or amount <= 0 then
            TriggerClientEvent('chatMessage', _source, _U('invalid_amount'))
        else
            if amount > base then
                amount = base
            end
            xPlayer.removeAccountMoney('bank', amount)
            xPlayer.addMoney(amount)
 	    TriggerClientEvent('ot-notify:notify', source, "", "Banking", "Du hast erfolgreich Geld abgehoben!") 
        end
    end)

    RegisterServerEvent('bank:balance')
    AddEventHandler('bank:balance', function()
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        balance = xPlayer.getAccount('bank').money
        TriggerClientEvent('currentbalance1', _source, balance)

    end)

    RegisterServerEvent('bank:transfer')
    AddEventHandler('bank:transfer', function(to, amountt)
        local _source = source
        local xPlayer = ESX.GetPlayerFromId(_source)
        local zPlayer = ESX.GetPlayerFromId(to)
        local balance = 0
        if zPlayer ~= nil and GetPlayerEndpoint(to) ~= nil then
            balance = xPlayer.getAccount('bank').money
            zbalance = zPlayer.getAccount('bank').money
            if tonumber(_source) == tonumber(to) then
                    TriggerClientEvent('ot-notify:notify', source, "", "Banking", "Du kannst dir nicht selber Geld schicken!")
            else
                if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <=
                    0 then
                    TriggerClientEvent('ot-notify:notify', source, "", "Banking", "Du besitzt nicht genug Geld!")         
       else
                    xPlayer.removeAccountMoney('bank', tonumber(amountt))
                    zPlayer.addAccountMoney('bank', tonumber(amountt))
		TriggerClientEvent('ot-notify:notify', source, "", "Banking", "Überweißung Abgeschlossen!")         
                TriggerClientEvent('ot-notify:notify', source, "", "Banking", "Du hast Geld erhalten! - Check dein Kontostand!")                end

            end
        end

    end)
end