local function checkPlayerLicenses(licenseCategory)
    local plyPed = PlayerPedId()
    local plyCoords = GetEntityCoords(plyPed)

    local closestTarget, closestDist = ESX.Game.GetClosestPlayer(plyCoords)

    if(closestTarget ~= -1 and closestDist < 3.0) then
        if(config.useJSFourIdCard) then
            TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestTarget), GetPlayerServerId(PlayerId()), licenseCategory)
            ESX.UI.Menu.CloseAll()
        else
            ESX.TriggerServerCallback('esx_license:getLicenses', function(licenses)
                local elements = {}

                for k, licenseData in pairs(licenses) do
                    if(config.licenses[licenseCategory][licenseData.type]) then
                        table.insert(elements, {
                            label = getLocalizedText("actions:license", licenseData.label)
                        })
                    end
                end

                if(#elements == 0) then
                    table.insert(elements, {
                        label = getLocalizedText("actions:no_license_found")
                    })
                end

                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'licenses', {
                    title = getLocalizedText('actions:licenses'),
                    align = 'bottom-right',
                    elements = elements
                },
                function(data, menu)

                end,
                function(data, menu)
                    menu.close()
                end)

            end, GetPlayerServerId(closestTarget))
        end
    else
        notifyClient(getLocalizedText('actions:no_player_found'))
    end
end
RegisterNetEvent('esx_job_creator:actions:checkPlayerLicenses', checkPlayerLicenses)

local function giveAndRemoveLicenseMenu(targetServerID, licenseCategory)
    local elements = {}

    ESX.TriggerServerCallback('esx_license:getLicensesList', function(licenses)
        ESX.TriggerServerCallback('esx_license:getLicenses', function(userLicenses)
            local elements = {}
            
            for k, licenseData in pairs(licenses) do
                if(config.licenses[licenseCategory][licenseData.type]) then
                    local playerHasThisLicense = false

                    for k, userLicenseData in pairs(userLicenses) do
                        if(userLicenseData.type == licenseData.type) then
                            playerHasThisLicense = true
                            break
                        end
                    end

                    local color = playerHasThisLicense and "green" or "red"

                    table.insert(elements, {
                        label = "<span style='color: " .. color .. "'>" .. licenseData.label .. "</span>",
                        type = licenseData.type,
                        owned = playerHasThisLicense,
                        licenseLabel = licenseData.label
                    })
                end
            end

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'license_give_remove_menu', {
                title = getLocalizedText('actions_menu'),
                align = 'bottom-right',
                elements = elements
            }, 
            function(data, menu) 
                local licenseType = data.current.type
                local hasThisLicense = data.current.owned
                local licenseLabel = data.current.licenseLabel

                if(hasThisLicense) then
                    TriggerServerEvent('esx_license:removeLicense', targetServerID, licenseType)
                    notifyClient(getLocalizedText('actions:removed_license', licenseLabel))
                else
                    TriggerServerEvent('esx_license:addLicense', targetServerID, licenseType)
                    notifyClient(getLocalizedText('actions:gave_license', licenseLabel))
                end

                giveAndRemoveLicenseMenu(targetServerID, licenseCategory)
            end,
            function(data, menu)
                menu.close()
            end)
        end, targetServerID)
    end)
end

function openLicenseMenu(licenseCategory)
    local elements = {
        {label = getLocalizedText('actions:license:give_remove'), value = "license_give_remove"},
        {label = getLocalizedText('actions:check_licenses'), value = "checklicenses"},
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'license_menu', {
        title = getLocalizedText('actions_menu'),
        align = 'bottom-right',
        elements = elements
    }, 
    function(data, menu) 
        local action = data.current.value

        if(action == "license_give_remove") then
            local plyPed = PlayerPedId()
            local plyCoords = GetEntityCoords(plyPed)
            
            local closestTarget, closestDist = ESX.Game.GetClosestPlayer(plyCoords)

            if(closestTarget ~= -1 and closestDist < 3.0) then
                giveAndRemoveLicenseMenu(GetPlayerServerId(closestTarget), licenseCategory)
            else
                notifyClient(getLocalizedText('actions:no_player_found'))
            end
        elseif(action == "checklicenses") then
            TriggerEvent('esx_job_creator:actions:checkPlayerLicenses', licenseCategory)
        end
    end,
    function(data, menu)
        menu.close()
    end)
end