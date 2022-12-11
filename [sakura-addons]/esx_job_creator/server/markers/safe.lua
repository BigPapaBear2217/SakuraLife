function getPlayerSafeAccounts(playerId, cb)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    local accounts = {}

    for k, accountName in pairs(config.depositableInSafeAccounts) do
        local account = xPlayer.getAccount(accountName)
        
        if(account) then
            local accountMoney = account.money

            if (accountMoney > 0) then
                local color = "green"

                if (accountName == "black_money") then
                    color = "red"
                end

                local accountLabel = getLocalizedText('account', account.label or accountName, color,
                    ESX.Math.GroupDigits(accountMoney))

                table.insert(accounts, {
                    accountName = accountName,
                    label = accountLabel,
                    money = accountMoney
                })
            end
        elseif(accountName == "money" and config.enableCashInSafesOldESX) then
            local playerCash = xPlayer.getMoney()

            if(playerCash > 0) then
                local accountLabel = getLocalizedText('account', getLocalizedText('cash'), "green",
                        ESX.Math.GroupDigits(playerCash))

                table.insert(accounts, {
                    accountName = "money",
                    label = accountLabel,
                    money = playerCash
                })
            end
        end
    end

    cb(accounts)
end

function retrieveReadableSafeData(playerId, cb, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)

    local safeData = fullMarkerData[markerId].data or {}
    
    local elements = {}

    for accountName, money in pairs(safeData) do
        local account = xPlayer.getAccount(accountName)
        
        if (account and money > 0) then
            local color = "green"

            if (accountName == "black_money") then
                color = "red"
            end

            local accountLabel = getLocalizedText('account', account.label or accountName, color,
                ESX.Math.GroupDigits(money))

            table.insert(elements, {
                accountName = accountName,
                label = accountLabel,
                money = money
            })
        elseif(accountName == "money" and money > 0 and config.enableCashInSafesOldESX) then
            local accountLabel = getLocalizedText('account', getLocalizedText('cash'), "green",
            ESX.Math.GroupDigits(money))

            table.insert(elements, {
                accountName = accountName,
                label = accountLabel,
                money = money
            })
        end
    end

    cb(elements)
end

local function addMoneyToSafe(playerId, markerId, accountName, accountLabel, moneyQuantity, cb)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    local quantityDigits = ESX.Math.GroupDigits(moneyQuantity)

    log(playerId, 
        getLocalizedText('log_deposited_safe'),
        getLocalizedText('log_deposited_safe_description',
            quantityDigits,
            accountLabel,
            markerId
        ),
        'success',
        'safe'
    )

    local safeData = fullMarkerData[markerId].data or {}

    safeData[accountName] = safeData[accountName] or 0

    safeData[accountName] = safeData[accountName] + moneyQuantity

    MySQL.Async.execute('UPDATE jobs_data SET data=@inventory WHERE id=@markerId', {
        ['@inventory'] = json.encode(safeData),
        ['@markerId'] = markerId
    }, function(affectedRows)
        if(affectedRows > 0) then
            fullMarkerData[markerId].data = safeData
            cb(true)
        else
            cb(false)
        end
    end)
end

function depositIntoSafe(playerId, cb, accountName, quantity, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)

    local account = xPlayer.getAccount(accountName)

    if (account and account.money >= quantity) then
        xPlayer.removeAccountMoney(accountName, quantity)

        local accountLabel = xPlayer.getAccount(accountName).label

        local color = "~g~"

        if (accountName == "black_money") then
            color = "~r~"
        end

        local quantityDigits = ESX.Math.GroupDigits(quantity)

        notify(playerId, getLocalizedText('deposited_safe', color, quantityDigits, accountLabel))

        addMoneyToSafe(playerId, markerId, accountName, accountLabel, quantity, cb)
    elseif(accountName == "money" and config.enableCashInSafesOldESX) then
        local playerMoney = xPlayer.getMoney()

        if(playerMoney >= quantity) then
            xPlayer.removeMoney(quantity)

            local quantityDigits = ESX.Math.GroupDigits(quantity)

            notify(playerId, getLocalizedText('deposited_safe', "~g~", quantityDigits, getLocalizedText("cash")))
            
            addMoneyToSafe(playerId, markerId, accountName, getLocalizedText("cash"), quantity, cb)
        else
            cb(false)
        end
    else
        cb(false)
    end
end

function withdrawFromSafe(playerId, cb, accountName, quantity, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)

    local safeData = fullMarkerData[markerId].data or {}

    safeData[accountName] = safeData[accountName] or 0

    if (safeData[accountName] >= quantity) then
        local account = xPlayer.getAccount(accountName)
        
        local accountLabel = nil

        local hasWithdrawn = false

        if(account) then
            xPlayer.addAccountMoney(accountName, quantity)
            accountLabel = account.label
            hasWithdrawn = true
        elseif(accountName == "money" and config.enableCashInSafesOldESX) then
            xPlayer.addMoney(quantity)
            accountLabel = getLocalizedText('cash')
            hasWithdrawn = true
        end

        if(hasWithdrawn) then
            safeData[accountName] = safeData[accountName] - quantity

            local color = "~g~"

            if (accountName == "black_money") then
                color = "~r~"
            end

            local quantityDigits = ESX.Math.GroupDigits(quantity)

            notify(playerId, getLocalizedText('withdrawn_safe', color, quantityDigits, accountLabel))

            log(playerId, 
                getLocalizedText('log_withdrew_safe'),
                getLocalizedText('log_withdrew_safe_description',
                    quantityDigits,
                    accountLabel,
                    markerId
                ),
                'success',
                'safe'
            )

            MySQL.Async.execute('UPDATE jobs_data SET data=@inventory WHERE id=@markerId', {
                ['@inventory'] = json.encode(safeData),
                ['@markerId'] = markerId
            }, function(affectedRows)
                if(affectedRows > 0) then
                    fullMarkerData[markerId].data = safeData
                end

                cb(true)
            end)
        else
            cb(false)
        end
    else
        cb(false)
    end
end