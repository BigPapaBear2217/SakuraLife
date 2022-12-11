Citizen.CreateThread(function()
    ReplaceHudColourWithRgba(
        116, -- old Color
        245, -- R
        40, -- G
        145, -- B
        255 -- A
    )
end)

function AddTextEntry(key, value)
    Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), key, value)
end

Citizen.CreateThread(function()
  AddTextEntry('FE_THDR_GTAO', 'SakuraLife')
end)