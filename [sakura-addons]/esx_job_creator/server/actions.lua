function canLockpickVehicle(playerId, cb)
    if (config.lockpickCarRequireItem) then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local lockpickItem = xPlayer.getInventoryItem(config.lockpickItemName)

        if (lockpickItem and lockpickItem.count >= 1) then
            cb(true)

            if (config.lockpickRemoveOnUse) then
                xPlayer.removeInventoryItem(config.lockpickItemName, 1)
                notify(playerId, getLocalizedText('lockpick_used'))
            end
        else
            cb(false)
        end
    else
        cb(true)
    end
end

function getTargetPlayerInventory(playerId, cb, targetId)
    local xPlayer = ESX.GetPlayerFromId(targetId)

    if (xPlayer) then

        notify(xPlayer.source, getLocalizedText("actions_menu_being_searched"))

        local fullInventory = {}

        local inventory = xPlayer.getInventory()
        local weapons = xPlayer.getLoadout()

        local accounts = config.robbableAccounts or {}

        if (inventory) then
            for k, item in pairs(inventory) do
                local itemCount = item.count

                if (itemCount) > 0 then
                    local label = "x%d %s"

                    table.insert(fullInventory, {
                        label = format(label, itemCount, item.label),
                        itemType = "ITEM_STANDARD",
                        value = item.name,
                        max = item.count
                    })
                end
            end
        end

        for k, accountName in pairs(accounts) do
            local account = xPlayer.getAccount(accountName)

            if account then
                local accountMoney = account.money

                if (accountMoney > 0) then
                    local label = "$%s %s"

                    table.insert(fullInventory, {
                        label = format(label, ESX.Math.GroupDigits(accountMoney), account.label),
                        itemType = "ITEM_ACCOUNT",
                        value = account.name,
                        max = accountMoney
                    })
                end
            end
        end

        if (weapons) then
            for k, weapon in pairs(weapons) do
                table.insert(fullInventory, {
                    label = getLocalizedText('weapon', weapon.label, weapon.ammo),
                    itemType = "ITEM_WEAPON",
                    value = weapon.name
                })
            end
        end

        cb(fullInventory)
    end
end

function stealFromPlayer(playerId, cb, targetId, itemData, quantity)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if (xPlayer and xTarget and arePlayersClose(playerId, targetId, 2.0)) then
        if (itemData.itemType == "ITEM_STANDARD") then
            local item = xTarget.getInventoryItem(itemData.value)

            if (item.count >= quantity) then
                xTarget.removeInventoryItem(item.name, quantity)
                xPlayer.addInventoryItem(item.name, quantity)

                notify(xPlayer.source, getLocalizedText("actions_menu_search_took", quantity, item.label))
                notify(xTarget.source, getLocalizedText("actions_menu_search_stolen", quantity, item.label))
                cb(true)
            else
                notify(xPlayer.source, getLocalizedText("invalid_quantity"))
                cb(false)
            end
        elseif (itemData.itemType == "ITEM_ACCOUNT") then
            local account = xTarget.getAccount(itemData.value)

            if (account.money >= quantity) then
                xTarget.removeAccountMoney(itemData.value, quantity)
                xPlayer.addAccountMoney(itemData.value, quantity)

                notify(xPlayer.source, getLocalizedText("actions_menu_search_took_money", quantity, account.label))
                notify(xTarget.source, getLocalizedText("actions_menu_search_stolen_money", quantity, account.label))
                cb(true)
            else
                notify(xPlayer.source, getLocalizedText("invalid_quantity"))
                cb(false)
            end
        elseif (itemData.itemType == "ITEM_WEAPON") then
            if (xTarget.hasWeapon(itemData.value)) then
                local loadoutNum, weapon = xTarget.getWeapon(itemData.value)

                if (weapon) then
                    local weaponName = weapon.name
                    local weaponLabel = weapon.label
                    local weaponAmmo = weapon.ammo

                    xTarget.removeWeapon(weaponName)

                    xPlayer.addWeapon(weaponName, weaponAmmo)

                    for k, componentName in pairs(weapon.components) do
                        xPlayer.addWeaponComponent(weaponName, componentName)
                    end

                    notify(xPlayer.source, getLocalizedText("actions_menu_search_took_weapon", weaponLabel, weaponAmmo))
                    notify(xTarget.source,
                        getLocalizedText("actions_menu_search_stolen_weapon", weaponLabel, weaponAmmo))
                    cb(true)
                else
                    cb(false)
                end
            else
                notify(xPlayer.source, getLocalizedText("actions_menu_search_doesnt_have_weapon"))
                cb(false)
            end
        else
            cb(false)
        end
    else
        cb(false)
    end
end

RegisterNetEvent('esx_job_creator:handcuffPlayer')
AddEventHandler('esx_job_creator:handcuffPlayer', function(targetId)
    local playerId = source

    if (arePlayersClose(playerId, targetId, 2.0)) then
        if (config.handcuffRequireItem) then
            local xPlayer = ESX.GetPlayerFromId(playerId)

            local item = xPlayer.getInventoryItem(config.handcuffsItemName)

            if (xPlayer and item and item.count > 0) then
                TriggerClientEvent('esx_job_creator:arrestConfirmed', playerId, targetId)
            else
                notify(playerId, getLocalizedText("you_need_handcuffs"))
            end
        else
            TriggerClientEvent('esx_job_creator:arrestConfirmed', playerId, targetId)
        end
    end
end)

RegisterNetEvent('esx_job_creator:handcuffTarget')
AddEventHandler('esx_job_creator:handcuffTarget', function(targetId)
    TriggerClientEvent('esx_job_creator:handcuffPlayer', targetId)
end)

RegisterNetEvent('esx_job_creator:dragTarget')
AddEventHandler('esx_job_creator:dragTarget', function(targetId)
    local playerId = source

    TriggerClientEvent('esx_job_creator:dragTarget', targetId, playerId)
end)

RegisterNetEvent('esx_job_creator:putincar')
AddEventHandler('esx_job_creator:putincar', function(targetId, vehNetId)
    local playerId = source

    TriggerClientEvent('esx_job_creator:putincar', targetId, vehNetId)
end)

RegisterNetEvent('esx_job_creator:takefromcar')
AddEventHandler('esx_job_creator:takefromcar', function(targetId)
    local playerId = source

    TriggerClientEvent('esx_job_creator:takefromcar', targetId)
end)

function canRepairVehicle(playerId, cb)
    if (config.repairVehicleRequireItem) then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local fixkitItem = xPlayer.getInventoryItem(config.repairVehicleItemName)

        if (fixkitItem and fixkitItem.count >= 1) then
            cb(true)

            if (config.repairVehicleRemoveOnUse) then
                xPlayer.removeInventoryItem(config.repairVehicleItemName, 1)
            end
        else
            notify(playerId, getLocalizedText('actions:you_need', ESX.GetItemLabel(config.repairVehicleItemName)))
            cb(false)
        end
    else
        cb(true)
    end
end

function canWashVehicle(playerId, cb)
    if (config.washVehicleRequireItem) then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local spongeItem = xPlayer.getInventoryItem(config.washVehicleItemName)

        if (spongeItem and spongeItem.count >= 1) then
            cb(true)

            if (config.washVehicleRemoveOnUse) then
                xPlayer.removeInventoryItem(config.washVehicleItemName, 1)
            end
        else
            notify(playerId, getLocalizedText('actions:you_need', ESX.GetItemLabel(config.washVehicleItemName)))
            cb(false)
        end
    else
        cb(true)
    end
end

local function getOwnerFromGaragesMarker(plate, cb)
    MySQL.Async.fetchScalar("SELECT identifier FROM jobs_garages WHERE plate=@plate", {
        ["@plate"] = plate
    }, function(identifier)
        cb(identifier)
    end)
end

local function getVehicleOwnerFromPlate(plate, cb)
    -- Checks in owned_vehicles and in garage markers
    MySQL.Async.fetchScalar("SELECT owner FROM owned_vehicles WHERE plate=@plate", {
        ["@plate"] = plate
    }, function(identifier)
        if(identifier) then
            cb(identifier)
        else
            getOwnerFromGaragesMarker(plate, cb)
        end
    end)
end

local function getPlayerNameFromIdentifier(identifier, cb)
    MySQL.Async.fetchAll("SELECT firstname, lastname FROM users WHERE identifier=@identifier", {
        ["@identifier"] = identifier
    }, function(results)
        if(results[1]) then
            local fullName = results[1].firstname .. " " .. results[1].lastname
            
            cb(fullName)
        else
            cb(false)
        end
    end)
end

local function getVehicleOwner(plate)
    local playerId = source

    getVehicleOwnerFromPlate(plate, function(identifier)
        if(identifier) then
            getPlayerNameFromIdentifier(identifier, function(fullName)
                notify(playerId, getLocalizedText('actions:checkVehicleOwner:owner', fullName))
            end)
        else
            notify(playerId, getLocalizedText('actions:checkVehicleOwner:owner_not_found'))
        end
    end)
end
RegisterNetEvent('esx_job_creator:actions:getVehicleOwner', getVehicleOwner)

local function checkIdentity(targetId)
    local playerId = source

    local targetPlayer = ESX.GetPlayerFromId(targetId)

    local fullName = targetPlayer.getName()

    notify(playerId, getLocalizedText("actions:checkIdentity:player_found", fullName))
    notify(targetId, getLocalizedText("actions:checkIdentity:somebody_checked_your_id", fullName))
end
RegisterNetEvent('esx_job_creator:actions:checkIdentity', checkIdentity)