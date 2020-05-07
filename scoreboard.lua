local CFG = exports['fq_essentials']:getCFG()
local mCFG = CFG.menu
local gCFG = CFG.gangs

local listOn = false
local playersMoney = nil
local playersStats = nil
local playersGangs = nil

RegisterNetEvent('fq:getStatInfo')
AddEventHandler('fq:getStatInfo', function(money, stats)
    playersMoney = money
    playersStats = stats
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        playersGangs = exports['fq_gangs']:getG()
    end
end)

Citizen.CreateThread(function()
    listOn = false
    while true do
        Wait(0)

        if IsControlPressed(0, 27)--[[ INPUT_PHONE ]] then
            if not listOn then
                local players = {}
                for _, i in ipairs(GetActivePlayers()) do
                    local old_i = i 
                    i = GetPlayerServerId(i)
                    
                    if playersMoney[i] and playersGangs.players[i] then
                        local gangFirstLetter = gCFG[playersGangs.players[i]].name:sub(1,1)
                        local money = playersMoney[i]
                        local kills, deaths = playersStats[i][1], playersStats[i][2]
                        local time = playersStats[i][3]
                        local r, g, b = table.unpack(gCFG[playersGangs.players[i]].rgbColor)
                        local isMe = old_i == PlayerId() and 'font-weight:bold;' or ''

                        table.insert(players, 
                        '<tr style=\"color: rgb(' .. r .. ', ' .. g .. ', ' .. b .. ');'..isMe..'\"><td>' .. old_i .. '</td><td>' .. sanitize(GetPlayerName(old_i)) ..
                         ' [' .. gangFirstLetter .. ']</td><td>' .. kills .. '</td><td>'.. deaths ..'</td><td>$'.. money .. '</td><td>'.. time ..'m</td></tr>'
                        )
                    end
                end
                
                local tmp = getTmpStats()
                local t_kills, t_deaths, t_time = getSortIndex(tmp, 1), getSortIndex(tmp, 2), getSortIndex(tmp, 3)
                
                SendNUIMessage({
                    text = table.concat(players),
                    tKills = getHTMLString(t_kills),
                    tDeaths = getHTMLString(t_deaths),
                    tTime = getHTMLString(t_time) 
                }) 
                print(getHTMLString(t_kills))

                listOn = true
                while listOn do
                    Wait(0)
                    if IsControlPressed(0, 174) then
                        SendNUIMessage({
                            meta = 'move',
                            direction = 'top'
                        })
                    end
                    if IsControlPressed(0, 175) then
                        SendNUIMessage({
                            meta = 'move',
                            direction = 'down'
                        })
                    end
                    if(IsControlPressed(0, 27) == false) then
                        listOn = false
                        SendNUIMessage({
                            meta = 'close'
                        })
                        break
                    end
                end
            end
        end
    end
end)

function sanitize(txt)
    local replacements = {
        ['&' ] = '&amp;', 
        ['<' ] = '&lt;', 
        ['>' ] = '&gt;', 
        ['\n'] = '<br/>'
    }
    return txt
        :gsub('[&<>\n]', replacements)
        :gsub(' +', function(s) return ' '..('&nbsp;'):rep(#s-1) end)
end

function getHTMLString(tab)
    local html = ''

    for i, v in ipairs(tab) do 
        html = html .. '<tr><th>'..i..'</th><th>'..v.name..'</th><th>'..v.value..'</th></tr>'
    end

    return html
end

function getSortIndex(tab, index, num)
    local sortedTab = {}
    num = num or 3

    table.sort(tab, function(a,b) return a[index] > b[index] end)

    local tabSizeLimit = #tab >= num and num or #tab
    
    for i = 1, tabSizeLimit do 
        table.insert(sortedTab, {name=tab[i][4], value=tab[i][index]})
    end

    return sortedTab
end

function getTmpStats()
    local tmp = {}

    for k, v in pairs(playersStats) do 
        local i = GetPlayerServerId(k)
        table.insert(tmp, {v[1], v[2], v[3], sanitize(GetPlayerName(i))})    
    end

    return tmp
end