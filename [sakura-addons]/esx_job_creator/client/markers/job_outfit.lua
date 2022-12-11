function openJobOutfit(markerId)
    ESX.TriggerServerCallback("esx_job_creator:getJobOutfits", function(outfits)
        local elements = {}

        if(#outfits > 0) then
            table.insert(elements, {label = getLocalizedText("civilian_outfit"), value = "civilian"})
            
            for k, outfit in pairs(outfits) do
                table.insert(elements, {label = outfit.label, value = outfit})
            end
        else
            table.insert(elements, {label = getLocalizedText("no_outfits")})
        end

        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_outfit', {
            title = getLocalizedText('job_outfit'),
            align = 'bottom-right',
            elements = elements
        },
        function(data, menu)
            local outfit = data.current.value

            if(outfit == "civilian") then
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
            elseif(outfit) then
                setClothes(outfit, false)
            end
        end,
        function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end, markerId)
end