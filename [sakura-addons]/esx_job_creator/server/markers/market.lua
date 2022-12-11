function getMarketItems(playerId, cb, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local items = {}
    
    for itemName, itemData in pairs(fullMarkerData[markerId].data.items) do
        local color = "green"

        if(itemData.blackMoney) then
            color = "red"
        end

        table.insert(items, {
            label = getLocalizedText('market_item', ESX.GetItemLabel(itemName), color, itemData.price),
            value = itemName
        })
    end

    cb(items)
end

local function sellMarketItem(markerId, itemName, itemQuantity)
    local playerId = source

    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local itemData = fullMarkerData[markerId].data.items[itemName]

    if(itemData) then
        local itemLabel = ESX.GetItemLabel(itemName)

        local xPlayer = ESX.GetPlayerFromId(playerId)

        if(xPlayer.getInventoryItem(itemName).count >= itemQuantity) then
            xPlayer.removeInventoryItem(itemName, itemQuantity)
            
            local totalMoney = itemData.price * itemQuantity

            if(itemData.blackMoney) then
                xPlayer.addAccountMoney('black_money', totalMoney)
            else
                local moneyAccount = xPlayer.getAccount('money')

                if(moneyAccount) then
                    xPlayer.addAccountMoney('money', totalMoney)
                else
                    xPlayer.addMoney(totalMoney)
                end
            end

            local color = "~g~"

            if(itemData.blackMoney) then
                color = "~r~"
            end

            notify(playerId, getLocalizedText('you_sold', itemQuantity, itemLabel, color, ESX.Math.GroupDigits(totalMoney)))

            log(
                playerId,
                getLocalizedText('log_sold_item'),
                getLocalizedText('log_sold_item_description', itemQuantity, itemLabel, ESX.Math.GroupDigits(totalMoney)),
                'success',
                'market'
            )
        else
            notify(playerId, getLocalizedText('not_enough_item', itemLabel))
        end
    end
end
RegisterNetEvent('esx_job_creator:sellMarketItem', sellMarketItem)