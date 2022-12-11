local function retrieveVehicles(markerId)
    ESX.TriggerServerCallback('esx_job_creator:retrieveVehicles', function(vehiclesData)
        if (not vehiclesData) then
            return
        end

        local spawnCoords = vehiclesData.spawnCoords
        local spawnHeading = vehiclesData.heading

        local vehicles = {}

        for vehicleName, vehicleData in pairs(vehiclesData.vehicles) do
            table.insert(vehicles, {
                label = getVehicleNameFromModel(vehicleName),
                value = vehicleName,
                vehicleData = vehicleData
            })
        end

        if (#vehicles == 0) then
            table.insert(vehicles, {
                label = getLocalizedText("no_vehicle")
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage_vehicles', {
            title = getLocalizedText("garage"),
            align = 'bottom-right',
            elements = vehicles
        }, function(data, menu)
            local value = data.current.value

            if (value) then
                local vehicleData = data.current.vehicleData

                ESX.Game.SpawnVehicle(value, {
                    x = spawnCoords.x + .0,
                    y = spawnCoords.y + .0,
                    z = spawnCoords.z + .0
                }, spawnHeading + .0, function(vehicle)
                    local plyPed = PlayerPedId()

                    TaskWarpPedIntoVehicle(plyPed, vehicle, -1)

                    local r, g, b = getRGBFromHex(vehicleData.primaryColor)
                    SetVehicleCustomPrimaryColour(vehicle, r, g, b)

                    r, g, b = getRGBFromHex(vehicleData.secondaryColor)
                    SetVehicleCustomSecondaryColour(vehicle, r, g, b)

                    ESX.UI.Menu.CloseAll()
                    openedMenu = nil
                end)
            end
        end, function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end, markerId)
end

function openGarage(markerId)
    ESX.UI.Menu.CloseAll()

    local elements = {{
        label = getLocalizedText("take_vehicle"),
        value = "take_vehicle"
    }}

    local plyPed = PlayerPedId()

    if (IsPedInAnyVehicle(plyPed, false)) then
        table.insert(elements, 1, {
            label = getLocalizedText("park_vehicle"),
            value = "park_vehicle"
        })
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage', {
        title = getLocalizedText("garage"),
        align = 'bottom-right',
        elements = elements
    }, function(data, menu)
        local value = data.current.value

        if (value == "take_vehicle") then
            retrieveVehicles(markerId)
        elseif (value == "park_vehicle") then
            local plyVeh = GetVehiclePedIsIn(plyPed, false)
            DeleteVehicle(plyVeh)

            openedMenu = nil
            menu.close()
        end
    end, function(data, menu)
        openedMenu = nil
        menu.close()
    end)
end
