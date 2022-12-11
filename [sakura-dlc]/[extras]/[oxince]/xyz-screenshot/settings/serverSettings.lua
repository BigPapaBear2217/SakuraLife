ServerSettings = {
    webhook = "https://discord.com/api/webhooks/919826456585056306/0QGN8oDlj7Ng2i8u1qdSUKRL08QHeWN_QDyBmK3ycwPZXnvb31ItZ9P1Cc_HStHBT4FM",
    useDescription = true
}

SendWebhook = function(source, imageUrl, imageDescription)
    local embedDescription = "Von: **" .. GetPlayerName(source) .. "**"

    if imageDescription ~= nil and imageDescription ~= "" and ServerSettings.useDescription then
        embedDescription = embedDescription .. " - Beschreibung: **" .. imageDescription .. "**"
    end

    PerformHttpRequest(ServerSettings.webhook, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            {
                ["title"] = "Neuer Screenshot!",
                ["description"] = embedDescription,
                ["color"] = 15270397,
        
                ["author"] = {
                    ["name"] = "SakuraLife",
                    ["icon_url"] = "https://cdn.discordapp.com/icons/919707997259857990/a_399b62093d40f36d85a6c9fe3b24596a.webp?"
                },
        
                ["footer"] = {
                    ["text"] = " (c) Sakuralife - 2021",
                    ["icon_url"] = "https://cdn.discordapp.com/icons/919707997259857990/a_399b62093d40f36d85a6c9fe3b24596a.webp?"
                },
                
                ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
                ["image"] = {
                    ["url"] = imageUrl
                }
            }
        }
    }), {
        ['Content-Type'] = 'application/json'
    })
end
