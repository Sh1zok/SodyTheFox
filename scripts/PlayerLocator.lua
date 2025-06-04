local isHeadIsPlayerLocator = false -- Переменная опрделяющая является ли отображаемая голова локатором игроков
local oldPlayernames = {}
models.playerLocator:setVisible(false)

-- Некоторые части модели должны светиться
models.playerLocator.case.counter:setPrimaryRenderType("EMISSIVE_SOLID")
models.playerLocator.case.screen:setPrimaryRenderType("EMISSIVE_SOLID")
models.playerLocator.case.playerCounter:setPrimaryRenderType("EMISSIVE_SOLID")

function events.entity_init() -- Создаём текст
    playerCounterText = models.playerLocator.case.playerCounter
        :newText("counter")
        :setScale(0.25)
        :setAlignment("center")
        :setOutline(true)
        :setOutlineColor(0.75, 0.75, 0)
end

function listNicknames() -- Возвращает список игроков в пределах прогрузки
    local list = {}
    local index = 1

    for _, player in pairs(world:getPlayers()) do
        list[index] = player:getName()
        index = index + 1
    end

    return list
end

function listDifferenceInArrays(array1, array2)
    local exists = {}
    local difference = {}

    for _, name in ipairs(array2) do
        exists[name] = true
    end

    for _, name in ipairs(array1) do
        if not exists[name] then
            table.insert(difference, name)
        end
    end

    return difference
end

function events.skull_render(_, _, item, entity, mode) -- Ивент рендера головы
    playernames = listNicknames()
    local viewmode
    if mode ~= "BLOCK" and mode ~= "HEAD" then isHeadIsPlayerLocator = (string.lower(item:getName()) == "player locator") else isHeadIsPlayerLocator = false end -- Определение является ли голова локатором
    models.playerLocator:setVisible(isHeadIsPlayerLocator) -- Модель локатора делается видимой только если голова является локатором

    if isHeadIsPlayerLocator then -- Если голова это локатор который держат в руках
        if playerCounterText then playerCounterText:setText(#playernames) end -- Задаём текст счётчику

        models.playerLocator:setParentType("SKULL") -- Модель опрделяется как череп игрока

        -- Положение модели в руках игрока
        if entity ~= nil then
            if mode == "FIRST_PERSON_RIGHT_HAND" and entity ~= nil then
                models.playerLocator:setPos(-2, 6.75, 1)
                models.playerLocator:setRot(30, -15, 0)
                models.playerLocator:setScale(1)
                viewmode = "FIRST_PERSON"
            elseif mode == "FIRST_PERSON_LEFT_HAND" and entity ~= nil then
                models.playerLocator:setPos(2, 6.75, 1)
                models.playerLocator:setRot(30, 15, 0)
                models.playerLocator:setScale(1)
                viewmode = "FIRST_PERSON"
            elseif mode == "THIRD_PERSON_RIGHT_HAND" and entity ~= nil then
                models.playerLocator:setPos(4, 6, -4)
                models.playerLocator:setRot(45, -45, 0)
                models.playerLocator:setScale(1.5)
                viewmode = "THIRD_PERSON"
            elseif mode == "THIRD_PERSON_LEFT_HAND" and entity ~= nil then
                models.playerLocator:setPos(-4, 6, -4)
                models.playerLocator:setRot(45, 45, 0)
                models.playerLocator:setScale(1.5)
                viewmode = "THIRD_PERSON"
            end
        else
            models.playerLocator:setPos(0, 0, 0)
            models.playerLocator:setRot(0, 0, 0)
            models.playerLocator:setScale(1)
        end

        if entity ~= nil then -- Если это убрать то код будет выполняться даже если локатор не в руках
            -- Определение количества меток
            if #playernames > #oldPlayernames then -- Нужно добавить метки
                for _, name in ipairs(listDifferenceInArrays(playernames, oldPlayernames)) do
                    models.playerLocator.playerPointers:addChild(models.playerLocator.playerPointers.pointerExample:copy(name))
                end

                oldPlayernames = playernames
            else -- Нужно убрать метки
                for _, name in ipairs(listDifferenceInArrays(oldPlayernames, playernames)) do
                    for _, modelPart in ipairs(models.playerLocator.playerPointers:getChildren()) do if modelPart:getName() == name then modelPart:remove() end end
                end

                oldPlayernames = playernames
            end


            for _, modelPart in ipairs(models.playerLocator.playerPointers:getChildren()) do -- Задаём меткам расположение
                if modelPart:getName() ~= "pointerExample" and world:getPlayers()[modelPart:getName()] and entity then
                    local playerPos = world:getPlayers()[modelPart:getName()]:getPos()
                    local entityPos = entity:getPos()
                    local playerRelativePos = playerPos - entityPos
                    local distantion = math.sqrt(playerRelativePos.x ^ 2 + playerRelativePos.z ^ 2)

                    if viewmode == "FIRST_PERSON" then
                        entityRot = entity:getRot()[2] - 90
                    else
                        entityRot = entity:getBodyYaw() - 90
                    end

                    if playerRelativePos[3] > 0 then
                        angle = math.deg(math.acos(playerRelativePos[1] / distantion)) - entityRot
                    else
                        angle = -math.deg(math.acos(playerRelativePos[1] / distantion)) - entityRot
                    end

                    local pointerX = distantion / 64 * math.sin(math.rad(angle))
                    local pointerY = -distantion / 64 * math.cos(math.rad(angle))
                    if pointerX > 4 then pointerX = 4 elseif pointerX < -4 then pointerX = -4 end
                    if pointerY > 4 then pointerY = 4 elseif pointerY < -4 then pointerY = -4 end

                    modelPart:setPos(pointerX, pointerY, 0)
                end
            end
        end


    else -- Если голова не локатор то она определяется как модель в мире
        models.playerLocator:setParentType("WORLD")
    end
end
