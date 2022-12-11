local shopsData = {}

function getAllShopsData()
    MySQL.Async.fetchAll('SELECT * FROM jobs_shops', {
        ["@markerId"] = markerId
    }, function(result)
        for k, itemData in pairs(result) do
            local markerId = itemData.marker_id

            if(not shopsData[markerId]) then
                shopsData[markerId] = {}
            end

            if(itemData.item_type == "item_standard") then
                itemData.item_label = ESX.GetItemLabel(itemData.item_name)
            elseif(itemData.item_type == "item_weapon") then
                itemData.item_label = ESX.GetWeaponLabel(itemData.item_name)
            end

            shopsData[markerId][itemData.id] = itemData
        end
    end)
end


function canPlayerSellInShop(playerId, markerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jobName = xPlayer.job.name
    local jobGrade = xPlayer.job.grade

    local shopData = fullMarkerData[markerId].data

    local canSell = shopData.allowedJob == jobName and jobGrade >= shopData.minimumRank
    return canSell
end


function getJobShop(playerId, cb, markerId)
    if(shopsData[markerId]) then
        cb(shopsData[markerId])
    else
        MySQL.Async.fetchAll('SELECT * FROM jobs_shops WHERE marker_id=@markerId', {
            ["@markerId"] = markerId
        }, function(result)
            shopsData[markerId] = {}

            for k, itemData in pairs(result) do
                itemData.item_label = ESX.GetItemLabel(itemData.item_name) or ESX.GetWeaponLabel(itemData.item_name)

                shopsData[markerId][itemData.id] = itemData
            end

            getJobShop(playerId, cb, markerId)
        end)
    end
end


local function jobShopPutOnSale(itemName, itemType, itemQuantity, itemPrice, markerId)
    local playerId = source
    
    if(canPlayerSellInShop(playerId, markerId)) then
        local xPlayer = ESX.GetPlayerFromId(playerId)

        local foundItem = false
        local itemLabel = nil

        if(itemType == "item_standard") then
            local item = xPlayer.getInventoryItem(itemName)

            if(item and item.count >= itemQuantity) then
                foundItem = true
                
                itemLabel = ESX.GetItemLabel(itemName)
    
                xPlayer.removeInventoryItem(itemName, itemQuantity)
            end
        elseif(itemType == "item_weapon") then
            local loadoutNum, weapon = xPlayer.getWeapon(itemName)

            if(weapon and xPlayer.hasWeapon(itemName)) then
                foundItem = true
                itemLabel = weapon.label

                xPlayer.removeWeapon(itemName)
            end
        end

        if(foundItem) then
            MySQL.Async.insert('INSERT INTO jobs_shops(marker_id, item_name, item_type, item_quantity, price) VALUES (@markerId, @itemName, @itemType, @itemQuantity, @price)', {
                ['@itemName'] = itemName,
                ['@itemType'] = itemType,
                ['@itemQuantity'] = itemQuantity,
                ['@price'] = itemPrice,
                ['@markerId'] = markerId,
            }, function(itemId)
                if(itemId > 0) then
                    shopsData[markerId][itemId] = {
                        id = itemId,
                        marker_id = markerId,
                        item_name = itemName,
                        item_type = itemType,
                        item_quantity = itemQuantity,
                        price = itemPrice,
                        item_label = itemLabel
                    }

                    notify(
                        playerId,
                        getLocalizedText('job_shop:you_put_on_sale',
                            itemQuantity,
                            itemLabel,
                            ESX.Math.GroupDigits(itemPrice)
                        )
                    )
                end
            end)
        end
    else
        print("Player not allowed to sell") -- Crea log!!
    end
end
RegisterNetEvent('esx_job_creator:jobShopPutOnSale', jobShopPutOnSale)


local function buyItem(markerId, itemId, quantity)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    local itemData = shopsData[markerId][itemId]

    if(itemData and itemData.item_quantity >= quantity) then
        local canPlayerPurchase = false

        if(itemData.item_type == "item_standard") then
            if(canPlayerCarry(playerId, itemData.item_name, quantity)) then
                canPlayerPurchase = true
            else
                notify(playerId, getLocalizedText('no_space'))
            end
        elseif(itemData.item_type == "item_weapon") then
            if(not xPlayer.hasWeapon(itemData.item_name)) then
                canPlayerPurchase = true
            else
                notify(playerId, getLocalizedText('job_shop:you_already_have_that_weapon', ESX.GetWeaponLabel(itemData.item_name)))
            end
        end

        if(canPlayerPurchase) then
            local totalPrice = itemData.price * quantity

            if(payInSomeWay(playerId, totalPrice)) then

                -- Gives money to society
                local societyName = "society_" .. fullMarkerData[markerId].data.allowedJob
                TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
                    account.addMoney(totalPrice)
                end)

                -- Removes money from player and updates the shop data
                local xPlayer = ESX.GetPlayerFromId(playerId)
                
                if(itemData.item_type == "item_standard") then
                    xPlayer.addInventoryItem(itemData.item_name, quantity)
                elseif(itemData.item_type == "item_weapon") then
                    xPlayer.addWeapon(itemData.item_name, 60)
                end

                notify(playerId, getLocalizedText('job_shop:bought_item', quantity, itemData.item_label, ESX.Math.GroupDigits(totalPrice)))
                
                local newItemQuantity = itemData.item_quantity - quantity

                if(newItemQuantity > 0) then
                    itemData.item_quantity = newItemQuantity

                    MySQL.Async.execute('UPDATE jobs_shops SET item_quantity=@itemQuantity WHERE id=@itemId', {
                        ['@itemQuantity'] = newItemQuantity,
                        ['@itemId'] = itemId
                    })
                else
                    shopsData[markerId][itemId] = nil

                    MySQL.Async.execute('DELETE FROM jobs_shops WHERE id=@itemId', {
                        ['@itemId'] = itemId
                    })
                end
            else
                notify(playerId, getLocalizedText('job_shop_cant_afford'))
            end
        end
    end
end
RegisterNetEvent('esx_job_creator:job_shop:buyItem', buyItem)


local function removeFromSale(markerId, itemId, itemQuantity)
    local playerId = source

    if(canPlayerSellInShop(playerId, markerId)) then
        local itemData = shopsData[markerId][itemId]

        local xPlayer = ESX.GetPlayerFromId(playerId)

        if(itemData.item_type == "item_weapon") then
            if(not xPlayer.hasWeapon(itemData.item_name)) then
                itemQuantity = 1
            else
                notify(playerId, getLocalizedText('job_shop:you_already_have_that_weapon', ESX.GetWeaponLabel(itemData.item_name)))
                return
            end
        end

        if(itemData.item_quantity >= itemQuantity) then
            local itemLabel = nil

            if(itemData.item_type == "item_standard") then
                xPlayer.addInventoryItem(itemData.item_name, itemQuantity)
                itemLabel = ESX.GetItemLabel(itemData.item_name)
            elseif(itemData.item_type == "item_weapon") then
                xPlayer.addWeapon(itemData.item_name, 60)
                itemLabel = ESX.GetWeaponLabel(itemData.item_name)
            end

            notify(playerId,
                getLocalizedText('job_shop:you_removed_from_sale',
                    itemQuantity,
                    itemLabel
                )
            )

            local newItemQuantity = itemData.item_quantity - itemQuantity

            if(newItemQuantity > 0) then
                itemData.item_quantity = newItemQuantity

                MySQL.Async.execute('UPDATE jobs_shops SET item_quantity=@itemQuantity WHERE id=@itemId', {
                    ['@itemQuantity'] = newItemQuantity,
                    ['@itemId'] = itemId
                })
            else
                shopsData[markerId][itemId] = nil

                MySQL.Async.execute('DELETE FROM jobs_shops WHERE id=@itemId', {
                    ['@itemId'] = itemId
                })
            end
        end
    else
        print("tried to remove item from shop but can't ") -- fare log
    end
end
RegisterNetEvent('esx_job_creator:job_shop:removeFromSale', removeFromSale)


local function addSupplies(markerId, itemId, quantity)
    local playerId = source

    if(canPlayerSellInShop(playerId, markerId)) then
        local itemData = shopsData[markerId][itemId]

        local itemName = itemData.item_name
        local itemLabel = nil

        local xPlayer = ESX.GetPlayerFromId(playerId)

        local canAddSupplies = false

        if(itemData.item_type == "item_standard") then
            itemLabel = ESX.GetItemLabel(itemName)

            if(xPlayer.getInventoryItem(itemName).count >= quantity) then
                xPlayer.removeInventoryItem(itemName, quantity)

                canAddSupplies = true
            end
        elseif(itemData.item_type == "item_weapon") then
            itemLabel = ESX.GetWeaponLabel(itemName)
            quantity = 1

            if(xPlayer.hasWeapon(itemName)) then
                xPlayer.removeWeapon(itemName)
                
                canAddSupplies = true
            end
        end

        if(canAddSupplies) then
            local newItemQuantity = itemData.item_quantity + quantity

            itemData.item_quantity = newItemQuantity

            MySQL.Async.execute('UPDATE jobs_shops SET item_quantity=@newQuantity WHERE id=@id', {
                ['@id'] = itemId,
                ['@newQuantity'] = newItemQuantity
            })

            notify(playerId, getLocalizedText('job_shop:added_to_supplies', quantity, itemLabel))
        else
            notify(playerId, getLocalizedText('not_enough', itemLabel))
        end
    else
        print("tried to supply but can't ") -- fare log
    end
end
RegisterNetEvent('esx_job_creator:job_shop:addSupplies', addSupplies)