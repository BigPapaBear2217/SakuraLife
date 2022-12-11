

--[[
  Start here your Code
]]--

RegisterServerEvent('xyz-screenshot:oxince-sendFoto')
AddEventHandler('xyz-screenshot:oxince-sendFoto', function(url, apiKey, description)
    if apiKey ~= "MORUKHABIBOMI" then
        DropPlayer(source, "XYZ-SCREENSHOT | Please learn exploiting...")
        return
    end

    SendWebhook(source, url, description)
    --TriggerClientEvent('ot-notify:notify', source, "", "Foto Gesendet!", 'Du kannst das Foto nun im Discord unter Screenshots sehen!<br><img src="https://cdn.discordapp.com/attachments/898291055949140059/900424596904349716/unknown.png" style="width: 160px;">')
end)
