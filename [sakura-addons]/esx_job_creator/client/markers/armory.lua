local function depositWeaponInArmory(markerId)
    ESX.TriggerServerCallback('esx_job_creator:getPlayerWeapons', function(weapons) 
        local elements = {}

        if(#weapons > 0) then
            for weaponId, weapon in pairs(weapons) do
                table.insert(elements, {label = getLocalizedText('weapon', weapon.label, weapon.ammo), value = weapon.name})
            end
        else
            table.insert(elements, {label = getLocalizedText('not_have_any_weapon'), value = "invalid"})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_deposit', {
            title = getLocalizedText('armory_deposit'),
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            local weaponName = data.current.value

            if(weaponName ~= "invalid") then
                ESX.TriggerServerCallback('esx_job_creator:depositWeaponInArmory', function(isSuccessful) 
                    if(isSuccessful) then
                        depositWeaponInArmory(markerId)
                    end
                end, markerId, weaponName)
            end
        end,
        function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end)
end

local function takeWeaponFromArmory(markerId)
    ESX.TriggerServerCallback('esx_job_creator:retrieveArmoryWeapons', function(weapons) 
        local elements = {}
        
        for k, weapon in pairs(weapons) do
            table.insert(elements, {label = getLocalizedText('weapon', ESX.GetWeaponLabel(weapon.weapon), weapon.ammo), value = weapon.id})
        end

        if(#elements == 0) then
            table.insert(elements, {label = getLocalizedText('no_weapons_in_armory'), value = "invalid"})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory_take', {
            title = getLocalizedText('armory_take'),
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            local weaponId = data.current.value

            ESX.TriggerServerCallback('esx_job_creator:takeWeaponFromArmory', function(isSuccessful)
                if(isSuccessful) then
                    takeWeaponFromArmory(markerId)
                end
            end, markerId, weaponId)
        end,
        function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end, markerId)
end

function openArmory(markerId)
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
        title = getLocalizedText('armory'),
        align = 'bottom-right',
        elements = {
            {label = getLocalizedText("deposit_weapon"), value = "deposit"},
            {label = getLocalizedText("take_weapon"), value = "take"},
        }
    },
    function(data, menu)
        local action = data.current.value

        if(action == "deposit") then
            depositWeaponInArmory(markerId)
        elseif(action == "take") then
            takeWeaponFromArmory(markerId)
        end
    end,
    function(data, menu)
        openedMenu = nil
        menu.close()
    end)
end