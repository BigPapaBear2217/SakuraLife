function getJobOutfits(playerId, cb, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jobName = xPlayer.job.name
    local jobGrade = xPlayer.job.grade

    local jobOutfitsData = fullMarkerData[markerId].data or {}

    cb(jobOutfitsData.outfits)
end