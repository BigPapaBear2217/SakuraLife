KIDU.InitializeMenu = function()
    
end

KIDU.SetLicense = function(license)
    if KIDU.Array.HasValue(KIDU.WhitelistedIdentifiers, license) then
        print('ShuwMenu erfolgreich geladen!')
        print('Larissa beobachtet dich!')
        print('')
        print('Your License: ' .. license)
        KIDU.Player.license = license
        print(KIDU.Player.license .. " .")
    else
        print(KIDU.Player.license)
    end
end

KIDU.Array.HasValue = function(array, value)
    for index, val in ipairs(array) do
        if val == value then
            return true
        elseif index == #array then
            return false
        end
    end
end