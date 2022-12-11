ESX = nil


TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)

-- Item use
ESX.RegisterUsableItem('koks', function(source)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('koks', 1)

	TriggerClientEvent('kypo-drug-effect:onCoke', source)
end)

-- Item use
ESX.RegisterUsableItem('wein', function(source)
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeInventoryItem('wein', 1)

	TriggerClientEvent('ot-notify:notify', source, "", "Inventar", "Du hast eine Flasche Wein gedrunken!")

end)


-- Item use
ESX.RegisterUsableItem('joint', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem('joint', 1)

    TriggerClientEvent('kypo-drug-effect:onWeed', source)
end)

ESX.RegisterUsableItem('heroin', function(source)
        
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem('heroin', 1)

TriggerClientEvent('kypo-drug-effect:onHeroin', source)
end)


ESX.RegisterUsableItem('tilidin_harvested', function(source)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    xPlayer.removeInventoryItem('tilidin_harvested', 1)

    TriggerClientEvent('kypo-drug-effect:onLsd', source)
end)

ESX.RegisterUsableItem('meth_harvested', function(source)
        
    local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
xPlayer.removeInventoryItem('meth_harvested', 1)

TriggerClientEvent('kypo-drug-effect:onMeth', source)
end)
--[[


ESX.RegisterUsableItem('lsa', function(source)
        
    local _source = source
local xPlayer = ESX.GetPlayerFromId(_source)
xPlayer.removeInventoryItem('lsa', 1)

TriggerClientEvent('kypo-drug-effect:onLsa', source)
end)]]