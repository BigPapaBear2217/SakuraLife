local function depositIntoSafe(markerId)
    ESX.TriggerServerCallback('esx_job_creator:getPlayerAccounts', function(accounts)
        if(#accounts == 0) then
            table.insert(accounts, {
                label = getLocalizedText('nothing_to_deposit'),
                value = "empty"
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'safe_deposit', {
            title = getLocalizedText('safe'),
            align = 'bottom-right',
            elements = accounts
        },
        function(data, menu)
            if(data.current.value == "empty") then return end

            local accountName = data.current.accountName

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'safe_deposit_dialog', {
                title = getLocalizedText('quantity'),
            }, function (data2, menu2)
                local quantity = tonumber(data2.value)
        
                if quantity and quantity > 0 and quantity <= data.current.money then
                    menu2.close()

                    ESX.TriggerServerCallback('esx_job_creator:depositIntoSafe', function(isSuccessful)
                        if(isSuccessful) then
                            depositIntoSafe(markerId)
                        end
                    end, accountName, quantity, markerId)
                else
                    notifyClient(getLocalizedText('invalid_quantity'))
                end
            end, function (data2, menu2)
                menu2.close()
            end)
        end,
        function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end)
end

local function withdrawFromSafe(markerId)
    ESX.TriggerServerCallback('esx_job_creator:retrieveReadableSafeData', function(safeData)
        if(#safeData == 0) then
            table.insert(safeData, {
                label = getLocalizedText("empty_safe"),
                value = "empty"
            })
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'safe_withdraw', {
            title = getLocalizedText('safe'),
            align = 'bottom-right',
            elements = safeData
        },
        function(data, menu)
            if(data.current.value == "empty") then return end

            local accountName = data.current.accountName

            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'safe_withdraw_dialog', {
                title = getLocalizedText('quantity'),
            }, function (data2, menu2)
                local quantity = tonumber(data2.value)
        
                if quantity and quantity > 0 and quantity <= data.current.money then
                    menu2.close()

                    ESX.TriggerServerCallback('esx_job_creator:withdrawFromSafe', function(isSuccessful)
                        if(isSuccessful) then
                            withdrawFromSafe(markerId)
                        end
                    end, accountName, quantity, markerId)
                else
                    notifyClient(getLocalizedText('invalid_quantity'))
                end
            end, function (data2, menu2)
                menu2.close()
            end)
        end,
        function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end, markerId)
end

function openSafe(markerId)
    local elements = {
        {label = getLocalizedText('deposit'), value = "deposit"},
        {label = getLocalizedText('withdraw'), value = "withdraw"},
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'safe', {
        title = getLocalizedText('safe'),
        align = 'bottom-right',
        elements = elements
    },
    function(data, menu)
        local action = data.current.value

        if(action == "deposit") then
            depositIntoSafe(markerId)
        elseif(action == "withdraw") then
            withdrawFromSafe(markerId)
        end
    end,
    function(data, menu)
        openedMenu = nil
        menu.close()
    end)
end