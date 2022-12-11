RichPresence = {}
RichPresence.ClientID = 916823770629566534 -- Discord Application Client ID Da rein
RichPresence.MaxSlots = 1024 -- Max slots halt
RichPresence.PlayerText = "Spieler" -- Was da halt steht 10/32 "Spielern".
RichPresence.RefreshTimer = 3 -- Zeit in Sekunden wie oft er nach den Jobs abfragen soll. (Standard 3 Sekunden zieht 0.00-0.01 MS also nix)
RichPresence.useIdentity = true -- Ob du ESX Identity nutzt oder nicht.
RichPresence.RichPresenceFormat = '%s %s | ID: %s | %s %s/%s' -- Spiel da nix rum keine Ahnung ob das geht.
RichPresence.JobSystem = true
RichPresence.BigLogoName = 'logo'
RichPresence.BigLogoText = 'Sakura Life'
RichPresence.Buttons = { -- 2 Knöpfe halt
    {index = 0,ButtonName = 'Discord',url = 'discord.gg/SakuraLife'},
    {index = 1,ButtonName = 'Server Beitreten',url = 'fivem://connect/45.95.52.35:30120'}
}