local playerProcessing = {}

local function startProcessing(markerId)
    local playerId = source

    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    if(playerProcessing[playerId]) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)

    if(fullMarkerData[markerId].data) then
        local itemToRemoveName = fullMarkerData[markerId].data.itemToRemoveName
        local itemToRemoveQuantity = fullMarkerData[markerId].data.itemToRemoveQuantity
        local itemToAddName = fullMarkerData[markerId].data.itemToAddName
        local itemToAddQuantity = fullMarkerData[markerId].data.itemToAddQuantity
        local timeToProcess = fullMarkerData[markerId].data.timeToProcess
        local animations = fullMarkerData[markerId].data.animations or {}

        if(#animations == 0) then
            table.insert(animations, {
                type = "scenario",
                scenarioName = "PROP_HUMAN_BUM_BIN",
                scenarioDuration = timeToProcess
            })
        end

        if(xPlayer.getInventoryItem(itemToRemoveName).count >= itemToRemoveQuantity) then
            if(canPlayerCarry(playerId, itemToAddName, itemToAddQuantity)) then
                xPlayer.removeInventoryItem(itemToRemoveName, itemToRemoveQuantity)

                local itemToRemoveLabel = ESX.GetItemLabel(itemToRemoveName)

                progressBar(playerId, timeToProcess * 1000, getLocalizedText('process:processing', itemToRemoveLabel))
                playAnimation(playerId, animations)
                Citizen.Wait(timeToProcess * 1000)

                
                if(isCloseToMarker(playerId, markerId)) then
                    xPlayer.addInventoryItem(itemToAddName, itemToAddQuantity)

                    TriggerClientEvent('esx_job_creator:process:finishedProcessing', playerId, markerId, config.allowAfkFarming)
    
                    log(
                        playerId,
                        getLocalizedText('logs:process:title'),
                        getLocalizedText('logs:process:description', itemToRemoveQuantity, itemToRemoveLabel, itemToAddQuantity, ESX.GetItemLabel(itemToAddName)),
                        'success',
                        'process'
                    )
                else
                    TriggerClientEvent('esx_job_creator:process:finishedProcessing', playerId, markerId, false)
                    notify(playerId, getLocalizedText("too_far"))
                end
            else
                TriggerClientEvent('esx_job_creator:process:finishedProcessing', playerId, markerId, false)
                notify(playerId, getLocalizedText("process:no_space", itemToAddQuantity, ESX.GetItemLabel(itemToAddName)))
            end
        else
            notify(playerId, getLocalizedText('process:you_need', itemToRemoveQuantity, ESX.GetItemLabel(itemToRemoveName)))
            TriggerClientEvent('esx_job_creator:process:finishedProcessing', playerId, markerId, false)
        end
    end
end
RegisterNetEvent('esx_job_creator:process:startProcessing', startProcessing)