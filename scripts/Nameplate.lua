nameplate.Entity:setPos(0, -0.3, 0) -- Высота панели никнейма
nameplate.Entity:setBackgroundColor(0, 0, 0, 0) -- Фон никнейма

-- Изменение размера именной таблички в зависимости от расстояния между хостом и третьим лицом
function events.render()
    local hostPos = player:getPos() -- Позиция хоста
    local viewerPos = client:getViewer():getPos() -- Позиция наблюдающего
    local distance = math.sqrt((hostPos - viewerPos).x ^ 2 + (hostPos - viewerPos).y ^ 2 + (hostPos - viewerPos).z ^ 2) -- Дистанция между хостом и наблюдающим

    -- Вычисление размера именной таблички
    local nameplateScale = 1 - distance / 5
    if nameplateScale < 0 then nameplateScale = 0 end

    nameplate.Entity:setScale(nameplateScale) -- Задание размера именной таблички
end

function pings.setNameplate(statusBadges) -- Пинг установки никнейма
    if player:isLoaded() then nameplate.ALL:setText(
        toJson({
            text = statusBadges .. "§6" .. player:getName(), -- Бейджи статуса, никнейм игрока
            ["hoverEvent"] = { -- Реализация показа текста при наведении на никнейм в чате(или другом месте)
                ["action"] = "show_text",
                ["contents"] = {
                    {text = "Avatar name: " .. avatar:getName() .. "\n"},
                    {text = "Avatar author: §bSh1zok\n"},
                    {text = "\n"},
                    {text = "§6This is a tricky and cute fox :3\n"},
                    {text = "\n"},
                    {text = "Author credits:\n"},
                    {text = "§lDiscord:§f ", color = "#5662F6"}, {text = "@sh1zok_was_here\n"},
                    {text = "§lGit", color = "#F0F6FC"}, {text = "§lHub: ", color = "#394963"}, {text = "Sh1zok"}
                },
            },
        })
    ) end
end

if not host:isHost() then return end -- Дальше инструкции только для хоста
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
