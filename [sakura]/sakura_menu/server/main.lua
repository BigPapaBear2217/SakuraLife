ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('Jason:GetRechnungen', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local bills = {}

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		for i = 1, #result, 1 do
			table.insert(bills, {
				id = result[i].id,
				label = result[i].label,
				amount = result[i].amount
			})
		end

		cb(bills)
	end)
end)

ESX.RegisterServerCallback('esx_givecarkeys:requestPlayerCars', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
        local found = false

        for i=1, #result, 1 do
            local vehicleProps = json.decode(result[i].vehicle)

            if trim(vehicleProps.plate) == trim(plate) then
                found = true
                break
            end
        end

        if found then
            cb(true)
        else
            cb(false)
        end
    end)
end)


ESX.RegisterServerCallback('esx_givecarkeys:setVehicleOwnedPlayerId', function(source, cb, playerId, vehicleProps)
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local xOwner = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET owner=@owner WHERE plate=@plate AND owner=@owner2', {
		['@owner']   = xPlayer.identifier,
		['@owner2']   = xOwner.identifier,
		['@plate']   = vehicleProps.plate
	}, function (rowsChanged)
		cb(true)
		TriggerClientEvent('ot-notify:notify', playerId, "#DF0101", "Autoschlüssel", "Du hast ein Fahrzeugschlüssel für das Kennzeichen " .. vehicleProps.plate .. ' erhalten.')
	end)
end)

function trim(s)
    if s ~= nil then
		return s:match("^%s*(.-)%s*$")
	else
		return nil
    end
end

function getMaximumGrade(jobname)
	local queryDone, queryResult = false, nil

	MySQL.Async.fetchAll('SELECT * FROM job_grades WHERE job_name = @jobname ORDER BY `grade` DESC ;', {
		['@jobname'] = jobname
	}, function(result)
		queryDone, queryResult = true, result
	end)

	while not queryDone do
		Citizen.Wait(10)
	end

	if queryResult[1] then
		return queryResult[1].grade
	end

	return nil
end


-- Grade Menu --
RegisterServerEvent('bloodline-fraksys:jobPromote')
AddEventHandler('bloodline-fraksys:jobPromote', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == tonumber(getMaximumGrade(sourceXPlayer.job.name)) - 1) then
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Um zum höchsten Rank zu befördern braucht man die Erlaubnis der Regierung.')
	else
		if sourceXPlayer.job.grade_name == 'boss' or sourceXPlayer.job.grade_name == 'captain' or sourceXPlayer.job.grade_name == 'commander' or sourceXPlayer.job.grade_name == 'assistantchief' and sourceXPlayer.job.name == targetXPlayer.job.name then
			targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) + 1)

			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Sie haben folgende Person befördert ' .. targetXPlayer.name .. '~w~.')
			TriggerClientEvent('esx:showNotification', target, 'Du wurdest befördert von ' .. sourceXPlayer.name .. '~w~.')
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Du hast dazu keine Erlaubnis.')
		end
	end
end)

RegisterServerEvent('bloodline-fraksys:jobDegradieren')
AddEventHandler('bloodline-fraksys:jobDegradieren', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == 0) then
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Du kannst diesen Spieler nicht mehr ~r~degradieren~w~.')
	else
		if sourceXPlayer.job.grade_name == 'boss' or sourceXPlayer.job.grade_name == 'captain' or sourceXPlayer.job.grade_name == 'commander' or sourceXPlayer.job.grade_name == 'assistantchief' and sourceXPlayer.job.name == targetXPlayer.job.name then
			targetXPlayer.setJob(targetXPlayer.job.name, tonumber(targetXPlayer.job.grade) - 1)

			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Du hast ' .. targetXPlayer.name .. ' ~r~degradiert~w~.')
			TriggerClientEvent('esx:showNotification', target, 'Du wurdest von ' .. sourceXPlayer.name .. '~r~degradiert~w~.')
		else
			TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Du hast dazu keine Erlaubnis.')
		end
	end
end)

RegisterServerEvent('bloodline-fraksys:jobEinladen')
AddEventHandler('bloodline-fraksys:jobEinladen', function(target, job, grade)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
    
	if sourceXPlayer.job.grade_name == 'boss' or sourceXPlayer.job.grade_name == 'captain' or sourceXPlayer.job.grade_name == 'commander' or sourceXPlayer.job.grade_name == 'assistantchief' then
		targetXPlayer.setJob(job, 1)
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Du hast ' .. targetXPlayer.name .. '~g~eingestellt~w~!.')
		TriggerClientEvent('esx:showNotification', target, 'Du von ' .. sourceXPlayer.name .. ' ~g~eingestellt~w~!')
	end
end)

RegisterServerEvent('bloodline-fraksys:remove')
AddEventHandler('bloodline-fraksys:remove', function(item, quantity)
    print(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem(item, quantity)
end)

RegisterServerEvent('bloodline-fraksys:jobFeuern')
AddEventHandler('bloodline-fraksys:jobFeuern', function(target)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if sourceXPlayer.job.grade_name == 'boss' and sourceXPlayer.job.name == targetXPlayer.job.name then
		targetXPlayer.setJob('unemployed', 0)
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Du hast folgende Person gefeuert ' .. targetXPlayer.name .. '~w~.')
		TriggerClientEvent('esx:showNotification', target, 'Du wurdest gefeuert von' .. sourceXPlayer.name .. '~w~.')
	else
		TriggerClientEvent('esx:showNotification', sourceXPlayer.source, 'Du hast dazu keine Erlaubnis.')
	end
end)