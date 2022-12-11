local function openComponents(markerId, weaponName)
    ESX.TriggerServerCallback('esx_job_creator:openComponents', function(components) 
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapon_upgrader_components', {
            title = getLocalizedText('weapon_upgrader'),
            align = 'bottom-right',
            elements = components
        },
        function(data, menu)
            local componentName = data.current.value

            TriggerServerEvent('esx_job_creator:buyWeaponComponent', markerId, weaponName, componentName)

            menu.close()
        end,
        function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end, markerId, weaponName)
end

local function openTints(markerId, weaponName)
    ESX.TriggerServerCallback('esx_job_creator:openTints', function(tints) 
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapon_upgrader_tints', {
            title = getLocalizedText('weapon_upgrader'),
            align = 'bottom-right',
            elements = tints
        },
        function(data, menu)
            local tintId = data.current.value

            TriggerServerEvent('esx_job_creator:buyWeaponTint', markerId, weaponName, tintId)

            menu.close()
        end,
        function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end, markerId, weaponName)
end

local function openWeaponUpgrader(markerId, weaponName)
    local elements = {
        {label = getLocalizedText('components'), value = "components"},
        {label = getLocalizedText('tints'), value = "tints"},
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapon_upgrader', {
        title = getLocalizedText('weapon_upgrader'),
        align = 'bottom-right',
        elements = elements
    },
    function(data, menu)
        local action = data.current.value

        if(action == "components") then
            openComponents(markerId, weaponName)
        elseif(action == "tints") then
            openTints(markerId, weaponName)
        end
    end,
    function(data, menu)
        openedMenu = nil
        menu.close()
    end)
end

function openOwnedWeapons(markerId)
    ESX.UI.Menu.CloseAll()
    
    ESX.TriggerServerCallback('esx_job_creator:getOwnedWeapons', function(weapons)
        local elements = {}

        for k, weapon in pairs(weapons) do
            table.insert(elements, {
                label = weapon.label,
                value = weapon.name
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'weapon_upgrader_owned_weapons', {
            title = getLocalizedText('weapon_upgrader'),
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            local weaponName = data.current.value
    
            if(weaponName) then
                openWeaponUpgrader(markerId, weaponName)
            end
        end,
        function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end)
end