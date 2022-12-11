function getShopData(playerId, cb, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)

    local shopData = fullMarkerData[markerId].data or {}

    local elements = {}

    if (shopData.itemsOnSale) then
        for itemName, itemData in pairs(shopData.itemsOnSale) do
            local itemType = "item_standard"
            local itemLabel = ESX.GetItemLabel(itemName)

            if(not itemLabel) then
                itemLabel = ESX.GetWeaponLabel(itemName)
                itemType = "item_weapon"
            end
            
            if (itemLabel) then
                local color = itemData.blackMoney and "red" or "green"

                table.insert(elements, {
                    label = getLocalizedText('shop:item', itemLabel, color, itemData.price),
                    value = itemName,
                    itemType = itemType
                })
            end
        end
    end

    if(#elements == 0) then
        table.insert(elements, {
            label = getLocalizedText('shop_empty'),
        })
    end

    cb(elements)
end

RegisterNetEvent('esx_job_creator:buyShopItem')
AddEventHandler('esx_job_creator:buyShopItem', function(markerId, itemName, itemQuantity)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    local shopData = fullMarkerData[markerId].data or {}

    local itemPrice = shopData.itemsOnSale[itemName].price
    local useBlackMoney = shopData.itemsOnSale[itemName].blackMoney
    local itemType = "item_standard"
    local itemLabel = ESX.GetItemLabel(itemName)
    local totalPrice = itemPrice * itemQuantity

    -- If it's not an item then it should be a weapon (hopefully)
    if(not itemLabel) then
        itemLabel = ESX.GetWeaponLabel(itemName)
        itemType = "item_weapon"
    end

    if (shopData.itemsOnSale and itemPrice) then
        local canCarry = false

        -- Can the player carry item/weapon?
        if(itemType == "item_standard") then
            if(canPlayerCarry(playerId, itemName, itemQuantity)) then
                canCarry = true
            else
                notify(playerId, getLocalizedText("no_space"))
            end
        elseif(itemType == "item_weapon") then
            if(not xPlayer.hasWeapon(itemName)) then
                canCarry = true
            else
                notify(xPlayer.source, getLocalizedText('shop:you_already_have_that_weapon', itemLabel))
            end
        end

        if(canCarry) then
            local hasPaid = false

            if(useBlackMoney) then
                if(xPlayer.getAccount('black_money').money >= totalPrice) then
                    xPlayer.removeAccountMoney('black_money', totalPrice)
                    
                    hasPaid = true
                end
            else
                if (payInSomeWay(playerId, totalPrice)) then
                    hasPaid = true
                end
            end
    
            if(hasPaid) then

                -- Gives the item/weapon
                if(itemType == "item_standard") then
                    xPlayer.addInventoryItem(itemName, itemQuantity)
                elseif(itemType == "item_weapon") then
                    xPlayer.addWeapon(itemName, 60)
                end

                local color = useBlackMoney and "r" or "g" -- Colors for notifications
                notify(xPlayer.source, getLocalizedText("you_bought", itemQuantity, itemLabel, color, ESX.Math.GroupDigits(totalPrice)))
    
                log(playerId, 
                    getLocalizedText('log_bought_item'),
                        getLocalizedText('log_bought_item_description',
                        itemQuantity,
                        itemLabel,
                        itemName,
                        markerId
                    ),
                    'success',
                    'shop'
                )
            else
                notify(xPlayer.source, getLocalizedText("not_enough_money"))
            end
        end
    elseif (not itemPrice) then
        log(playerId, 
            getLocalizedText('log_not_existing_item'),
            getLocalizedText('log_not_existing_item_description',
                itemName,
                markerId
            ),
            'error',
            'shop'
        )
    end
end)