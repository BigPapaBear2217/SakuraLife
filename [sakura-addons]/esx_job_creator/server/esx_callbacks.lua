function setupESXCallbacks()
    -- [[ Jobs stuff ]]
    ESX.RegisterServerCallback("esx_job_creator:getJobsData", function(playerId, cb, data)
        if(isAllowed(playerId)) then
            retrieveJobsData(cb)
        end
    end)

    ESX.RegisterServerCallback("esx_job_creator:createNewJob", function(playerId, cb, jobName, jobLabel)
        if(isAllowed(playerId)) then
            createJob(jobName, jobLabel, cb)
        end
    end)

    ESX.RegisterServerCallback("esx_job_creator:deleteJob", function(playerId, cb, jobName)
        if(isAllowed(playerId)) then
            deleteJob(jobName, cb)
        end
    end)

    ESX.RegisterServerCallback("esx_job_creator:getJobInfo", function(playerId, cb)
        local xPlayer = ESX.GetPlayerFromId(playerId)
        cb(xPlayer.job.name, xPlayer.job.label)
    end)

    -- [[ Ranks stuff ]]
    ESX.RegisterServerCallback("esx_job_creator:newRank", function(playerId, cb, jobName)
        if(isAllowed(playerId)) then
            newRank(jobName, cb)
        end
    end)    

    ESX.RegisterServerCallback("esx_job_creator:checkAllowedActions", function(playerId, cb)
        local xPlayer = ESX.GetPlayerFromId(playerId)
        
        while not xPlayer do
            Citizen.Wait(2000)
            xPlayer = ESX.GetPlayerFromId(playerId)
        end

        local jobName = xPlayer.job.name

        checkAllowedActions(jobName, cb)
    end)
    -- [[ Markers stuff ]]

    -- Return all player's job markers
    ESX.RegisterServerCallback("esx_job_creator:getMarkers", function(playerId, cb)
        local xPlayer = ESX.GetPlayerFromId(playerId)

        while xPlayer == nil do
            xPlayer = ESX.GetPlayerFromId(playerId)
            Citizen.Wait(500)
        end

        local jobName = xPlayer.job.name
        local jobGrade = xPlayer.job.grade

        getMarkersMinGrade(jobName, jobGrade, cb)
    end)

    ESX.RegisterServerCallback("esx_job_creator:createMarker", function(playerId, cb, jobName, label, type, coords, minGrade)
        if(isAllowed(playerId)) then
            createNewMarker(jobName, label, type, coords, minGrade, cb)
        end
    end)

    -- Return all markers related to a job
    ESX.RegisterServerCallback("esx_job_creator:getMarkersFromJobName", function(playerId, cb, jobName)
        if(isAllowed(playerId)) then
            local jobMarkers = getMarkersFromJobName(jobName)

            cb(jobMarkers)
        end
    end)

    ESX.RegisterServerCallback("esx_job_creator:deleteMarker", function(playerId, cb, markerId)
        if(isAllowed(playerId)) then
            deleteMarker(markerId, cb)
        end
    end)

    ESX.RegisterServerCallback("esx_job_creator:updateMarker", updateMarker)

    ESX.RegisterServerCallback("esx_job_creator:updateMarkerData", function(playerId, cb, markerId, data)
        if(isAllowed(playerId)) then
            updateMarkerData(markerId, data, cb)
        end
    end)

    -- [[ Stash stuff ]]
    ESX.RegisterServerCallback("esx_job_creator:retrieveStash", function(playerId, cb, markerId)
        if(not canUseMarkerWithLog(playerId, markerId)) then return end

        local xPlayer = ESX.GetPlayerFromId(playerId)

        local stashItems = fullMarkerData[markerId].data
        local elements = {}

        for itemName, itemQuantity in pairs(stashItems) do
            local label = format("%s - x%d", ESX.GetItemLabel(itemName), itemQuantity)
            table.insert(elements, {label = label, value = itemName, quantity = itemQuantity})
        end

        cb(elements)
    end)

    ESX.RegisterServerCallback("esx_job_creator:getPlayerInventory", function(playerId, cb)
        local xPlayer = ESX.GetPlayerFromId(playerId)

        local elements = {}

        for itemName, itemQuantity in pairs(xPlayer.getInventory(true)) do
            local itemLabel = ESX.GetItemLabel(itemName)

            -- If old ESX version, the minimal inventory it's not working, and itemQuantity is a table containing all infos
            if(type(itemQuantity) == "table") then
                itemName = itemQuantity.name
                itemLabel = itemQuantity.label
                itemQuantity = itemQuantity.count
            end

            if(itemQuantity > 0) then
                local label = format("%s - x%d", itemLabel, itemQuantity)
                table.insert(elements, {label = label, value = itemName, quantity = itemQuantity})
            end
        end

        cb(elements)
    end)

    ESX.RegisterServerCallback("esx_job_creator:stash:depositItem", depositItem)

    ESX.RegisterServerCallback("esx_job_creator:stash:takeItem", takeItem)
    
    ESX.RegisterServerCallback("esx_job_creator:deleteStashInventory", function(playerId, cb, markerId)
        if(isAllowed(playerId)) then
            deleteStashInventory(markerId, cb)
        else
            cb(false)
        end
    end)

    -- [[ Armory Stuff ]]
    ESX.RegisterServerCallback('esx_job_creator:getPlayerWeapons', getPlayerWeapons)

    ESX.RegisterServerCallback('esx_job_creator:retrieveArmoryWeapons', retrieveArmoryWeapons)

    ESX.RegisterServerCallback('esx_job_creator:depositWeaponInArmory', depositWeaponInArmory)

    ESX.RegisterServerCallback('esx_job_creator:takeWeaponFromArmory', takeWeaponFromArmory)

    ESX.RegisterServerCallback('esx_job_creator:deleteArmoryInventory', deleteArmoryInventory)

    -- [[ Garage stuff ]]
    ESX.RegisterServerCallback("esx_job_creator:retrieveVehicles", retrieveVehicles)

    -- [[ Boss stuff ]]
    ESX.RegisterServerCallback("esx_job_creator:getBossData", getBossData)
    ESX.RegisterServerCallback('esx_job_creator:boss:getJobGrades', getJobGradesSalaries)
    ESX.RegisterServerCallback('esx_job_creator:boss:getEmployeesList', getEmployeesList)
    ESX.RegisterServerCallback('esx_job_creator:boss:getClosePlayersNames', getClosePlayersNames)
    
    -- [[ Wardrobe stuff ]]
    ESX.RegisterServerCallback('esx_job_creator:getPlayerWardrobe', getPlayerWardrobe)

    ESX.RegisterServerCallback('esx_job_creator:getPlayerOutfit', getPlayerOutfit)
    
    -- [[ Shop stuff ]]
    ESX.RegisterServerCallback('esx_job_creator:getShopData', getShopData)

    -- [[ Garage Buyable stuff ]]
    ESX.RegisterServerCallback('esx_job_creator:getGarageBuyableData', getGarageBuyableData)
    ESX.RegisterServerCallback('esx_job_creator:getGarageOwnedVehicles', getGarageOwnedVehicles)
    ESX.RegisterServerCallback('esx_job_creator:permanent_garage:updateVehicleProps', updateVehicleProps)

    -- [[ Garage owned stuff ]]
    ESX.RegisterServerCallback("esx_job_creator:garage_owned:getVehicles", getPlayerOwnedVehicles)
    ESX.RegisterServerCallback("esx_job_creator:garage_owned:updateVehicleProps", garageOwnedUpdateVehicleProps)

    -- [[ Crafting table stuff ]]
    ESX.RegisterServerCallback('esx_job_creator:getCraftingTableData', getCraftingTableData)

    -- [[ Job outfit stuff ]]
    ESX.RegisterServerCallback('esx_job_creator:getJobOutfits', getJobOutfits)

    --[[ Ranks Stuff ]] 
    ESX.RegisterServerCallback("esx_job_creator:createRank", createRank)
    ESX.RegisterServerCallback("esx_job_creator:updateRank", updateRank)
    ESX.RegisterServerCallback("esx_job_creator:deleteRank", deleteRank)
    ESX.RegisterServerCallback("esx_job_creator:retrieveJobRanks", function(playerId, cb, jobName)
        if(jobName) then
            retrieveJobRanks(jobName, cb)
        else
            cb(false)
        end
    end)

    --[[ Jobs Stuff ]] 
    ESX.RegisterServerCallback("esx_job_creator:updateJob", function(playerId, cb, oldJobName, newJobName, newLabel, whitelisted, actions)
        if(isAllowed(playerId)) then
            updateJob(oldJobName, newJobName, newLabel, whitelisted, actions, cb)
        end
    end)

    -- [[ Actions Menu ]]
    ESX.RegisterServerCallback("esx_job_creator:getTargetPlayerInventory", getTargetPlayerInventory)

    ESX.RegisterServerCallback("esx_job_creator:stealFromPlayer", stealFromPlayer)

    ESX.RegisterServerCallback('esx_job_creator:canLockpickVehicle', canLockpickVehicle)
    ESX.RegisterServerCallback('esx_job_creator:canRepairVehicle', canRepairVehicle)
    ESX.RegisterServerCallback('esx_job_creator:canWashVehicle', canWashVehicle)

    -- [[ Teleport ]]
    ESX.RegisterServerCallback("esx_job_creator:getTeleportCoords", getTeleportCoords)
    ESX.RegisterServerCallback("esx_job_creator:getMarkerLabel", getMarkerLabel)

    -- [[ Safe ]]
    ESX.RegisterServerCallback('esx_job_creator:getPlayerAccounts', getPlayerSafeAccounts)
    ESX.RegisterServerCallback('esx_job_creator:depositIntoSafe', depositIntoSafe)
    ESX.RegisterServerCallback('esx_job_creator:withdrawFromSafe', withdrawFromSafe)
    ESX.RegisterServerCallback('esx_job_creator:retrieveReadableSafeData', retrieveReadableSafeData)

    -- [[ Market ]]
    ESX.RegisterServerCallback('esx_job_creator:getMarketItems', getMarketItems)

    -- [[ Weapon Upgrader ]]
    ESX.RegisterServerCallback('esx_job_creator:openComponents', openComponents)
    ESX.RegisterServerCallback('esx_job_creator:openTints', openTints)
    ESX.RegisterServerCallback('esx_job_creator:getOwnedWeapons', getOwnedWeapons)

    -- [[ Job Shop ]]
    ESX.RegisterServerCallback('esx_job_creator:getSellableStuff', getSellableStuff)
    
    ESX.RegisterServerCallback('esx_job_creator:canSellInThisShop', function(playerId, cb, markerId)
        cb(canPlayerSellInShop(playerId, markerId))
    end)

    ESX.RegisterServerCallback('esx_job_creator:getJobShop', getJobShop)
end