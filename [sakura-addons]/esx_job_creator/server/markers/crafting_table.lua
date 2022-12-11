function getCraftingTableData(playerId, cb, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jobName = xPlayer.job.name
    local jobGrade = xPlayer.job.grade

    local craftingTableData = fullMarkerData[markerId].data or {}

    local craftableItems = {}
    
    if (craftingTableData.craftablesItems) then
        for resultItemName, craftingData in pairs(craftingTableData.craftablesItems) do
            local canCraftThisItem = true
            local recipe = craftingData.recipes

            local recipeElements = {}

            local maxCanCurrentlyCraft = 0

            for ingredientName, ingredientData in pairs(recipe) do
                local item = xPlayer.getInventoryItem(ingredientName)
                local itemQuantity = item.count
                local itemLabel = item.label

                local maxTimesItemCanBeUsed = math.floor(itemQuantity / ingredientData.quantity)

                if (maxTimesItemCanBeUsed < maxCanCurrentlyCraft or maxCanCurrentlyCraft == 0) then
                    maxCanCurrentlyCraft = maxTimesItemCanBeUsed
                end

                local color = "green"

                if (itemQuantity < ingredientData.quantity) then
                    color = "red"
                    canCraftThisItem = false
                end

                local label = getLocalizedText('ingredient',
                    itemLabel,
                    color,
                    itemQuantity,
                    ingredientData.quantity
                )

                table.insert(recipeElements, {
                    label = label,
                    quantity = ingredientData.quantity,
                    itemLabel = itemLabel,
                    itemQuantity = itemQuantity
                })
            end

            table.insert(recipeElements, {
                label = "Craft amount",
                value = maxCanCurrentlyCraft > 0 and 1 or 0,
                min = 1,
                max = maxCanCurrentlyCraft,
                type = "slider"
            })

            local itemLabel = ESX.GetItemLabel(resultItemName) or ESX.GetWeaponLabel(resultItemName) or resultItemName

            local color = "green"

            if (not canCraftThisItem) then
                color = "red"
            end

            table.insert(craftableItems, {
                label = getLocalizedText('craft_item_label', color, itemLabel),
                itemName = resultItemName,
                recipeElements = recipeElements
            })
        end
    end
    
    cb(craftableItems)
end

local function hasAllItem(playerId, recipe)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local hasAllIngredients = true

    for ingredientName, ingredientData in pairs(recipe) do
        local invItem = xPlayer.getInventoryItem(ingredientName)

        if (invItem) then
            if (invItem.count < ingredientData.quantity) then
                hasAllIngredients = false
            end
        else
            local msg = "^6[%s]^7 Item '^5%s^7' doesn't exist"

            print(format(msg, GetCurrentResourceName(), ingredientName))
            hasAllIngredients = false
        end
    end

    return hasAllIngredients
end

local playerCraftingItems = {}
RegisterNetEvent('esx_job_creator:craftItem')
AddEventHandler('esx_job_creator:craftItem', function(markerId, itemName, craftAmount)
    craftAmount = craftAmount or 1
    local playerId = source

    if (not playerCraftingItems[playerId]) then
        local xPlayer = ESX.GetPlayerFromId(playerId)

        local jobName = xPlayer.job.name
        local jobGrade = xPlayer.job.grade

        local craftingTableData = fullMarkerData[markerId].data or {}

        if (craftingTableData.craftablesItems) then
            local recipe = craftingTableData.craftablesItems[itemName].recipes
            local animations = craftingTableData.craftablesItems[itemName].animations or {}

            local itemQuantity = craftingTableData.craftablesItems[itemName].quantity or 1

            local craftingTime = craftingTableData.craftablesItems[itemName].craftingTime or 8

            if(#animations == 0) then
                table.insert(animations, {
                    type = "scenario",
                    scenarioName = "PROP_HUMAN_BUM_BIN",
                    scenarioDuration = craftingTime
                })
            end

            if (recipe) then
                playerCraftingItems[playerId] = true

                for i = 1, craftAmount do
                    if (not playerCraftingItems[playerId]) then
                        return
                    end

                    if (hasAllItem(playerId, recipe)) then
                        local itemType = "item"
                        local itemLabel = ESX.GetItemLabel(itemName)

                        if (not itemLabel) then
                            itemType = "weapon"
                            itemLabel = ESX.GetWeaponLabel(itemName)
                        end

                        itemLabel = itemLabel or itemName

                        if (itemType == "item") then
                            if (not canPlayerCarry(playerId, itemName, 1)) then
                                notify(xPlayer.source, getLocalizedText("no_space"))
                                playerCraftingItems[playerId] = false
                                return
                            end
                        elseif (itemType == "weapon") then
                            if (xPlayer.hasWeapon(itemName)) then
                                notify(xPlayer.source, getLocalizedText("already_have", itemLabel))

                                playerCraftingItems[playerId] = false
                                return
                            end
                        end

                        local craftingTime = craftingTime * 1000

                        TriggerClientEvent('esx_job_creator:crafting_table:startCrafting', playerId, craftingTime, getLocalizedText('crafting', itemLabel))
                        playAnimation(playerId, animations)

                        Citizen.Wait(craftingTime)

                        if (hasAllItem(playerId, recipe)) then
                            for ingredientName, ingredientData in pairs(recipe) do
                                if (ingredientData.loseOnUse) then
                                    xPlayer.removeInventoryItem(ingredientName, ingredientData.quantity)
                                end
                            end

                            if (itemType == "item") then
                                xPlayer.addInventoryItem(itemName, itemQuantity)
                            else
                                xPlayer.addWeapon(itemName, 0)
                            end

                            notify(xPlayer.source, getLocalizedText("you_crafted", itemQuantity, itemLabel))

                            log(playerId, 
                                getLocalizedText('log_crafted_item'),
                                
                                getLocalizedText('log_crafted_item_description',
                                    itemQuantity,
                                    itemLabel,
                                    itemName,
                                    markerId
                                ),
                                'success',
                                'crafting_table'
                            )

                            Citizen.Wait(2000)
                        else
                            notify(xPlayer.source, getLocalizedText("dont_have_ingredients"))
                        end
                    else
                        notify(xPlayer.source, getLocalizedText("dont_have_ingredients"))
                    end
                end

                playerCraftingItems[playerId] = false
            end
        end
    end
end)

RegisterNetEvent('esx_job_creator:stopCrafting')
AddEventHandler('esx_job_creator:stopCrafting', function()
    local playerId = source
    playerCraftingItems[playerId] = false
end)
