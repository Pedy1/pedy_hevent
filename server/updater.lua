local curVersion = GetResourceMetadata(GetCurrentResourceName(), "version")
local resourceName = "pedy_hevent"

if Config.checkForUpdates then
    CreateThread(function()
        if GetCurrentResourceName() ~= "pedy_hevent" then
            resourceName = "pedy_hevent (" .. GetCurrentResourceName() .. ")"
        end
    end)

    CreateThread(function()
        while true do
            PerformHttpRequest("https://api.github.com/repos/Pedy1/pedy_hevent/releases/latest", CheckVersion, "GET")
            Wait(3600000)
        end
    end)

    CheckVersion = function(err, responseText, headers)
        local repoVersion, repoURL, repoBody = GetRepoInformations()

        CreateThread(function()
            if curVersion ~= repoVersion then
                Wait(4000)
                print("^0[^3WARNING^0] " .. resourceName .. " a ^1NEM ^0naprakész!")
                print("^0[^3WARNING^0] Az Ön verziója: ^2" .. curVersion .. "^0")
                print("^0[^3WARNING^0] Legújabb verzió: ^2" .. repoVersion .. "^0")
                print("^0[^3WARNING^0] Szerezd meg a legújabb verziót innen: ^2" .. repoURL .. "^0")
                print("^0[^3WARNING^0] Változási napló:^0")
                print("^1" .. repoBody .. "^0")
            else
                Wait(4000)
                print("^0[^2INFO^0] " .. resourceName .. " naprakész! (^2" .. curVersion .. "^0)")
            end
        end)
    end

    GetRepoInformations = function()
        local repoVersion, repoURL, repoBody = nil, nil, nil

        PerformHttpRequest("https://api.github.com/repos/Pedy1/pedy_hevent/releases/latest", function(err, response, headers)
            if err == 200 then
                local data = json.decode(response)

                repoVersion = data.tag_name
                repoURL = data.html_url
                repoBody = data.body
            else
                repoVersion = curVersion
                repoURL = "https://github.com/Pedy1/pedy_hevent"
            end
        end, "GET")

        repeat
            Wait(50)
        until (repoVersion and repoURL and repoBody)

        return repoVersion, repoURL, repoBody
    end
end
