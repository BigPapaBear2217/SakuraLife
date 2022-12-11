ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(500)
	end
end)


RegisterServerEvent("EasyAdmin:esx:addAccountMoney")
AddEventHandler("EasyAdmin:esx:addAccountMoney", function(playerId, account,accountMoney)
	if DoesPlayerHavePermission(source,"easyadmin.esx.money") and ESX then
		SendWebhookMessage(moderationNotification, getName(source).." gave "..getName(playerId).." €"..accountMoney.." "..account.." Money.", "esx")

		local xPlayer = ESX.GetPlayerFromId(playerId)
		if accountMoney < 0 then
			xPlayer.removeAccountMoney(account, -accountMoney)
		else
			xPlayer.addAccountMoney(account, accountMoney)
		end
	end
end)

RegisterServerEvent("EasyAdmin:esx:setAccountMoney")
AddEventHandler("EasyAdmin:esx:setAccountMoney", function(playerId, account,accountMoney)
	if DoesPlayerHavePermission(source,"easyadmin.esx.money") and ESX then
		SendWebhookMessage(moderationNotification, getName(source).." gave "..getName(playerId).." €"..accountMoney.." "..account.." Money.", "esx")

		local xPlayer = ESX.GetPlayerFromId(playerId)
		xPlayer.setAccountMoney(account, accountMoney)
	end
end)

RegisterServerEvent("EasyAdmin:esx:addMoney")

AddEventHandler("EasyAdmin:esx:addMoney", function(playerId, money)
	if DoesPlayerHavePermission(source,"easyadmin.esx.money") and ESX then
		SendWebhookMessage(moderationNotification, getName(source).." gave "..getName(playerId).." €"..money..".", "esx")

		local xPlayer = ESX.GetPlayerFromId(playerId)
		if money < 0 then
			xPlayer.removeMoney(-money)
		else
			xPlayer.addMoney(money)
		end
	end
end)

RegisterServerEvent("EasyAdmin:esx:addInventoryItem")
AddEventHandler("EasyAdmin:esx:addInventoryItem", function(playerId, item, count)
	if DoesPlayerHavePermission(source,"easyadmin.esx.items") and ESX then
		SendWebhookMessage(moderationNotification, getName(source).." gave "..getName(playerId).." "..count.." "..count..".", "esx")

		local xPlayer = ESX.GetPlayerFromId(playerId)
		if count < 0 then
			xPlayer.removeInventoryItem(item,-count)
		else
			xPlayer.addInventoryItem(item, count)
		end
	end
end)

RegisterServerEvent("EasyAdmin:esx:setInventoryItem")
AddEventHandler("EasyAdmin:esx:setInventoryItem", function(playerId, item, count)
	if DoesPlayerHavePermission(source,"easyadmin.esx.items") and ESX then
		SendWebhookMessage(moderationNotification, getName(source).." gave "..getName(playerId).." "..count.." "..count..".", "esx")

		local xPlayer = ESX.GetPlayerFromId(playerId)
		xPlayer.setInventoryItem(item, count)
	end
end)


RegisterServerEvent("EasyAdmin:esx:SetJob")
AddEventHandler("EasyAdmin:esx:SetJob", function(playerId, job, grade)
	if DoesPlayerHavePermission(source,"easyadmin.esx.setjob") and ESX then
		local xPlayer = ESX.GetPlayerFromId(playerId)
		SendWebhookMessage(moderationNotification, getName(source).." set job of "..getName(playerId).." to "..job..".", "esx")

		xPlayer.setJob(job,tonumber(grade))
	end
end)

RegisterServerEvent("EasyAdmin:esx:ResetSkin")
AddEventHandler("EasyAdmin:esx:ResetSkin", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.esx.resetskin") and ESX then
		TriggerClientEvent('esx_skin:openSaveableMenu', playerId)
		SendWebhookMessage(moderationNotification, getName(source).." reset skin of "..getName(playerId)..".", "esx")
		TriggerClientEvent("EasyAdmin:showNotification", source, getName(playerId).."'s skin menu has been opened.")
	end
end)

RegisterServerEvent("EasyAdmin:esx:toggleLicense")
AddEventHandler("EasyAdmin:esx:toggleLicense", function(playerId, license)
	local playerId = playerId
	local license = license
	local source = source
	if DoesPlayerHavePermission(source,"easyadmin.esx.license") and ESX then
		local found = false
		TriggerEvent("esx_license:getLicensesList", function(licenses)
			for i, l in pairs(licenses) do
				if l.type == license then
					found = true
					TriggerEvent("esx_license:checkLicense", playerId, license, function(hasLicense)
						if hasLicense then
							TriggerEvent("esx_license:removeLicense", playerId, license)
							SendWebhookMessage(moderationNotification, getName(source).." removed license **"..license.."** from "..getName(playerId)..".", "esx")
							TriggerClientEvent("EasyAdmin:showNotification", source, getName(playerId).."'s "..license.." has been removed ")
						else
							TriggerEvent("esx_license:addLicense", playerId, license)
							SendWebhookMessage(moderationNotification, getName(source).." added license **"..license.."** to "..getName(playerId)..".", "esx")
							TriggerClientEvent("EasyAdmin:showNotification", source, getName(playerId).." has been added the license "..license)
						end
					end)
				end
			end
		end)
		Wait(3000)
		if not found then
			TriggerClientEvent("EasyAdmin:showNotification", source, "This License does not exist.")
		end
	end
end)


RegisterServerEvent("EasyAdmin:esx:HandcuffPlayer")
AddEventHandler("EasyAdmin:esx:HandcuffPlayer", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.esx.cuff") and ESX then
		TriggerClientEvent("esx_westen:farm", playerId)
		SendWebhookMessage(moderationNotification, getName(source).." hancuffed "..getName(playerId)..".", "esx")
	end
end)
 
RegisterServerEvent("EasyAdmin:esx:RevivePlayer")
AddEventHandler("EasyAdmin:esx:RevivePlayer", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.esx.revive") and ESX then
		TriggerClientEvent("afEISFBesfbke789:sdvjhbzugrhf", playerId)
		SendWebhookMessage(moderationNotification, getName(source).." revived "..getName(playerId)..".", "esx")
	end
end)

RegisterServerEvent("EasyAdmin:esx:GodMode") 
AddEventHandler("EasyAdmin:esx:GodMode", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.esx.godmode") and ESX then
		TriggerClientEvent("admin:godmode", playerId)
		SendWebhookMessage(moderationNotification, getName(source).." godmoded "..getName(playerId)..".", "esx")
	end  
end)  

RegisterServerEvent("EasyAdmin:esx:exp") 
AddEventHandler("EasyAdmin:esx:exp", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.esx.ben") and ESX then
		TriggerClientEvent("ano:testmessage11", playerId) 
	end
end)

RegisterServerEvent("EasyAdmin:alkoholisieren") 
AddEventHandler("EasyAdmin:alkoholisieren", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.esx.alkohol") and ESX then
		TriggerClientEvent('esx_status:add', playerId, 'drunk', 250000)
	end
end) 

RegisterServerEvent("EasyAdmin:high") 
AddEventHandler("EasyAdmin:high", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.esx.drogen") and ESX then 
		TriggerClientEvent('esx_status:add', playerId, 'drug', 250000)
	end
end)


RegisterServerEvent("EasyAdmin:hp")  
AddEventHandler("EasyAdmin:hp", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.esx.hp") and ESX then
		TriggerClientEvent('admin:hp', playerId) 
	end
end)

RegisterServerEvent("EasyAdmin:armor") 
AddEventHandler("EasyAdmin:armor", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.esx.armor") and ESX then 
		SetPedArmour(playerId, 100)
	end
end)
 
RegisterServerEvent("EasyAdmin:esx:uns") 
AddEventHandler("EasyAdmin:esx:uns", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.esx.invisible") and ESX then
		TriggerClientEvent("admin:unsichtbar", playerId)
	end
end)

RegisterServerEvent("EasyAdmin:esx:sich")  
AddEventHandler("EasyAdmin:esx:sich", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.esx.visible") and ESX then
		TriggerClientEvent("admin:unsichtbar2", playerId)
	end
end)
  
RegisterServerEvent("EasyAdmin:esx:test") 
AddEventHandler("EasyAdmin:esx:test", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.esx.test") and ESX then
		TriggerClientEvent("ano:testmessage", playerId)
		SendWebhookMessage(moderationNotification, getName(source).." test-notify to "..getName(playerId)..".", "esx")
	end  
end) 
