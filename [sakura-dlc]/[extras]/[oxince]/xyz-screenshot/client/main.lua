RegisterCommand(ClientSettings.commandName, function(source, args)
    exports[ClientSettings.screenShotBasic]:requestScreenshotUpload('https://discord.com/api/webhooks/920878446589116446/9XqQm8gwCyBUWeLOPQBgXa9S6qd6ZCLqflsiYuWEU_lqXstpw6VYiMz3Bz2e6cilbciM', 'files[]', function(data)
        local response = json.decode(data)

        local description = ""
        for i=1, #args do
            local v = args[i]
            description = description .. tostring(v) .. " "
        end
        
        TriggerServerEvent("xyz-screenshot:oxince-sendFoto", response.attachments[1].proxy_url, "MORUKHABIBOMI", description)
    end)
end, false)
