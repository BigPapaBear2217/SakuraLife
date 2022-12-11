-- Key = markerId
local armoryData = {}

local function getAllArmoryWeapons(markerId, cb)
    cb(armoryData[markerId])
end

local function getPlayerArmoryWeapons(playerId, markerId, cb)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local identifier = xPlayer.identifier

    local playerWeapons = {}

    for k, weaponData in pairs(armoryData[markerId]) do
        if(weaponData.identifier == identifier) then
            table.insert(playerWeapons, weaponData)
        end
    end

    cb(playerWeapons)
end

function getAllArmoryData()
    MySQL.Async.fetchAll('SELECT * FROM jobs_armories', {}, 
    function(result)
        for k, weaponData in pairs(result) do
            local markerId = weaponData.marker_id

            if(not armoryData[markerId]) then
                armoryData[markerId] = {}
            end

            armoryData[markerId][weaponData.id] = weaponData
        end
    end)
end

function retrieveArmoryWeapons(playerId, cb, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local isShared = fullMarkerData[markerId].data and fullMarkerData[markerId].data.isShared or nil

    if(armoryData[markerId]) then
        if(isShared) then
            getAllArmoryWeapons(markerId, cb)
        else
            getPlayerArmoryWeapons(playerId, markerId, cb)
        end
    else 
        cb({})
    end
end

function depositWeaponInArmory(playerId, cb, markerId, weaponName)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)

    local loadoutNum, weapon = xPlayer.getWeapon(weaponName)

    if (weapon) then
        local components = json.encode(weapon.components)
        MySQL.Async.insert(
            'INSERT INTO jobs_armories(weapon, components, ammo, tint, marker_id, identifier) VALUES(@weaponName, @weaponComponents, @weaponAmmo, @weaponTint, @markerId, @identifier);',
            {
                ['@markerId'] = markerId,
                ['@weaponName'] = weapon.name,
                ['@weaponAmmo'] = weapon.ammo,
                ['@weaponTint'] = weapon.tintIndex or 0,
                ['@weaponComponents'] = components,
                ['@identifier'] = xPlayer.identifier
            }, function(weaponId)
                if (weaponId > 0) then
                    xPlayer.removeWeapon(weaponName)

                    if(not armoryData[markerId]) then
                        armoryData[markerId] = {}
                    end

                    armoryData[markerId][weaponId] = {
                        weapon = weapon.name,
                        ammo = weapon.ammo,
                        tint = weapon.tintIndex or 0,
                        components = components,
                        identifier = xPlayer.identifier,
                        id = weaponId
                    }

                    notify(xPlayer.source, getLocalizedText("you_deposited_weapon", weapon.label))

                    log(playerId, 
                        getLocalizedText('log_deposited_weapon'),
                        getLocalizedText('log_deposited_weapon_description', 
                            ESX.GetWeaponLabel(weaponName),
                            weaponName, 
                            weapon.ammo, 
                            markerId
                        ),
                        'success',
                        'armory'
                    )
                    cb(true)
                else
                    cb(false)
                end
            end)
    else
        notify(xPlayer.source, getLocalizedText("you_dont_have_weapon"))
    end
end

function takeWeaponFromArmory(playerId, cb, markerId, weaponId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local weapon = armoryData[markerId][weaponId]
    
    if (weapon) then
        local xPlayer = ESX.GetPlayerFromId(playerId)

        local weaponName = weapon.weapon

        if (not xPlayer.hasWeapon(weaponName)) then
            MySQL.Async.execute('DELETE FROM jobs_armories WHERE id=@weaponId', {
                ['@weaponId'] = weaponId
            }, function(affectedRows)
                if (affectedRows > 0) then

                    if(fullMarkerData[markerId].data and fullMarkerData[markerId].data.refillOnTake) then
                        xPlayer.addWeapon(weaponName, 250)
                    else
                        xPlayer.addWeapon(weaponName, weapon.ammo)
                    end

                    if(xPlayer.setWeaponTint) then
                        xPlayer.setWeaponTint(weaponName, weapon.tint)
                    end

                    local components = {}

                    if(weapon.components) then
                        components = json.decode(weapon.components)
                    end

                    if (components) then
                        for k, componentName in pairs(components) do
                            xPlayer.addWeaponComponent(weaponName, componentName)
                        end
                    end

                    log(playerId, 
                        getLocalizedText('log_took_weapon'),
                        
                        getLocalizedText('log_took_weapon_description', 
                            ESX.GetWeaponLabel(weaponName),
                            weaponName, 
                            weapon.ammo, 
                            markerId
                        ),
                        'success',
                        'armory'
                    )

                    notify(xPlayer.source, getLocalizedText("you_took_weapon", ESX.GetWeaponLabel(weaponName)))

                    armoryData[markerId][weaponId] = nil

                    cb(true)
                else
                    cb(false)
                end
            end)
        else
            notify(xPlayer.source, getLocalizedText("you_already_have_that_weapon", ESX.GetWeaponLabel(weaponName)))
        end
    else
        cb(false)
    end
end

function getPlayerWeapons(playerId, cb)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    cb(xPlayer.getLoadout())
end

function deleteArmoryInventory(playerId, cb, markerId)
    if(isAllowed(playerId)) then
        MySQL.Async.execute('DELETE FROM jobs_armories WHERE marker_id=@markerId', {
            ['@markerId'] = markerId
        }, function(affectedRows)
            if (affectedRows > 0) then
                armoryData[markerId] = {}
    
                local cbData = {
                    isSuccessful = true,
                    message = "Successful"
                }
                cb(cbData)
            else
                local cbData = {
                    isSuccessful = false,
                    message = "Couldn't delete armory inventory or it was empty"
                }
                cb(cbData)
            end
        end)
    else
        local cbData = {
            isSuccessful = false,
            message = "Couldn't delete armory inventory (Not allowed)"
        }
        cb(cbData)
    end
end
