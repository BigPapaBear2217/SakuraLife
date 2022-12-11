local function getJobAccountMoney(jobName, cb)
    local societyName = "society_" .. jobName
    TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
        if(account) then
            cb(account.money)
        end
    end)
end


local function withdrawSocietyMoney(markerId, amount)
    local playerId = source

    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jobName = xPlayer.job.name
    local societyName = "society_" .. jobName

    TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
        if(account) then
            if amount > 0 and account.money >= amount then
                account.removeMoney(amount)
                xPlayer.addMoney(amount)
                notify(playerId, getLocalizedText('boss:withdrew_money', ESX.Math.GroupDigits(amount)))

                log(playerId, 
                    getLocalizedText('log_withdrew_money'),
                    getLocalizedText('log_withdrew_money_description',
                        amount,
                        societyName
                    ),
                    'success',
                    'boss'
                )
            else
                notify(playerId, getLocalizedText('boss:invalid_amount'))
            end
        else
            print("Shared account " .. societyName .. " not found!")
        end
    end)
end
RegisterServerEvent('esx_job_creator:withdrawSocietyMoney', withdrawSocietyMoney)

local function depositSocietyMoney(markerId, amount)
    local playerId = source

    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jobName = xPlayer.job.name
    local societyName = "society_" .. jobName
    
    TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
        if(account) then
            if(xPlayer.getMoney() >= amount) then
                if amount > 0 then
                    account.addMoney(amount)
                    xPlayer.removeMoney(amount)
                    notify(playerId, getLocalizedText('boss:deposited_money', ESX.Math.GroupDigits(amount)))

                    log(playerId, 
                        getLocalizedText('log_deposited_money'),
                        getLocalizedText('log_deposited_money_description', 
                            amount,
                            societyName
                        ),
                        'success',
                        'boss'
                    )
                else
                    notify(playerId, getLocalizedText('boss:invalid_amount'))
                end
            else
                notify(playerId, getLocalizedText("boss:you_dont_have_enough_money"))
            end
        else
            print("Shared account " .. societyName .. " not found!")
        end
    end)
end
RegisterServerEvent('esx_job_creator:depositSocietyMoney', depositSocietyMoney)

function getBossData(playerId, cb, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jobName = xPlayer.job.name

    local bossData = fullMarkerData[markerId].data or {}
    
    local bossOptions = {
        withdraw = bossData.canWithdraw,
        deposit = bossData.canDeposit,
        wash = bossData.canWashMoney,
        employees = bossData.canEmployees,
        grades = bossData.canGrades
    }

    getJobAccountMoney(jobName, function(money)
        cb(bossOptions, money)
    end)
end

function getJobGradesSalaries(playerId, cb, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jobName = xPlayer.job.name

    MySQL.Async.fetchAll("SELECT id, grade, label, salary FROM job_grades WHERE job_name=@jobName", {
        ['@jobName'] = jobName
    }, function(gradesWithSalaries)
        cb(gradesWithSalaries)
    end)
end

local function updateGradeSalary(markerId, gradeId, grade, quantity)
    local playerId = source

    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jobName = xPlayer.job.name

    MySQL.Async.execute("UPDATE job_grades SET salary=@quantity WHERE id=@gradeId AND job_name=@jobName AND grade=@grade", {
        ['@gradeId'] = gradeId,
        ['@quantity'] = quantity,
        ['@jobName'] = jobName,
        ['@grade'] = grade,
    }, function(affectedRows)
        if(affectedRows > 0) then
            notify(playerId, getLocalizedText("boss:grade_salary_updated"))

            log(
                playerId, 
                getLocalizedText('log_updated_salary'),
                getLocalizedText('log_updated_salary_description', grade, quantity),
                'success',
                'boss'
            )

            for k, playerId in pairs(ESX.GetPlayers()) do
                local xPlayer = ESX.GetPlayerFromId(playerId)

                if(xPlayer.job.name == jobName and xPlayer.job.grade == grade) then
                    xPlayer.setJob(jobName, grade)
                end
            end
        else
            notify(playerId, getLocalizedText("boss:grade_salary_not_updated"))
        end
    end)
end
RegisterNetEvent('esx_job_creator:updateGradeSalary', updateGradeSalary)

local function getJobGradesLabels(jobName, cb)
    MySQL.Async.fetchAll("SELECT grade, label FROM job_grades WHERE job_name=@jobName", {
        ['@jobName'] = jobName
    }, function(gradesLabels)
        local labels = {}

        for k, gradeData in pairs(gradesLabels) do
            labels[gradeData.grade] = gradeData.label
        end

        cb(labels)
    end)
end

function getEmployeesList(playerId, cb, markerId)
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jobName = xPlayer.job.name

    getJobGradesLabels(jobName, function(gradesLabels)
        MySQL.Async.fetchAll("SELECT identifier, firstname, lastname, job_grade FROM users WHERE job=@jobName", {
            ['@jobName'] = jobName
        }, function(employees)
            cb(employees, gradesLabels)
        end)
    end)
end

local function fireEmployee(markerId, employeeIdentifier)
    local playerId = source

    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jobName = xPlayer.job.name

    local targetPlayer = ESX.GetPlayerFromIdentifier(employeeIdentifier)

    if(targetPlayer) then
        targetPlayer.setJob(config.unemployedJob, config.unemployedGrade)
    else
        MySQL.Async.execute("UPDATE users SET job=@unemployedJob, job_grade=@unemployedGrade WHERE identifier=@identifier AND job=@currentJobName", {
            ['@unemployedJob'] = config.unemployedJob,
            ['@unemployedGrade'] = config.unemployedGrade,
            ['@identifier'] = employeeIdentifier,
            ['@currentJobName'] = jobName,
        })
    end

    notify(playerId, getLocalizedText('boss:employee_fired'))

    
    log(
        playerId, 
        getLocalizedText('log_fired_employee'),
        getLocalizedText('log_fired_employee_description', employeeIdentifier),
        'success',
        'boss'
    )
end
RegisterNetEvent('esx_job_creator:boss:fireEmployee', fireEmployee)

function getClosePlayersNames(playerId, cb, closePlayersIDs)
    local playersNames = {}

    for k, playerId in pairs(closePlayersIDs) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        
        table.insert(playersNames, {
            label = xPlayer.getName(),
            serverId = playerId
        }) 
    end

    cb(playersNames)
end

-- Finds the lowest grade starting from 0
local function findLowestGrade(jobName)
    local currentGradeNumber = 0
    while(not ESX.DoesJobExist(jobName, currentGradeNumber)) do
        currentGradeNumber = currentGradeNumber + 1

        if(currentGradeNumber > 10) then
            print("Couldn't find the lowest grade of " .. jobName)
            return false
        end
    end

    return currentGradeNumber
end

local function recruitPlayer(markerId, targetId)
    local playerId = source

    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jobName = xPlayer.job.name

    local targetPlayer = ESX.GetPlayerFromId(targetId)

    local lowestGrade = findLowestGrade(jobName)

    targetPlayer.setJob(jobName, lowestGrade)

    notify(targetId, getLocalizedText('boss:you_got_hired', xPlayer.job.label))
    notify(playerId, getLocalizedText('boss:you_hired', targetPlayer.getName()))

    local newTargetPlayer = ESX.GetPlayerFromId(targetPlayer.source)
    ESX.SavePlayer(newTargetPlayer)

    log(
        playerId, 
        getLocalizedText('log_recruited_employee'),
        getLocalizedText('log_recruited_employee_description', GetPlayerName(targetId), newTargetPlayer.identifier),
        'success',
        'boss'
    )
end
RegisterNetEvent('esx_job_creator:boss:recruitPlayer', recruitPlayer)

local function changeGradeToEmployee(markerId, employeeIdentifier, grade)
    local playerId = source

    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    local jobName = xPlayer.job.name

    local targetPlayer = ESX.GetPlayerFromIdentifier(employeeIdentifier)

    if(targetPlayer) then
        targetPlayer.setJob(jobName, grade)
        
        local newTargetPlayer = ESX.GetPlayerFromId(targetPlayer.source)

        ESX.SavePlayer(newTargetPlayer)
        
        notify(targetPlayer.source, getLocalizedText('boss:your_grade_changed_to', newTargetPlayer.job.grade_label))
    else
        MySQL.Async.execute("UPDATE users SET job_grade=@jobGrade WHERE identifier=@identifier AND job=@currentJobName", {
            ['@jobGrade'] = grade,
            ['@identifier'] = employeeIdentifier,
            ['@currentJobName'] = jobName,
        })
    end

    notify(playerId, getLocalizedText('boss:changed_grade_successfully'))

    log(
        playerId, 
        getLocalizedText('log_changed_grade_employee'),
        getLocalizedText('log_changed_grade_employee_description', employeeIdentifier, grade),
        'success',
        'boss'
    )
end
RegisterNetEvent('esx_job_creator:boss:changeGradeToEmployee', changeGradeToEmployee)

local function washMoney(markerId, amount)
    local playerId = source
    
    if(not canUseMarkerWithLog(playerId, markerId)) then return end

    local xPlayer = ESX.GetPlayerFromId(playerId)
    
    if(xPlayer.getAccount("black_money").money >= amount) then
        local bossData = fullMarkerData[markerId].data

        local returnPercentage = bossData.washMoneyReturnPercentage or 100
        local moneyGoesToSocietyAccount = bossData.washMoneyGoesToSocietyAccount

        local moneyToGive = math.floor( amount * returnPercentage / 100 )

        local hasReceivedMoney = false

        if(moneyGoesToSocietyAccount) then
            local societyName = "society_" .. xPlayer.job.name
    
            TriggerEvent('esx_addonaccount:getSharedAccount', societyName, function(account)
                if(account) then
                    account.addMoney(moneyToGive)
                    hasReceivedMoney = true
                end
            end)
        else
            xPlayer.addMoney(moneyToGive)
            hasReceivedMoney = true
        end

        if(hasReceivedMoney) then
            xPlayer.removeAccountMoney('black_money', amount)

            notify(playerId, getLocalizedText('boss:you_washed_money', ESX.Math.GroupDigits(amount), ESX.Math.GroupDigits(moneyToGive)))

            log(
                playerId, 
                getLocalizedText('log_washed_money'),
                getLocalizedText('log_washed_money_description', ESX.Math.GroupDigits(amount)),
                'success',
                'boss'
            )    
        else
            notify(playerId, getLocalizedText("boss:couldnt_wash_money"))
        end
    else
        notify(playerId, getLocalizedText("boss:not_enough_dirty_money"))
    end
end
RegisterNetEvent('esx_job_creator:washMoney', washMoney)