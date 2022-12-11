local function withdrawStash(markerId)
    ESX.TriggerServerCallback('esx_job_creator:retrieveStash', function(elements)
        if(#elements == 0) then
            table.insert(elements, {label = getLocalizedText("empty_stash")})
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stash_take', {
            title = getLocalizedText('stash_take'),
            align = 'bottom-right',
            elements = elements
        }, 
        function(data, menu) 
            local item = data.current
            
            if(item.value) then
                askQuantity(getLocalizedText('quantity'), "stash_take_dialog", 1, item.quantity, function(quantity)
                    ESX.TriggerServerCallback('esx_job_creator:stash:takeItem', function(isSuccessful)
                        if(isSuccessful) then
                            withdrawStash(markerId)
                        end
                    end, item.value, quantity, markerId)
                end)
            end
        end,
        function(data, menu)
            menu.close()
        end
        )
    end, markerId)
end

local function depositStash(markerId)
    ESX.TriggerServerCallback('esx_job_creator:getPlayerInventory', function(elements)
        if(#elements == 0) then
            table.insert(elements, {label = getLocalizedText("empty_inventory"), value = "emptyinventory"})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stash_deposit', {
            title = getLocalizedText('stash_deposit'),
            align = 'bottom-right',
            elements = elements
        }, 
        function(data, menu)
            local item = data.current

            if(item.value ~= "emptyinventory") then
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stash_deposit_dialog', {
                    title = getLocalizedText('quantity'),
                }, function (data2, menu2)
                    local quantity = tonumber(data2.value)
            
                    if quantity and quantity <= item.quantity then
                        menu2.close()

                        ESX.TriggerServerCallback('esx_job_creator:stash:depositItem', function(isSuccessful)
                            if(isSuccessful) then
                                depositStash(markerId)
                            end
                        end, item.value, quantity, markerId)
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
        end
        )
    end, markerId)
end

function openStash(markerId)
    ESX.UI.Menu.CloseAll()

    local elements = {
        {label = getLocalizedText('deposit'), value = "deposit"},
        {label = getLocalizedText('take'), value = "take"},
    }
    
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stash', {
        title = getLocalizedText('stash'),
        align = 'bottom-right',
        elements = elements
    }, function(data, menu) 
        local value = data.current.value

        if(value == "deposit") then
            depositStash(markerId)
        elseif(value == "take") then
            withdrawStash(markerId)
        end
    end, function(data, menu)
        openedMenu = nil
        menu.close()
    end)
end