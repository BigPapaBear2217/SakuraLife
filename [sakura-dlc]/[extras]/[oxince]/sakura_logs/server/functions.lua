LOGS.GetWebhook = function(moduleName)
    for i = 1, #LOGS.LogTypes, 1 do
        if LOGS.LogTypes[i].module == moduleName then
            return LOGS.LogTypes[i].webhook
        end
    end

    print('^0[^1OXINCE-LOGS^0] ^1Webhook für ' .. moduleName .. ' nicht existierend')
    return ''
end

LOGS.GetTitle = function(moduleName)
    for i = 1, #LOGS.LogTypes, 1 do
        if LOGS.LogTypes[i].module == moduleName then
            return LOGS.LogTypes[i].title
        end
    end
    
    print('^0[^1OXINCE-LOGS^0] ^1Title für ' .. moduleName .. ' nicht existierend')
    return ''
end

LOGS.GetUsername = function(moduleName)
    for i = 1, #LOGS.LogTypes, 1 do
        if LOGS.LogTypes[i].module == moduleName then
            return LOGS.LogTypes[i].username
        end
    end
    
    print('^0[^1OXINCE-LOGS^0] ^1Title für ' .. moduleName .. ' nicht existierend')
    return ''
end
