

RegisterNetEvent('ot-notify:notify')
AddEventHandler('ot-notify:notify', function(color, title, message)
    SendNUIMessage({
        type = "custom",
        color = "#db2a91",
		title = title,
        message = message,
    })
end)

AddEventHandler('hud:range', function(voiceRange)
    TriggerEvent('ot-notify:notify', "", "SaltyChat", "Sprachreichweite: " .. tostring(voiceRange):gsub('.0', '') .. " Meter")
end)

AddEventHandler('hud:range', function(voiceRange)
    TriggerEvent('ot-notify:notify', "", "SaltyChat", "Sprachreichweite: " .. tostring(voiceRange):gsub('.0', '') .. " Meter")
end)

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do 
        Citizen.Wait(1)
        TriggerEvent('esx:getSharedObject', function(object) ESX = object end)
    end

    while true do 
        Citizen.Wait(0)
        
        if GetDistanceBetweenCoords(vector3(253.92, 222.49, 106.29), GetEntityCoords(GetPlayerPed(PlayerPedId())), false) < 5 then
            ESX.ShowHelpNotification('Drücke ~INPUT_CONTEXT~ um mit Tom zu interagieren')
        end
    end
end)