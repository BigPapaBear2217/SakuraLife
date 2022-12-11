local harvestingPlayers = {}

local function harvest(markerId)
    local playerId = source
    
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    if(harvestingPlayers[playerId]) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)

    if(fullMarkerData[markerId].data) then
        local harvestableItems = fullMarkerData[markerId].data.harvestableItems

        local itemToHarvest = getRandomElementFromTable(harvestableItems)

        local itemQuantity = math.random(itemToHarvest.minQuantity, itemToHarvest.maxQuantity)

        local itemName = itemToHarvest.name
        local itemTime = itemToHarvest.time

        local animations = fullMarkerData[markerId].data.animations or {}
    
        local itemTool = fullMarkerData[markerId].data.itemTool
        local itemToolLoseQuantity = fullMarkerData[markerId].data.itemToolLoseQuantity

        if(#animations == 0) then
            table.insert(animations, {
                type = "animation",
                animDict = "random@mugging4",
                animName = "pickup_low",
                animDuration = itemTime
            })
        end
        
        if(itemName and itemQuantity and itemTime) then
            itemTime = itemTime * 1000

            if(canPlayerCarry(playerId, itemName, itemQuantity)) then
                harvestingPlayers[playerId] = true

                if(itemTool) then
                    if(itemToolLoseQuantity) then
                        if(xPlayer.getInventoryItem(itemTool).count >= itemToolLoseQuantity) then
                            xPlayer.removeInventoryItem(itemTool, itemToolLoseQuantity)
                        else
                            notify(playerId, getLocalizedText("harvest:you_need_tool_count", itemToolLoseQuantity, ESX.GetItemLabel(itemTool)))
                            
                            TriggerClientEvent('esx_job_creator:harvest:finishedHarvesting', playerId, markerId, false)

                            harvestingPlayers[playerId] = false
                            return
                        end
                    else
                        if(not (xPlayer.getInventoryItem(itemTool).count > 0)) then
                            notify(playerId, getLocalizedText("harvest:you_need_tool", ESX.GetItemLabel(itemTool)))

                            TriggerClientEvent('esx_job_creator:harvest:finishedHarvesting', playerId, markerId, false)

                            harvestingPlayers[playerId] = false
                            return
                        end
                    end
                end

                progressBar(playerId, itemTime, getLocalizedText('harvest:harvesting', ESX.GetItemLabel(itemName)))
                playAnimation(playerId, animations)
                Citizen.Wait(itemTime)

                if(isCloseToMarker(playerId, markerId)) then
                    if(canPlayerCarry(playerId, itemName, itemQuantity)) then
                        xPlayer.addInventoryItem(itemName, itemQuantity)

                        log(playerId, 
                            getLocalizedText('log_harvested'),
                            getLocalizedText('log_harvested_description',
                                itemQuantity,
                                ESX.GetItemLabel(itemName),
                                markerId
                            ),
                            'success',
                            'harvest'
                        )

                        TriggerClientEvent('esx_job_creator:harvest:finishedHarvesting', playerId, markerId, config.allowAfkFarming)
                    else
                        TriggerClientEvent('esx_job_creator:harvest:finishedHarvesting', playerId, markerId, false)
                        notify(playerId, getLocalizedText("no_space"))
                    end
                else
                    TriggerClientEvent('esx_job_creator:harvest:finishedHarvesting', playerId, markerId, false)
                    notify(playerId, getLocalizedText("too_far"))
                end

                harvestingPlayers[playerId] = false
            else
                TriggerClientEvent('esx_job_creator:harvest:finishedHarvesting', playerId, markerId, false)
                notify(playerId, getLocalizedText("no_space"))
            end
        else
            TriggerClientEvent('esx_job_creator:harvest:finishedHarvesting', playerId, markerId, false)
            print("Harvesting marker ID " .. markerId .. " not configured")
        end
    end
end

RegisterNetEvent('esx_job_creator:harvestMarkerId')
AddEventHandler('esx_job_creator:harvestMarkerId', harvest)