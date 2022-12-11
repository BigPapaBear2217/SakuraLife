RegisterNetEvent("ot-acl")
AddEventHandler("ot-acl", function(id, crds, identifier, reason, playerName)
    local pcoords = GetEntityCoords(PlayerPedId())

    if GetDistanceBetweenCoords(vector3(crds), pcoords, true) < 15.0 then
        TriggerEvent('ot-notify:notify', "#ff0000", "Anti Combatlog", "Der Spieler " .. playerName .. " hat den Server verlassen. Grund: \"" .. reason .. "\" | Report-ID: " .. identifier)
    end
end)