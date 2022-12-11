ESX = nil
local open = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent(AYS.esxgetSharedObjectevent, function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function visibile(bool)
    SendNUIMessage({
        action = "show",
        state = bool
    })
    SetNuiFocus(bool,bool)
end

RegisterNUICallback('escape', function(data, cb)
    SetNuiFocus(false,false)
    open = false
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local pos = GetEntityCoords(PlayerPedId())
        local dist = GetDistanceBetweenCoords(AYS.location, pos.x, pos.y, pos.z, true)

        if not open then
            if dist <= 2 then
                DisplayHelpText(AYS.messages[4])
                if IsControlJustPressed(0, 38) then
                    SendNUIMessage({
                        action = "setweapons",
                        data = json.encode(AYS.weapons)
                    })
                    visibile(true)
                    open = true
                end
            end
            if dist <= 50 then
                DrawMarker(AYS.marker.type, AYS.location, 0, 0, 0, 0, 0, 0, AYS.marker.size, AYS.marker.size, AYS.marker.size, AYS.marker.color.red, AYS.marker.color.green, AYS.marker.color.blue, AYS.marker.color.alpha, false, true, 2, false, nil, nil, false)
            else
                Citizen.Wait(500)
            end
        else
            Citizen.Wait(300)
        end
    end
end)

RegisterNUICallback('craft', function(data, cb)
    TriggerServerEvent("ays_weaponcraft:craft", (data.selected + 1))
end)

RegisterNetEvent('ays_weaponcraft:close')
AddEventHandler("ays_weaponcraft:close",function()
    visibile(false)
end)

function DisplayHelpText(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end