ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('schachtel', function()

	xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('zigarette', 6)
	TriggerClientEvent('ot-notify:notify', source, '#00ff00', 'ZIGARETTEN-SYSTEM', 'Zigarettenschachtel ausgepackt')

end)

ESX.RegisterUsableItem('zigarette', function()

	xPlayer = ESX.GetPlayerFromId(source)
	TriggerClientEvent('sl_zigarette:rauchen')

end)