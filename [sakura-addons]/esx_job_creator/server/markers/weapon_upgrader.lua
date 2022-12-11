local TINTS_LABELS = {
    [0] = getLocalizedText('tint_default'),
	[1] = getLocalizedText('tint_green'),
	[2] = getLocalizedText('tint_gold'),
	[3] = getLocalizedText('tint_pink'),
	[4] = getLocalizedText('tint_army'),
	[5] = getLocalizedText('tint_lspd'),
	[6] = getLocalizedText('tint_orange'),
	[7] = getLocalizedText('tint_platinum')
}

function openComponents(playerId, cb, markerId, weaponName)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    local weaponUpgraderData = fullMarkerData[markerId].data or {}
    
    local components = {}

    local loadoutNum, weapon = xPlayer.getWeapon(weaponName)

    for componentName, componentPrice in pairs(weaponUpgraderData.componentsPrices) do
        local componentData = ESX.GetWeaponComponent(weapon.name, componentName)
        
        if(componentData) then
            local hasThisComponent = false

            for k, weaponComponentName in pairs(weapon.components) do
                if(weaponComponentName == componentName) then
                    hasThisComponent = true
                    break
                end
            end

            if(hasThisComponent) then
                table.insert(components, {
                    label = getLocalizedText('owned_component', componentData.label),
                    value = componentName,
                })
            else
                table.insert(components, {
                    label = getLocalizedText('buy_component', componentData.label, ESX.Math.GroupDigits(componentPrice)),
                    value = componentName,
                })
            end
        end
    end

    cb(components)
end

function openTints(playerId, cb, markerId, weaponName)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    
    local weaponUpgraderData = fullMarkerData[markerId].data or {}
    local tints = {}

    local loadoutNum, weapon = xPlayer.getWeapon(weaponName)
    
    for tintId, tintPrice in pairs(weaponUpgraderData.tintsPrices) do
        local tintId = tonumber(tintId)

        if(tintId == weapon.tintIndex) then
            table.insert(tints, {
                label = getLocalizedText("owned_component", TINTS_LABELS[tintId]),
                value = tintId,
            })
        else
            table.insert(tints, {
                label = getLocalizedText("buy_component", TINTS_LABELS[tintId], ESX.Math.GroupDigits(tintPrice)),
                value = tintId,
            })
        end
    end

    cb(tints)
end

function getOwnedWeapons(playerId, cb)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    cb(xPlayer.getLoadout())
end

RegisterNetEvent('esx_job_creator:buyWeaponTint')
AddEventHandler('esx_job_creator:buyWeaponTint', function(markerId, weaponName, tintId)    
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    -- Older ESX version will not use this event
    if(not xPlayer.setWeaponTint) then return end

    local loadoutNum, weapon = xPlayer.getWeapon(weaponName)

    if(weapon.tintIndex == tintId) then
        notify(playerId, getLocalizedText('already_have_tint'))
    else
        local tintPrice = fullMarkerData[markerId].data.tintsPrices[tostring(tintId)]

        if(payInSomeWay(playerId, tonumber(tintPrice))) then
            xPlayer.setWeaponTint(weaponName, tintId)

            notify(playerId, getLocalizedText('bought_tint', TINTS_LABELS[tintId], weapon.label))

            log(playerId, 
                getLocalizedText('log_bought_tint'),
                getLocalizedText('log_bought_tint_description', 
                    weapon.label,
                    TINTS_LABELS[tintId],
                    tintPrice,
                    markerId
                ),
                'success',
                'weapon_upgrader'
            )
        else
            notify(playerId, getLocalizedText('not_enough_money'))
        end
    end
end)

RegisterNetEvent('esx_job_creator:buyWeaponComponent')
AddEventHandler('esx_job_creator:buyWeaponComponent', function(markerId, weaponName, componentName)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    
    local loadoutNum, weapon = xPlayer.getWeapon(weaponName)

    if(not weapon) then return end

    local alreadyHasComponent = false

    for k, weaponcomponentName in pairs(weapon.components) do
        if(weaponcomponentName == componentName) then
            alreadyHasComponent = true
            break
        end
    end

    local componentLabel = ESX.GetWeaponComponent(weaponName, componentName).label

    if(alreadyHasComponent) then
        xPlayer.removeWeaponComponent(weaponName, componentName)
        notify(playerId, getLocalizedText('removed_component', componentLabel, weapon.label))

        log(playerId, 
            getLocalizedText('log_removed_component'),
            getLocalizedText('log_removed_component_description', 
                componentLabel,
                weapon.label,
                markerId
            ),
            'success',
            'weapon_upgrader'
        )
    else
        local componentPrice = tonumber(fullMarkerData[markerId].data.componentsPrices[componentName])

        if(payInSomeWay(playerId, componentPrice)) then
            xPlayer.addWeaponComponent(weaponName, componentName)
            notify(playerId, getLocalizedText('bought_component', componentLabel, weapon.label))

            log(playerId, 
                getLocalizedText('log_bought_component'),
                getLocalizedText('log_bought_component_description',
                    componentLabel,
                    weapon.label,
                    markerId
                ),
                'success',
                'weapon_upgrader'
            )
        else
            notify(playerId, getLocalizedText('not_enough_money'))
        end
    end
end)