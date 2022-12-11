RegisterServerEvent("EasyAdmin:griefmenu:TruckPunchline")
AddEventHandler("EasyAdmin:griefmenu:TruckPunchline", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.griefing.truck") then
		SendWebhookMessage(moderationNotification, getName(source).." triggered **the Truck Punchline** on "..getName(playerId).. "", "troll")
		TriggerClientEvent("EasyAdmin:griefmenu:TruckPunchline", playerId)
	end
end)


RegisterServerEvent("EasyAdmin:griefmenu:Flashbang")
AddEventHandler("EasyAdmin:griefmenu:Flashbang", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.griefing.flashbang") then
		SendWebhookMessage(moderationNotification, getName(source).." triggered **Flashbang** on "..getName(playerId).. "", "troll")
		TriggerClientEvent("EasyAdmin:griefmenu:Flashbang", playerId)
	end
end)

RegisterServerEvent("EasyAdmin:griefmenu:ClownAttack")
AddEventHandler("EasyAdmin:griefmenu:ClownAttack", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.griefing.clowns") then
		SendWebhookMessage(moderationNotification, getName(source).." triggered **Clown Attack** on "..getName(playerId).. "", "troll")
		TriggerClientEvent("EasyAdmin:griefmenu:ClownAttack", playerId)
	end
end)


RegisterServerEvent("EasyAdmin:griefmenu:LagGame")
AddEventHandler("EasyAdmin:griefmenu:LagGame", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.griefing.lag") then
		TriggerClientEvent("EasyAdmin:showNotification", source, getName(playerId).."'s is now lagging, press again to cancel lag.")
		SendWebhookMessage(moderationNotification, getName(source).." triggered **Lag** on "..getName(playerId).. "", "troll")
		TriggerClientEvent("EasyAdmin:griefmenu:LagGame", playerId)
	end
end)

RegisterServerEvent("EasyAdmin:griefmenu:CrashGame")
AddEventHandler("EasyAdmin:griefmenu:CrashGame", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.griefing.crash") then
		TriggerClientEvent("EasyAdmin:showNotification", source, getName(playerId).."'s game will be crashing in a few seconds.")
		SendWebhookMessage(moderationNotification, getName(source).." triggered **Crash Game** on "..getName(playerId).. "", "troll")
		TriggerClientEvent("EasyAdmin:griefmenu:CrashGame", playerId)
	end
end)

RegisterServerEvent("EasyAdmin:griefmenu:DrugPlayer")
AddEventHandler("EasyAdmin:griefmenu:DrugPlayer", function(playerId)
	if DoesPlayerHavePermission(source,"easyadmin.griefing.drug") then
		TriggerClientEvent("EasyAdmin:showNotification", source, getName(playerId).." will be Drugged for 60 seconds.")
		SendWebhookMessage(moderationNotification, getName(source).." triggered **Drug Player** on "..getName(playerId).. "", "troll")
		TriggerClientEvent("EasyAdmin:griefmenu:DrugPlayer", playerId)
	end
end)