Config = {}

Config.Language = "Germany"

Config.DefaultKeyBindAccept = "y"

Config.DefaultKeyBindDecline = "n"

Config.CarryViaCommand = true -- You can trigger carry via event from some menu for example TriggerEvent("rtx_carry:Carry") for trigger carry with certain type selected for example TriggerEvent("rtx_carry:Carry", "1") Types 1-3

Config.CarryCommand = "carry" 

Config.CarryMarker = true

Config.CarryLine = true

Config.CarryInterfaceWhileCarryed = true

Config.CarryDistance = 5.0 -- maximum distance from player for carry

Config.CarryDistanceDraw = 5.0 --maximum distance of draw line and marker

Config.RequestDuration = 60 -- in seconds

-- EVENTS

function Notify(text)
	TriggerEvent('ot-notify:notify', "", "Carry", text)
end