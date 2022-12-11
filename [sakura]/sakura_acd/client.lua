RegisterNetEvent("VehicleDespawner:notification")
AddEventHandler("VehicleDespawner:notification", function(msg)
    TriggerEvent('ot-notify:notify', "#ff0000", "Abschlepphof", msg)
end)
