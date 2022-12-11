local function createBilling()
    if(config.useBillingUI) then
        ESX.UI.Menu.CloseAll()
        TriggerEvent('billing_ui:activateBillingMode')
    else
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'create_billing', {
            title = getLocalizedText("billing_reason"),
        }, function(data, menu)
            local billingReason = data.value
    
            if(billingReason) then
                menu.close()
    
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'create_billing', {
                    title = getLocalizedText("billing_amount"),
                }, function(data, menu)
                    local billingAmount = tonumber(data.value)
            
                    if(billingAmount and billingReason) then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                        if closestPlayer == -1 or closestDistance > 4.0 then
                            notifyClient(getLocalizedText('no_players_nearby'))
                        else
                            ESX.TriggerServerCallback('esx_job_creator:getJobInfo', function(jobName, jobLabel)
                                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_' .. jobName, jobLabel .. " - " .. billingReason, billingAmount)
                                notifyClient(getLocalizedText('invoice_sent', ESX.Math.GroupDigits(billingAmount)))
                            end)
                        end
    
                        menu.close()
                    end
                end, function(data, menu)
                    menu.close()
                end)
            end
        end, function(data, menu)
            menu.close()
        end)
    end
end
RegisterNetEvent('esx_job_creator:actions:createBilling', createBilling)