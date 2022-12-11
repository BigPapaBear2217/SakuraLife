local function openGarageBuyableVehicles(markerId)
    ESX.TriggerServerCallback('esx_job_creator:getGarageBuyableData', function(garageData)
        local elements = {}

        if(garageData.vehicles) then
            for vehicleName, vehiclePrice in pairs(garageData.vehicles) do
                local label = getLocalizedText('buyable_vehicle', getVehicleNameFromModel(vehicleName), ESX.Math.GroupDigits(vehiclePrice))
                table.insert(elements, {label =  label, value = vehicleName, price = vehiclePrice, vehicleLabel = getVehicleNameFromModel(vehicleName)})
            end
        end

        if(#elements == 0) then
            table.insert(elements, {
                label = getLocalizedText("permanent_garage:no_vehicle_to_buy")
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_garage_buyable', {
            title = getLocalizedText('garage'),
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            local vehicleName = data.current.value

            if(not vehicleName) then return end

            local vehiclePrice = data.current.price
            local vehicleLabel = data.current.vehicleLabel

            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_garage_confirm', {
                title = getLocalizedText('are_you_sure', vehicleLabel, ESX.Math.GroupDigits(vehiclePrice)),
                align = 'bottom-right',
                elements = {
                    {label = "Ja", value = "yes"},
                    {label = "Nein", value = "no"},
                }
            },
            function(data, menu)
                if(data.current.value == "yes") then
                    TriggerServerEvent('esx_job_creator:buyVehicleFromGarage', markerId, vehicleName)
                end

                menu.close()
            end,
            function(data, menu)
                openedMenu = nil
                menu.close()
            end)
        end,
        function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end, markerId)
end

local function openGarageBuyableOwnedVehicles(markerId)
    local plyPed = PlayerPedId()

    ESX.TriggerServerCallback('esx_job_creator:getGarageOwnedVehicles', function(garageData)
        local elements = {}

        local ownedVehicles = garageData.vehicles

        if(ownedVehicles) then
            for k, data in pairs(ownedVehicles) do
                local vehicleName = data.vehicle

                local vehicleLabel = getVehicleNameFromModel(vehicleName)

                if(data.plate) then
                   vehicleLabel = vehicleLabel .. " - " .. data.plate 
                end

                if(data.isOutside) then
                    vehicleLabel =  getLocalizedText('buyable_vehicle:outside', vehicleLabel)
                end

                table.insert(elements, {
                    label = vehicleLabel,
                    vehicleName = vehicleName,
                    vehicleId = data.vehicleId,
                    vehicleProps = data.vehicleProps,
                    vehiclePlate = data.plate,
                    isOutside = data.isOutside
                })
            end
        end

        if(#elements == 0) then
            table.insert(elements, {label = getLocalizedText('no_vehicles_in_garage')})
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_garage_owned', {
            title = getLocalizedText('garage'),
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            local vehicleName = data.current.vehicleName

            if(not vehicleName) then return end

            if(data.current.isOutside) then
                notifyClient(getLocalizedText('vehicle_outside'))
                return
            end
            
            local vehicleProps = data.current.vehicleProps
            local vehicleId = data.current.vehicleId
            local vehiclePlate = data.current.vehiclePlate

            local coords = vector3(tonumber(garageData.spawnCoords.x), tonumber(garageData.spawnCoords.y), tonumber(garageData.spawnCoords.z))

            ESX.Game.SpawnVehicle(vehicleName, coords, garageData.heading, function(vehicle)
                SetEntityAsMissionEntity(vehicle, true, true)
                
                ESX.Game.SetVehicleProperties(vehicle, vehicleProps)

                if(vehiclePlate) then
                    SetVehicleNumberPlateText(vehicle, vehiclePlate)
                end

                TaskEnterVehicle(plyPed, vehicle, 1000, -1, 2.0, 16, 0)

                TriggerServerEvent('esx_job_creator:permanent_garage:vehicleIdSpawned', vehicleId, VehToNet(vehicle))
            end)

            openedMenu = nil
            ESX.UI.Menu.CloseAll()
        end,
        function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end, markerId)
end

function openGarageBuyable(markerId)
    local plyPed = PlayerPedId()

    ESX.UI.Menu.CloseAll()

    local elements = {
        {label = "Garage", value = "garage"},
        {label = "Fahrzeuge kaufen", value = "buy"},
    }

    if(IsPedInAnyVehicle(plyPed)) then
        table.insert(elements, 1, {label = "Deposit current vehicle", value = "deposit"})
    end

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_garage_options', {
        title = getLocalizedText('garage'),
        align = 'bottom-right',
        elements = elements
    },
    function(data, menu)
        local action = data.current.value

        if(action == "buy") then
            openGarageBuyableVehicles(markerId)
        elseif(action == "garage") then
            openGarageBuyableOwnedVehicles(markerId)
        elseif(action == "deposit") then
            local vehicle = GetVehiclePedIsIn(plyPed, false)
            if(DoesEntityExist(vehicle)) then
                local props = ESX.Game.GetVehicleProperties(vehicle)
                local plate = GetVehicleNumberPlateText(vehicle)
                
                ESX.TriggerServerCallback('esx_job_creator:permanent_garage:updateVehicleProps', function(isSuccessful) 
                    if(isSuccessful) then
                        DeleteVehicle(vehicle)
                    end
                end, markerId, VehToNet(vehicle), props, plate)
            end
        end
    end,
    function(data, menu)
        openedMenu = nil
        menu.close()
    end)
end