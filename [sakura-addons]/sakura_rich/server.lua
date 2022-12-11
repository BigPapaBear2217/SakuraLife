ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Kuuzoo-RichPresence:UpdatePresence')
AddEventHandler('Kuuzoo-RichPresence:UpdatePresence', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	local result = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex, dateofbirth, height FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	})
	
	local firstname = result[1].firstname
	local lastname  = result[1].lastname

	local data = {
		['PlayerName'] = GetPlayerName(_source),
		['firstname'] = firstname,
		['lastname'] = lastname,
		['IdentityName'] = xPlayer.getName(),
		['Job'] = {jobName = xPlayer.getJob().name, jobGrade = xPlayer.getJob().grade_label, jobLabel = xPlayer.getJob().label},
		['ActivePlayers'] = GetNumPlayerIndices()
	}

    TriggerClientEvent('Kuuzoo-RichPresence:SetPresence',_source,data)
end)