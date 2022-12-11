local function sortBossOptions(a, b)
    return a.index < b.index
end

local function manageGrades(markerId)
    ESX.TriggerServerCallback('esx_job_creator:boss:getJobGrades', function(jobGradesSalaries)
        local elements = {}

        for k, gradeData in pairs(jobGradesSalaries) do
            table.insert(elements, {
                label = getLocalizedText('boss:rank_salary', gradeData.label, ESX.Math.GroupDigits(gradeData.salary)),
                gradeId = gradeData.id,
                grade = gradeData.grade
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_menu_grades', {
            title = getLocalizedText("boss_menu"),
            align = 'bottom-right',
            elements = elements
        }, 
        function(data, menu) 
            local gradeId = data.current.gradeId
            local grade = data.current.grade

            if(gradeId) then
                askQuantity(getLocalizedText('boss:new_salary'), "boss_grade_salary", 0, nil, function(quantity)
                    if(quantity) then
                        TriggerServerEvent('esx_job_creator:updateGradeSalary', markerId, gradeId, grade, quantity)
                        menu.close()
                    end
                end)
            end
        end,
        function(data, menu)
            menu.close()
        end)
    end, markerId)
end

local function fireEmployee(markerId, identifier)
    local elements = {
        {label = getLocalizedText('boss:cancel'), value = "no"},
        {label = getLocalizedText('boss:fire'), value = "yes"},
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_menu_employee_fire', {
        title = getLocalizedText("boss:are_you_sure"),
        align = 'bottom-right',
        elements = elements
    }, 
    function(data, menu) 
        local action = data.current.value

        if(action == "yes") then
            TriggerServerEvent('esx_job_creator:boss:fireEmployee', markerId, identifier)
        end

        openBoss(markerId)
    end,
    function(data, menu)
        menu.close()
    end)
end

local function changeGrade(markerId, identifier)
    local jobName = ESX.GetPlayerData().job.name

    ESX.TriggerServerCallback('esx_job_creator:retrieveJobRanks', function(grades) 
        local elements = {}

        for k, gradeData in pairs(grades) do
            table.insert(elements, {
                label = getLocalizedText('boss:grade', gradeData.grade, gradeData.label, ESX.Math.GroupDigits(gradeData.salary)),
                grade = gradeData.grade
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_menu_employee_change_grade', {
            title = getLocalizedText("boss_menu"),
            align = 'bottom-right',
            elements = elements
        }, 
        function(data, menu) 
            local grade = data.current.grade
    
            if(grade) then
                TriggerServerEvent('esx_job_creator:boss:changeGradeToEmployee', markerId, identifier, grade)
            end
    
            menu.close()
        end,
        function(data, menu)
            menu.close()
        end)
    end, jobName)
end

function manageEmployee(markerId, identifier)
    local elements = {
        {label = getLocalizedText('boss:change_grade'), value = "change_grade"},
        {label = getLocalizedText('boss:fire'), value = "fire"}
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_menu_employee_management', {
        title = getLocalizedText("boss_menu"),
        align = 'bottom-right',
        elements = elements
    }, 
    function(data, menu) 
        local action = data.current.value

        if(action == "change_grade") then
            changeGrade(markerId, identifier)
        elseif(action == "fire") then
            fireEmployee(markerId, identifier)
        end
    end,
    function(data, menu)
        menu.close()
    end)
end

local function openEmployeesManagement(markerId)
    ESX.TriggerServerCallback('esx_job_creator:boss:getEmployeesList', function(employees, gradesLabels) 
        local elements = {}

        for k, employeeData in pairs(employees) do
            table.insert(elements, {
                label = getLocalizedText('boss:employee', employeeData.firstname, employeeData.lastname, gradesLabels[employeeData.job_grade]),
                value = employeeData.identifier
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_menu_employees_management', {
            title = getLocalizedText("boss_menu"),
            align = 'bottom-right',
            elements = elements
        }, 
        function(data, menu) 
            local targetIdentifier = data.current.value
    
            manageEmployee(markerId, targetIdentifier)
        end,
        function(data, menu)
            menu.close()
        end)
    end, markerId)
end

local function openRecruit(markerId)
    local plyPed = PlayerPedId()
    local plyCoords = GetEntityCoords(plyPed)

    local players = ESX.Game.GetPlayersInArea(plyCoords, 10.0)

    local closePlayersIDs = {}

    for k, player in pairs(players) do
        table.insert(closePlayersIDs, GetPlayerServerId(player))
    end

    ESX.TriggerServerCallback('esx_job_creator:boss:getClosePlayersNames', function(closePlayersNames)
        if(#closePlayersNames == 0) then
            table.insert(closePlayersNames, {
                label = getLocalizedText('boss:nobody_close')
            }) 
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_menu_employees_recruit', {
            title = getLocalizedText("boss_menu"),
            align = 'bottom-right',
            elements = closePlayersNames
        }, 
        function(data, menu) 
            local playerId = data.current.serverId
    
            if(playerId) then
                TriggerServerEvent('esx_job_creator:boss:recruitPlayer', markerId, playerId)
                menu.close()
            end
        end,
        function(data, menu)
            menu.close()
        end)
    end, closePlayersIDs)
end

local function manageEmployees(markerId)
    local elements = {
        {label = getLocalizedText('boss:employees_list'), value = "employees"},
        {label = getLocalizedText('boss:recruit'), value = "recruit"},
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_menu_employees', {
        title = getLocalizedText("boss_menu"),
        align = 'bottom-right',
        elements = elements
    }, 
    function(data, menu) 
        local action = data.current.value

        if(action == "employees") then
            openEmployeesManagement(markerId)
        elseif(action == "recruit") then
            openRecruit(markerId)
        end
    end,
    function(data, menu)
        menu.close()
    end)
end

function openBoss(markerId)
    ESX.UI.Menu.CloseAll()

    ESX.TriggerServerCallback('esx_job_creator:getBossData', function(bossOptions, jobMoney)
        local availableOptions = {
            ["withdraw"] = {label = getLocalizedText('boss:withdraw'), value = "withdraw", index = 1},
            ["deposit"] = {label = getLocalizedText('boss:deposit'), value = "deposit", index = 2},
            ["wash"] = {label = getLocalizedText('boss:wash_money'), value = "wash", index = 5},
            ["grades"] = {label = getLocalizedText('boss:grades'), value = "grades", index = 3},
            ["employees"] = {label = getLocalizedText('boss:employees'), value = "employees", index = 4},
        }
        
        local elements = {}

        for optionName, isAllowed in pairs(bossOptions) do
            if(isAllowed) then
                table.insert(elements, availableOptions[optionName])
            end
        end

        table.sort(elements, sortBossOptions)

        table.insert(elements, 1, {
            label = getLocalizedText('boss:society_money', ESX.Math.GroupDigits(jobMoney))
        })

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'boss_menu', {
            title = getLocalizedText("boss_menu"),
            align = 'bottom-right',
            elements = elements
        }, 
        function(data, menu) 
            local action = data.current.value

            if(action == "withdraw") then
                askQuantity(getLocalizedText("boss:withdraw_amount"), "boss_withdraw", 1, nil, function(quantity)
                    if(quantity) then
                        TriggerServerEvent('esx_job_creator:withdrawSocietyMoney', markerId, quantity)
                        openBoss(markerId)
                    end
                end)
            elseif(action == "deposit") then
                askQuantity(getLocalizedText("boss:deposit_amount"), "boss_deposit", 1, nil, function(quantity)
                    if(quantity) then
                        TriggerServerEvent('esx_job_creator:depositSocietyMoney', markerId, quantity)
                        openBoss(markerId)
                    end
                end)
            elseif(action == "grades") then
                manageGrades(markerId)
            elseif(action == "employees") then
                manageEmployees(markerId)
            elseif(action == "wash") then
                askQuantity(getLocalizedText("boss:how_much_to_wash"), "boss_washmoney", 1, nil, function(quantity)
                    if(quantity) then
                        TriggerServerEvent('esx_job_creator:washMoney', markerId, quantity)
                    end
                end)
            end
        end,
        function(data, menu)
            openedMenu = nil
            menu.close()
        end)
    end, markerId)
end