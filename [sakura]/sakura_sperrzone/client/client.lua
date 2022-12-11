RegisterNetEvent('bloodline-sperrzone:setSpeerzone')
AddEventHandler('bloodline-sperrzone:setSpeerzone', function(s, radius, playerCoords)

    local radiusBlip = AddBlipForRadius(playerCoords.x, playerCoords.y, playerCoords.z, tonumber(math.floor(radius * 6.4) .. '.0'))

    SetBlipSprite(radiusBlip, 3)
    SetBlipHiddenOnLegend(radiusBlip, false)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Sperrzone - ' .. radius .. "m")
    EndTextCommandSetBlipName(radiusBlip)
    
    SetBlipAlpha(radiusBlip, 80)

    Citizen.Wait(300000)

    RemoveBlip(radiusBlip)
end)