ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



RegisterServerEvent('ali_namechange:SetFirstName')
AddEventHandler('ali_namechange:SetFirstName', function(ID, firstName, lastName)
    local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)

	if lastName == "" and firstName == "" then 
		TriggerClientEvent('ot-notify:notify', source, "#0ac27f", "AUSWEIS", "Du musste einen Namen angeben") 
		return
	end


if lastName == "" then 
	TriggerClientEvent('ot-notify:notify', source, "#0ac27f", "AUSWEIS", "Du musste einen Nachnamen angeben") 
	return
elseif firstName == "" then 
	TriggerClientEvent('ot-notify:notify', source, "#0ac27f", "AUSWEIS", "Du musste einen Vornamen angeben")
	return
end

	if xPlayer.getMoney() >= 150000 then
		local newfirstname = xPlayer.getName()
        xPlayer.removeMoney(150000)
		SetFirstName(identifier, firstName)
		TriggerClientEvent('ot-notify:notify', source, "#0ac27f", "AUSWEIS", "Dein neuer Vorname ist: " .. firstName)
		SetLastName(identifier, lastName)
		TriggerClientEvent('ot-notify:notify', source, "#0ac27f", "AUSWEIS", "Dein neuer Nachname ist: " .. lastName)
	
	else
		--xPlayer.showNotification('~r~~hold~You have not enough money!')
		TriggerClientEvent('ot-notify:notify', source, "#0ac27f", "AUSWEIS", "Du hast nicht genug Bargeld um deinen Vornamen zu ändern.")
		TriggerClientEvent('ot-notify:notify', source, "#0ac27f", "AUSWEIS", "Du brauchst 10.0000$")
	end
end)







-- Vorname
function SetFirstName(identifier, firstName)
	MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@firstname']		= firstName
	})
end

-- Nachname
function SetLastName(identifier, lastName)
	MySQL.Async.execute('UPDATE `users` SET `lastname` = @lastname WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@lastname']		= lastName
	})
end



-- NUI Close
RegisterNetEvent("ali_namechange:deny")
AddEventHandler("ali_namechange:deny", function(data)
    TriggerClientEvent('ot-notify:notify', source, "#0ac27f", "INFORMAION", "Du hast den Vorgang abgebrochen.")
end)