local function openJobShopItems(markerId)
    ESX.TriggerServerCallback('esx_job_creator:getJobShop', function(items)
        local elements = {}

        for k, itemData in pairs(items) do
            table.insert(elements, {
                label = getLocalizedText('job_shop_item', itemData.item_label, itemData.item_quantity, ESX.Math.GroupDigits(itemData.price)),
                itemId =  itemData.id,
                itemData = itemData
            })
        end

        if(#elements == 0) then
            table.insert(elements, {
                label = getLocalizedText('job_shop_empty')
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_owned_shop_items', {
            title = getLocalizedText('job_owned_shop'),
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            local itemId = data.current.itemId

            if(itemId) then
                local itemPrice = data.current.itemData.price
                local maxItemQuantity = data.current.itemData.item_quantity
                local itemType = data.current.itemData.item_type

                if(itemType == "item_standard") then
                    askQuantity(getLocalizedText('quantity'), "job_owned_shop_items_quantity", 1, maxItemQuantity, function(quantity)
                        if(quantity) then
                            TriggerServerEvent('esx_job_creator:job_shop:buyItem', markerId, itemId, quantity)

                            openJobShopItems(markerId)
                        end
                    end)
                elseif(itemType == "item_weapon") then
                    TriggerServerEvent('esx_job_creator:job_shop:buyItem', markerId, itemId, 1)

                    openJobShopItems(markerId)
                end
            end
        end,
        function(data, menu)
            menu.close()
        end)
    end, markerId)
end

local function openPutOnSale(markerId)
    ESX.TriggerServerCallback('esx_job_creator:getSellableStuff', function(elements)

        if(#elements == 0) then
            table.insert(elements, {
                label = getLocalizedText('job_shop:nothing_to_sell')
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_owned_shop_put_on_sale', {
            title = getLocalizedText('job_shop:what_to_put_on_sale'),
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            local itemName = data.current.value
            local maxItemQuantity = data.current.count
            local itemType = data.current.type

            if(maxItemQuantity > 1) then
                askQuantity(getLocalizedText('quantity'), "job_owned_shop_put_on_sale_quantity", 1, maxItemQuantity, function(quantity)
                    if(quantity) then
                        askQuantity(getLocalizedText('item_price'), "job_owned_shop_put_on_sale_price", 1, nil, function(price)
                            if(price) then
                                TriggerServerEvent('esx_job_creator:jobShopPutOnSale', itemName, itemType, quantity, price, markerId)
                            
                                openPutOnSale(markerId)
                            end
                        end)
                    end
                end)
            else
                askQuantity(getLocalizedText('item_price'), "job_owned_shop_put_on_sale_price", 1, nil, function(price)
                    if(price) then
                        TriggerServerEvent('esx_job_creator:jobShopPutOnSale', itemName, itemType, maxItemQuantity, price, markerId)
                    
                        openPutOnSale(markerId)
                    end
                end)
            end
        end,
        function(data, menu)
            menu.close()
        end)
    end)
end

local function openRemoveFromSale(markerId)
    ESX.TriggerServerCallback('esx_job_creator:getJobShop', function(items)
        local elements = {}

        for k, itemData in pairs(items) do
            table.insert(elements, {
                label = getLocalizedText('job_shop_item', itemData.item_label, itemData.item_quantity, ESX.Math.GroupDigits(itemData.price)),
                itemId =  itemData.id,
                itemData = itemData
            })
        end

        if(#elements == 0) then
            table.insert(elements, {
                label = getLocalizedText('job_shop_empty')
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_owned_shop_items_remove_from_sale', {
            title = getLocalizedText('job_shop:what_to_remove_from_sale'),
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            local itemId = data.current.itemId

            if(itemId) then
                local maxItemQuantity = data.current.itemData.item_quantity

                if(maxItemQuantity > 1) then
                    askQuantity(getLocalizedText('quantity'), "job_owned_shop_items_remove_from_sale_quantity", 1, maxItemQuantity, function(quantity)
                        if(quantity) then
                            TriggerServerEvent('esx_job_creator:job_shop:removeFromSale', markerId, itemId, quantity)

                            openRemoveFromSale(markerId)
                        end
                    end)
                else
                    TriggerServerEvent('esx_job_creator:job_shop:removeFromSale', markerId, itemId, maxItemQuantity)
                    openRemoveFromSale(markerId)
                end
            end
        end,
        function(data, menu)
            menu.close()
        end)
    end, markerId)
end

local function openAddSupplies(markerId)
    ESX.TriggerServerCallback('esx_job_creator:getJobShop', function(items)
        local elements = {}

        for k, itemData in pairs(items) do
            table.insert(elements, {
                label = getLocalizedText('job_shop_item', itemData.item_label, itemData.item_quantity, ESX.Math.GroupDigits(itemData.price)),
                itemId =  itemData.id,
                itemData = itemData
            })
        end

        if(#elements == 0) then
            table.insert(elements, {
                label = getLocalizedText('job_shop_empty')
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_owned_shop_items_restock', {
            title = getLocalizedText('job_shop:what_to_restock'),
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            local itemId = data.current.itemId

            if(itemId) then
                local maxItemQuantity = data.current.itemData.item_quantity

                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'job_owned_shop_items_restock_quantity', {
                    title = getLocalizedText('job_shop:how_many_to_restock'),
                }, function (data2, menu2)
                    local quantity = tonumber(data2.value)
            
                    if quantity then
                        TriggerServerEvent('esx_job_creator:job_shop:addSupplies', markerId, itemId, quantity)
                        menu2.close()

                        openAddSupplies(markerId)
                    else
                        notifyClient(getLocalizedText('invalid_quantity'))
                    end
                end, function (data2, menu2)
                    menu2.close()
                end)
            end
        end,
        function(data, menu)
            menu.close()
        end)
    end, markerId)
end

function openJobShop(markerId)
    ESX.UI.Menu.CloseAll()
    
    ESX.TriggerServerCallback('esx_job_creator:canSellInThisShop', function(canSell)
        local elements = {
            {label = getLocalizedText('shop'), value = "shop",}
        }

        if(canSell) then
            table.insert(elements, {
                label = getLocalizedText('put_on_sale'),
                value = "put_on_sale"
            })

            table.insert(elements, {
                label = getLocalizedText('remove_from_sale'),
                value = "remove_from_sale"
            })

            table.insert(elements, {
                label = getLocalizedText('job_shop:add_supplies'),
                value = "add_supplies"
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_owned_shop', {
            title = getLocalizedText('job_owned_shop'),
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            local action = data.current.value

            if(action == "shop") then
                openJobShopItems(markerId)
            elseif(action == "put_on_sale") then
                openPutOnSale(markerId)
            elseif(action == "remove_from_sale") then
                openRemoveFromSale(markerId)
            elseif(action == "add_supplies") then
                openAddSupplies(markerId)
            end
        end,
        function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end, markerId)
end