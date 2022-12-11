local function openPlayerOutfits()
    ESX.TriggerServerCallback('esx_job_creator:getPlayerWardrobe', function(outfits, propertyOutfits)
        local elements = {}

        for id, outfitData in pairs(outfits) do
            table.insert(elements, {
                label = outfitData.label,
                id = id,
                outfit = outfitData.outfit,
                isPropertyOutfit = false
            })
        end

        for id, outfitData in pairs(propertyOutfits) do
            table.insert(elements, {
                label = outfitData.label,
                id = id,
                outfit = outfitData.skin,
                isPropertyOutfit = true
            })
        end
        
        if(#elements == 0) then
            table.insert(elements, {
                label = getLocalizedText('wardrobe:empty')
            })
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
            title    =  getLocalizedText('player_clothes'),
            align    = 'bottom-right',
            elements = elements
        }, function(data, menu)
            if(data.current.outfit) then
                setClothes(data.current.outfit, true)
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

local function deletePlayerOutfits()
    ESX.TriggerServerCallback('esx_job_creator:getPlayerWardrobe', function(outfits, propertyOutfits)
        local elements = {}

        for id, outfitData in pairs(outfits) do
            table.insert(elements, {
                label = getLocalizedText("wardrobe:delete", outfitData.label),
                id = id,
                outfit = outfitData.outfit,
                isPropertyOutfit = false
            })
        end

        for id, outfitData in pairs(propertyOutfits) do
            table.insert(elements, {
                label = getLocalizedText("wardrobe:delete", outfitData.label),
                id = id,
                outfit = outfitData.skin,
                isPropertyOutfit = true
            })
        end

        if(#elements == 0) then
            table.insert(elements, {
                label = getLocalizedText('wardrobe:empty')
            })
        end
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
            title    = getLocalizedText('remove_cloth'),
            align    = 'bottom-right',
            elements = elements
        }, function(data, menu)
            local outfitID = data.current.id
            local isPropertyOutfit = data.current.isPropertyOutfit

            if(outfitID) then
                menu.close()

                if(isPropertyOutfit) then
                    TriggerServerEvent('esx_job_creator:wardrobe:deletePropertyOutfit', data.current.id)
                else
                    TriggerServerEvent('esx_job_creator:wardrobe:deleteOutfit', data.current.id)
                end

                notifyClient(getLocalizedText('delete_outfit'))
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function openWardrobe()
    local elements = {
        {label = getLocalizedText('player_clothes'), value = 'player_dressing'},
        {label = getLocalizedText('remove_cloth'), value = 'remove_cloth'},
        {label = getLocalizedText('save_cloth'), value = 'save_cloth'}
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wardrobe', {
        title    = getLocalizedText('clothes'),
        align    = 'bottom-right',
        elements = elements
    }, function(data, menu)
        local action = data.current.value
        if action == 'player_dressing' then
            openPlayerOutfits()
        elseif action == 'remove_cloth' then
            deletePlayerOutfits()
        elseif action == "save_cloth" then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'outfit_name', {
                title = getLocalizedText("outfit_name"),
            }, function(data, menu)
                local outfitLabel = data.value
                
                if(outfitLabel) then
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        TriggerServerEvent('esx_job_creator:saveNewOutfitInWardrobe', skin, outfitLabel)
                    end)
                    
                    menu.close()
                else
                    notifyClient(getLocalizedText('outfit_label_empty'))
                end
            end, function(data, menu)
                menu.close()
            end)
        end
    end, function(data, menu)
        openedMenu = nil
        menu.close()
    end)
end