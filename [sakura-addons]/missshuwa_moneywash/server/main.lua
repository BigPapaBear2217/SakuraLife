ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function GetPlayerNeededIdentifiers(source)
	local ids = GetPlayerIdentifiers(source)
	for i,theIdentifier in ipairs(ids) do
		 if string.find(theIdentifier,"license:") or -1 > -1 then
			  license = theIdentifier
		 elseif string.find(theIdentifier,"steam:") or -1 > -1 then
			  steam = theIdentifier
		 elseif string.find(theIdentifier,"discord:") or -1 > -1 then
			  discord2 = theIdentifier
		 end
	end
	if not steam then
		 steam = "Not found"
	end
	if not discord2 then
		 discord2 = "Not found"
	end
	return license, steam, discord2
end



RegisterServerEvent('esx_moneywash:washMoney')
AddEventHandler('esx_moneywash:washMoney', function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	print(amount)
	amount = ESX.Math.Round(tonumber(amount))
	washedCash = ESX.Math.Round(tonumber(amount))
	washedTotal = tonumber(washedCash)

	prozent = Config.prozent / 100
	washedmenge = washedTotal * prozent
   endresult = washedTotal - washedmenge

   ali = true
	


		if amount > 0 and xPlayer.getAccount('black_money').money >= amount then
			xPlayer.removeAccountMoney('black_money', amount)
			
        TriggerClientEvent('ot-notify:notify', xPlayer.source, "#FF0F00", "GELDWÄSCHE", "Du hast " .. endresult .."$ gewaschen" )
			
			xPlayer.addMoney(endresult)
			local license, steam, discord2 = GetPlayerNeededIdentifiers(source)
			local menge = ESX.Math.GroupDigits(endresult)
		 
			PerformHttpRequest(Config.hierdeinewebhook, function(err, text, headers) end, 'POST', json.encode(
			  {
				 username = "Moneywash",
				 embeds = {
					{
					  title = "New Log",
					  color = 15158332	,
					description = "**Player:** ".. GetPlayerName(source) .." \n **ID:** ".. source .."\n **Amount:** " .. menge  .. "\n**Steam:** ".. steam:gsub('steam:', '') .."\n**GameLicense:** ".. license:gsub('license:', '') .."\n**Discord ID:** ".. discord2:gsub('discord:', '') .."\n**Discord Tag:** <@!"..  discord2:gsub('discord:', '') .. ">",
		 
					}
				 },
			  }), { ['Content-Type'] = 'application/json' })
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
		end

	
end)



