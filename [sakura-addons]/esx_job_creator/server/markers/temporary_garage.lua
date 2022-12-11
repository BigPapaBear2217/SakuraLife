function retrieveVehicles(playerId, cb, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    cb(fullMarkerData[markerId].data)
end