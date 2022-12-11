RegisterServerEvent('kidu:setIdentifier')
AddEventHandler('kidu:setIdentifier', function()
    local license
    
    for key, value in pairs(GetPlayerIdentifiers(source)) do
        if string.find(value, "license:") then
            license = value
        end
    end

    TriggerClientEvent('kidu:syncIdentifier', source, license)
end)