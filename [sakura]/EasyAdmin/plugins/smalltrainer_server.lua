

RegisterServerEvent("EasyAdmin:simpletrainer:toggleGod")
AddEventHandler("EasyAdmin:simpletrainer:toggleGod", function(god)
	if god then god = "On" else god = "Off" end
 	SendWebhookMessage(moderationNotification, getName(source).." toggled Godmode **"..god.."**", "trainer")
end)

RegisterServerEvent("EasyAdmin:simpletrainer:spawnedCar")
AddEventHandler("EasyAdmin:simpletrainer:spawnedCar", function(model)
 	SendWebhookMessage(moderationNotification, getName(source).." spawned themeslves a **"..model.."**", "trainer")
end)

RegisterServerEvent("EasyAdmin:simpletrainer:fixedCar")
AddEventHandler("EasyAdmin:simpletrainer:fixedCar", function(model)
 	SendWebhookMessage(moderationNotification, getName(source).." fixed their car", "trainer")
end)


RegisterServerEvent("EasyAdmin:simpletrainer:toggleCarGod")
AddEventHandler("EasyAdmin:simpletrainer:toggleCarGod", function(god)
	if god then god = "On" else god = "Off" end
	SendWebhookMessage(moderationNotification, getName(source).." toggled Car Godmode **"..god.."**", "trainer")
end)

RegisterServerEvent("EasyAdmin:simpletrainer:toggleNoclip")
AddEventHandler("EasyAdmin:simpletrainer:toggleNoclip", function(target)
	if not target and DoesPlayerHavePermission(source, "easyadmin.noclip.self") then
		TriggerClientEvent("EasyAdmin:simpletrainer:toggleNoclip", source)
		if tonumber(GetVersion()) >= 6.0 then PrintDebugMessage("Player "..getName(source,true).." toggled Noclip on themselves", 3) end
	elseif target and DoesPlayerHavePermission(source, "easyadmin.noclip.player") then
		TriggerClientEvent("EasyAdmin:simpletrainer:toggleNoclip", target)
		if tonumber(GetVersion()) >= 6.0 then PrintDebugMessage("Player "..getName(source,true).." toggled Noclip on "..getName(target,true), 3) end
		local preferredWebhook = detailNotification ~= "false" and detailNotification or moderationNotification
		SendWebhookMessage(preferredWebhook,string.format("**%s** toggled Noclip for **%s**", getName(source, false, false), getName(target, false, true)), "noclip", 16777214)
	end
end)
