function openCraftingTable(markerId)
    ESX.TriggerServerCallback('esx_job_creator:getCraftingTableData', function(craftingTableData) 
        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'crafting_table', {
            title = getLocalizedText('crafting_table'),
            align = 'bottom-right',
            elements = craftingTableData
        },
        function(data, menu)
            local itemName = data.current.itemName
            
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'crafting_table_recipe', {
                title = getLocalizedText('crafting_table'),
                align = 'bottom-right',
                elements = data.current.recipeElements
            },
            function(data, menu)
                if(data.current.type == "slider") then
                    local craftAmount = data.current.value
                    
                    TriggerServerEvent('esx_job_creator:craftItem', markerId, itemName, craftAmount)
                end
            end,
            function(data, menu)
                openedMenu = nil
                menu.close()
            end, function(data, menu)
                if(data.current.type == "slider") then
                    local elements = {}

                    for elementId, elementData in pairs(data.elements) do
                        if(elementData.type == "default") then
                            local color = "green"

                            local newQuantity = elementData.quantity * data.current.value
                            
                            if(elementData.itemQuantity < newQuantity) then
                                color = "red" 
                            end

                            local label = getLocalizedText('ingredient', elementData.itemLabel, color, elementData.itemQuantity, newQuantity)
                            
                            menu.setElement(elementId, "label", label)
                        end
                    end

                    menu.refresh()
                end
            end)
        end,
        function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end, markerId)
end

local function startCrafting(time, text)
    startProgressBar(time, text)

    local isCrafting = true

    SetTimeout(time, function()
        if(isCrafting) then
            isCrafting = false
        end
    end)

    local hasStopped = false

    while isCrafting do
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 257, true)
        DisableControlAction(0, 263, true)
        DisableControlAction(0, 32, true)
        DisableControlAction(0, 34, true)
        DisableControlAction(0, 31, true)
        DisableControlAction(0, 30, true)

        DisableControlAction(0, 45, true)
        DisableControlAction(0, 22, true)
        DisableControlAction(0, 44, true)
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 23, true)

        DisableControlAction(0, 59, true)
        DisableControlAction(0, 71, true)
        DisableControlAction(0, 72, true)
        DisableControlAction(0, 36, true)
        DisableControlAction(0, 47, true)
        DisableControlAction(0, 264, true)
        DisableControlAction(0, 257, true)
        DisableControlAction(0, 140, true)
        DisableControlAction(0, 141, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 143, true)
        DisableControlAction(0, 75, true)

        if(not hasStopped) then
            ESX.ShowHelpNotification(getLocalizedText('press_to_stop'), true)

            if(IsControlJustReleased(0, 38)) then
                TriggerServerEvent('esx_job_creator:stopCrafting')

                notifyClient(getLocalizedText('you_stopped'))

                hasStopped = true
            end
        end

        Citizen.Wait(0)
    end
end
RegisterNetEvent('esx_job_creator:crafting_table:startCrafting', startCrafting)