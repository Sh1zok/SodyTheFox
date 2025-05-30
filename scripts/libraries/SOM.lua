--[[
    ■■■■■
    ■   ■ Sh1zok's Outfits Manager
    ■■■■  v2.2
]]--

--[[
    Non-host side
]]--
outfitModelParts = {} -- Список частей модели что являются частью наряда
outfitsList = {} -- Список нарядов
currentOutfit = 1 -- Текущий наряд

function pings.setOutfit(outfit, isSoundNeeded)
    if not outfit then outfit = 1 end -- Если в функцию передан nil то nil заменяется на 1

    -- Задаём текстуру наряда
    for _, value in ipairs(outfitModelParts) do value:setPrimaryTexture("Custom", textures[outfitsList[outfit][2]]) end

    -- Задаём текстуру и высоту шляпы. Задаём видимость второго слоя головы
    if hatModelPart and outfitsList[outfit][6] then hatModelPart:setPrimaryTexture("Custom", textures[outfitsList[outfit][6]]) end
    if hatModelPart then hatModelPart:setPos(0, outfitsList[outfit][4], 0) end
    if headSecondLayerModelPart then headSecondLayerModelPart:setScale(outfitsList[outfit][5]) end

    -- Звук переодевания
    if isSoundNeeded and player:isLoaded() then sounds:playSound("block.wool.break", player:getPos(), 0.25, 1, false) end
end

--[[
    Host-only side
]]--
if host:isHost() then
    local ticksBeforeSync = 10 -- Отсчёт до синхронизации наряда

    -- Отсчёт до синхронизации наряда
    function events.tick()
        ticksBeforeSync = ticksBeforeSync - 1
        if ticksBeforeSync <= 0 then
            ticksBeforeSync = 200

            currentOutfit = config:load("SOM_outfit") or 1
            pings.setOutfit(currentOutfit, false)
        end
    end

    -- Функция формирующая титул кнопки
    function updateOutfitButtonTitle()
        -- Название кнопки и её описание
        local title = (outfitButtonTitle or "Наряд") .. ": " .. outfitsList[currentOutfit][1] .. "\n §7" .. (outfitButtonDescription or "Прокручивание вниз: Следующий наряд\n Прокручивание вверх: Предыдущий наряд\n\n Список нарядов:\n")

        -- Список нарядов
        for index, value in ipairs(outfitsList) do
            if index == currentOutfit then -- Выделение выбранного наряда акцентным цветом
                title = title .. "\n " .. (outfitButtonAccentColor or "§f") .. value[1]
            else -- Остальные более тусклым
                title = title .. "\n " .. (outfitButtonCommonColor or "§8") .. value[1]
            end
        end

        return(title) -- Возвращаем готовый титул кнопки
    end

    -- Функция возвращающая текстуру кнопки
    function updateOutfitButtonTexture()
        return(textures[outfitsList[currentOutfit][3]])
    end

    -- Функция для выбора наряда
    function outfitButtonSelect(dir)
        if dir < 0 then -- При прокручивании вверх
            if currentOutfit ~= #outfitsList then
                currentOutfit = currentOutfit + 1
            else -- Переход в конец списка если выбор в начале списка
                currentOutfit = 1
            end
        else -- При прокручивании вниз
            if currentOutfit ~= 1 then
                currentOutfit = currentOutfit - 1
            else -- Переход в начало списка если выбор в конце списка
                currentOutfit = #outfitsList
            end
        end

        config:save("SOM_outfit", currentOutfit)
        pings.setOutfit(currentOutfit, true)
    end
end
