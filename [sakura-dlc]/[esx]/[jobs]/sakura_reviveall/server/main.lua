-- Free to use / By SkurllexTV

ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('bloodline-reviveall:revive')
AddEventHandler('bloodline-reviveall:revive', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

    if target == -1 then
        return
    end

	TriggerClientEvent('bloodline-reviveall:revive', target)
end)

TriggerEvent('es:addGroupCommand', 'reviveall', 'superadmin', function(source, args, user)
	TriggerClientEvent('bloodline-reviveall:reviveallplayers', source)

end, function(source, args, user)
	TriggerClientEvent('ot-notify:notify', '', 'SYSTEM', "Dazu hast du keine Berechtigung!")
end, {help = 'revive all'})
