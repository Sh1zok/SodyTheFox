nameplate.Entity:setPos(0, -0.25, 0) -- Высота панели никнейма
nameplate.Entity:setOutline(true) -- Обводка никнейма
nameplate.Entity:setOutlineColor(1, 0.75, 0) -- Цвет обводки
nameplate.Entity:setBackgroundColor(0, 0, 0, 0) -- Фон никнейма

function pings.setNameplate(statusBadges) -- Пинг установки никнейма
    if player:isLoaded() then nameplate.ALL:setText(
        toJson({
            text = statusBadges .. player:getName(), -- Бейджи статуса, никнейм игрока
            ["hoverEvent"] = { -- Реализация показа текста при наведении на никнейм в чате(или другом месте)
                ["action"] = "show_text",
                ["contents"] = {
                    {text = "Oh! Looks like"}, {text = " §lSh1zok", color = "#00FFFF"}, {text = " is here!\n"},
                    {text = "§b§lPronouns: §f§lHe / §l§mtler§f§lHim\n"},
                    {text = "\n"},
                    {text = "§dAnother internet schiz.\nGoofing on the internet with\nno idea what I'm doing.\n"},
                    {text = "\n"},
                    {text = "§lDiscord:§f ", color = "#5662F6"}, {text = "@sh1zok_was_here\n"},
                    {text = "§lGit", color = "#F0F6FC"}, {text = "§lHub: ", color = "#394963"}, {text = "Sh1zok"}
                },
            },
        })
    ) end
end

function events.render()
    local hostPos = player:getPos() -- Позиция хоста
    local viewerPos = client:getViewer():getPos() -- Позиция наблюдающего
    local distance = math.sqrt((hostPos - viewerPos).x ^ 2 + (hostPos - viewerPos).y ^ 2 + (hostPos - viewerPos).z ^ 2) -- Дистанция между хостом и наблюдающим

    -- Вычисление размера именной таблички
    local nameplateScale = 1 - distance / 5
    if nameplateScale < 0 then nameplateScale = 0 end

    nameplate.Entity:setScale(nameplateScale) -- Задание размера именной таблички
end

if not host:isHost() then return end -- Дальше инструкции только для хоста
oldHostStatus = "" -- Статус хоста в прошлом тике

function events.tick()
    local hostStatus = "" -- Статус хоста в нынешнем тике

    if host:isChatOpen() then hostStatus = hostStatus .. ":typing: " end -- Значок чата
    if not client:isWindowFocused() then hostStatus = hostStatus .. ":zzz: " end -- Значок афк
    if host:isContainerOpen() then hostStatus = hostStatus .. ":open_folder_paper: " end -- Значок инвентаря/сундука
    if isMicWorking then hostStatus = hostStatus .. ":speak: " end -- Значок разговора

    if hostStatus ~= oldHostStatus then -- Оптимизированный пинг
        pings.setNameplate(hostStatus) -- Задание бейджей
        oldHostStatus = hostStatus
    end
end
