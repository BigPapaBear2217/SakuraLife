function retrieveStashItems(playerId, markerId, cb)
    return fullMarkerData[markerId].data
end

local function addItemToStash(markerId, itemName, itemQuantity, cb)
    local inventory = fullMarkerData[markerId].data or {}

    if (inventory[itemName]) then
        inventory[itemName] = inventory[itemName] + itemQuantity
    else
        inventory[itemName] = itemQuantity
    end

    MySQL.Async.execute('UPDATE jobs_data SET data=@inventory WHERE id=@markerId', {
        ['@inventory'] = json.encode(inventory),
        ['@markerId'] = markerId
    }, function(affectedRows)
        if(affectedRows > 0) then
            fullMarkerData[markerId].data = inventory

            cb(true)
        else
            cb(false)
        end
    end)
end

local function removeItemFromStash(markerId, itemName, itemQuantity, cb)
    local inventory = fullMarkerData[markerId].data or {}
    
    if (inventory[itemName] and inventory[itemName] >= itemQuantity) then
        inventory[itemName] = inventory[itemName] - itemQuantity

        if (inventory[itemName] == 0) then
            inventory[itemName] = nil
        end

        MySQL.Async.execute('UPDATE jobs_data SET data=@inventory WHERE id=@markerId', {
            ['@inventory'] = json.encode(inventory),
            ['@markerId'] = markerId
        }, function(affectedRows)
            if(affectedRows > 0) then
                fullMarkerData[markerId].data = inventory
                cb(true)
            else
                cb(false)
            end
        end)
    else
        cb(false)
    end
end

function deleteStashInventory(markerId, cb)
    MySQL.Async.execute('UPDATE jobs_data SET data="{}" WHERE id=@markerId AND type="stash"', {
        ['@markerId'] = markerId
    }, function(affectedRows)
        if (affectedRows > 0) then
            fullMarkerData[markerId].data = {}
            
            local cbData = {
                isSuccessful = true,
                message = "Successful"
            }
            cb(cbData)
        else
            local cbData = {
                isSuccessful = false,
                message = "Couldn't delete stash inventory"
            }
            cb(cbData)
        end
    end)
end

function takeItem(playerId, cb, itemName, itemQuantity, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jobName = xPlayer.job.name
    local jobGrade = xPlayer.job.grade

    if(canPlayerCarry(playerId, itemName, itemQuantity)) then
        removeItemFromStash(markerId, itemName, itemQuantity, function(isSuccessful) 
            if(isSuccessful) then
                xPlayer.addInventoryItem(itemName, itemQuantity)
                notify(xPlayer.source, getLocalizedText("took", itemQuantity, ESX.GetItemLabel(itemName)))
                
                log(playerId, 
                    getLocalizedText('log_took_stash'),
                    getLocalizedText('log_took_stash_description', 
                        itemQuantity,
                        ESX.GetItemLabel(itemName),
                        itemName,
                        markerId
                    ),
                    'success',
                    'stash'
                )

                cb(true)
            else
                notify(xPlayer.source, getLocalizedText("impossible_take", itemQuantity, ESX.GetItemLabel(itemName)))

                cb(false)
            end
        end)
    else
        notify(xPlayer.source, getLocalizedText("no_space"))

        cb(false)
    end
end

function depositItem(playerId, cb, itemName, itemQuantity, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jobName = xPlayer.job.name
    local jobGrade = xPlayer.job.grade
    
    local invItem = xPlayer.getInventoryItem(itemName)

    if(invItem.count >= itemQuantity) then
        notify(xPlayer.source, getLocalizedText("deposited", itemQuantity, invItem.label))
        
        xPlayer.removeInventoryItem(itemName, itemQuantity)

        log(playerId, 
            getLocalizedText('log_deposited_stash'),
            getLocalizedText('log_deposited_stash_description',
                itemQuantity,
                invItem.label,
                itemName,
                markerId
            ),
            'success',
            'stash'
        )

        addItemToStash(markerId, itemName, itemQuantity, cb)
    else
        notify(xPlayer.source, getLocalizedText("not_enough", invItem.label))

        cb(false)
    end
end