function getTeleportCoords(playerId, cb, markerId)
    local coords = fullMarkerData[markerId].data and fullMarkerData[markerId].data.teleportCoords or nil

    cb(coords)
end