local function deleteUnusedRanks()
    MySQL.Async.fetchAll("SELECT name FROM jobs", {}, function(jobsData)
        local jobs = {}

        for k, job in pairs(jobsData) do
            jobs[job.name] = true
        end

        local msg = "[^6%s^7] ^1Job '^3%s^1' not found for grade ID %d (%s - %s). It will be deleted^7"

        MySQL.Async.fetchAll("SELECT id, job_name, grade, name, label FROM job_grades", {}, function(grades)
            for k, gradeData in pairs(grades) do
                if(not jobs[gradeData.job_name]) then
                    
                    print(format(msg, GetCurrentResourceName(), gradeData.job_name, gradeData.id, gradeData.name, gradeData.label))

                    MySQL.Async.execute('DELETE FROM job_grades WHERE id=@id', {
                        ['@id'] = gradeData.id
                    })
                end
            end
        end)
    end)
end

function setupDatabase()
    local resName = GetCurrentResourceName()

    if(resName ~= "esx_job_creator") then
        print("It would be appreciated using ^5esx_job_creator^7 as name of the resource")
    end

    deleteUnusedRanks()
    
    local scriptVersion = GetResourceMetadata(resName, 'version', 0)

    local sqlPath = "sql/%s.sql"

    local sqlContent = LoadResourceFile(resName, format(sqlPath, scriptVersion))

    if(sqlContent) then
        MySQL.Async.execute(sqlContent, {}, function()
            TriggerEvent('esx_job_creator:database:ready')
        end)
    else
        TriggerEvent('esx_job_creator:database:ready')
    end
end
Citizen.CreateThread(function() 
    setupDatabase()
end)