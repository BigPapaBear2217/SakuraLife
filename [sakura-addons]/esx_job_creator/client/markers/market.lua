function openMarket(markerId)
    ESX.UI.Menu.CloseAll()
    
    ESX.TriggerServerCallback('esx_job_creator:getMarketItems', function(items) 
        items = items or {}

        if(#items == 0) then
            table.insert(items, {label = getLocalizedText("nothing_can_be_sold_yet")})
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'market_sell', {
            title = getLocalizedText('market'),
            align = 'bottom-right',
            elements = items
        },
        function(data, menu)
            local itemName = data.current.value

            if(itemName) then
                askQuantity(getLocalizedText('market:how_many_to_sell'), "market_sell_quantity", 1, nil, function(quantity)
                    if(quantity) then
                        TriggerServerEvent('esx_job_creator:sellMarketItem', markerId, itemName, quantity)
                    end
                end)
            end
        end,
        function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end, markerId)
end