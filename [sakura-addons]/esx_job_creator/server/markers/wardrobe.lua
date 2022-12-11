local wardrobesData = {}

local function getPlayerWardrobeFromProperty(playerId, cb)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        if(store) then
            local dressings = store.get('dressing')
            cb(dressings or {})
        else
            cb({})
        end
    end)
end

function getAllWardrobesData()
    MySQL.Async.fetchAll("SELECT * FROM jobs_wardrobes", {}, function(result)
        if(result) then
            for k, currentData in pairs(result) do
                if(not wardrobesData[currentData.identifier]) then
                    wardrobesData[currentData.identifier] = {}
                end

                wardrobesData[currentData.identifier][currentData.id] = {
                    outfit = json.decode(currentData.outfit),
                    label = currentData.label
                }
            end
        end
    end)
end

RegisterNetEvent('esx_job_creator:saveNewOutfitInWardrobe')
AddEventHandler('esx_job_creator:saveNewOutfitInWardrobe', function(outfit, outfitLabel)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local identifier = xPlayer.identifier

    MySQL.Async.insert("INSERT INTO jobs_wardrobes(identifier, label, outfit) VALUES(@identifier, @label, @outfit)", {
        ["@identifier"] = identifier,
        ["@label"] = outfitLabel,
        ["@outfit"] = json.encode(outfit)
    },
    function(outfitId)
        if(outfitId > 0) then
            if(not wardrobesData[identifier]) then
                wardrobesData[identifier] = {}
            end

            wardrobesData[identifier][outfitId] = {
                outfit = outfit,
                label = outfitLabel
            }
        end
    end)
end)

function getPlayerWardrobe(playerId, cb)
    local xPlayer  = ESX.GetPlayerFromId(playerId)
    
    local outfits = wardrobesData[xPlayer.identifier] or {}

    if(config.enablePropertyOutfits) then
        getPlayerWardrobeFromProperty(playerId, function(propertyOutfits)
            cb(outfits, propertyOutfits)
        end)
    else
        cb(outfits, {})
    end
end

function getPlayerOutfit(playerId, cb, outfitId)
    local xPlayer  = ESX.GetPlayerFromId(playerId)
    
    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        local outfit = store.get('dressing', outfitId)
        cb(outfit.skin)
    end)
end

local function deleteOutfit(outfitId)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)
    local identifier = xPlayer.identifier

	wardrobesData[identifier][outfitId] = nil

    MySQL.Async.execute("DELETE FROM jobs_wardrobes WHERE id=@id", {
        ["@id"] = outfitId
    })
end
RegisterNetEvent('esx_job_creator:wardrobe:deleteOutfit', deleteOutfit)

local function deletePropertyOutfit(outfitId)
    local playerId = source
    local xPlayer = ESX.GetPlayerFromId(playerId)

    TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
        if(store) then
            local dressings = store.get('dressing')

            table.remove(dressings, outfitId)

            store.set("dressing", dressings)
        end
    end)
end
RegisterNetEvent('esx_job_creator:wardrobe:deletePropertyOutfit', deletePropertyOutfit)