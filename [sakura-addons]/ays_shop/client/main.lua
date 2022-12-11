ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(AYS.esxgetSharedObjectevent, function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNUICallback('escape', function(data, cb)
    SetNuiFocus(false,false)
end)

function visible(data, bool)
    SendNUIMessage({
        action = "setdata",
        data = json.encode(data)
    })
    SendNUIMessage({
        action = "show",
        state = bool
    })
    SetNuiFocus(bool, bool)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local pos = GetEntityCoords(PlayerPedId())

        for k,v in pairs(AYS.shops) do
            local dist = GetDistanceBetweenCoords(v.location, pos.x, pos.y, pos.z, true)
            
            if dist <= 2.0 then
                ESX.ShowHelpNotification(AYS.messages[4])
                if IsControlJustPressed(0, 38) then
                    visible(v, true)
                end
            end
        end
    end
end)

RegisterNUICallback('buy', function(data, cb)
    TriggerServerEvent("ays_shop:buy", data.price, data.korb, data.state)
end)

RegisterNetEvent('ays_shop:close')
AddEventHandler('ays_shop:close', function(bool)
    SendNUIMessage({
        action = "show",
        state = bool
    })
    SetNuiFocus(bool, bool)
end)

Citizen.CreateThread(function()
    for k,v in pairs(AYS.shops) do
        local blip = AddBlipForCoord(v.location)

        SetBlipSprite(blip, v.blip.Sprite)
        SetBlipScale(blip, v.blip.Scale)
        SetBlipColour(blip, v.blip.Colour)
        SetBlipDisplay(blip, v.blip.Display)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(v.blip.Name)
        EndTextCommandSetBlipName(blip)
    end
end)