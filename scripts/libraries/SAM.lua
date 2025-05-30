--[[
    ■■■■■
    ■   ■ Sh1zok's Actions Manager
    ■■■■  v3.1
]]--

SAM = {}

--[[
    Сторона наблюдателя
]]--
SAM.incompatibleAnimations = {} -- Список анимаций несовместимых с действиями
SAM.actions = {} -- Список действий
SAM.actions.groups = {} -- Список групп действий
SAM.activeActions = {} -- Активное действие

-- GSAnimBlend
SAM.GSAnimBlendIsHere = false
SAM.blendTime = 7.5
for _, key in ipairs(listFiles(nil,true)) do
    if key:find("GSAnimBlend$") then
        SAM.GSAnimBlendIsHere = true
        break
    end
end

-- Функция для остоновки действий одной группы
function SAM:stopActionsIn(actionsGroupName)
    for _, action in ipairs(SAM.actions[actionsGroupName]) do
        if action[2] ~= nil then
            action[2]:stop()
        end
    end

    SAM.activeActions[actionsGroupName] = nil
end

-- Проверка несовместимых анимаций каждый тик
events.TICK:register(function()
    for _, actionGroupName in ipairs(SAM.actions.groups) do
        if SAM.activeActions[actionGroupName] then
            for _, incAnimsGroupName in ipairs(SAM.activeActions[actionGroupName][4]) do
                for _, incAnim in ipairs(SAM.incompatibleAnimations[incAnimsGroupName]) do
                    if incAnim:isPlaying() then SAM:stopActionsIn(actionGroupName) end
                end
            end
        end
    end
end, "SAM_checkForIncompatibleAnimations")

-- Пинг проигрывающий действие
function pings.SAM_playActionFrom(actionGroupName, actionIndex)
    SAM:stopActionsIn(actionGroupName) -- Остановка всех действий

    SAM.activeActions[actionGroupName] = SAM.actions[actionGroupName][actionIndex] -- Выбор активного действия

    if SAM.activeActions[actionGroupName][2] ~= nil then
        SAM.activeActions[actionGroupName][2]:setBlendTime(SAM.blendTime):setPriority(SAM.activeActions[actionGroupName][3]):play() -- Проигрывание активного действия
    end
end

-- Пинг останавливающий действие из группы
function pings.SAM_stopActionIn(actionGroupName)
    SAM:stopActionsIn(actionGroupName)
end

-- Пинг останавливающий все действия
function pings.SAM_stopAllActions()
    for _, groupName in ipairs(SAM.actions.groups) do SAM:stopActionsIn(groupName) end
end

if not host:isHost() then return SAM end

--[[
    Сторона хоста
]]--
SAM.selectedActionsIndexes = {}

function SAM:buttonScroll(scrollDirection, groupName)
    -- Определяем новый индекс выбранного действия
        if scrollDirection < 0 then -- При прокручивании вверх
            if SAM.selectedActionsIndexes[groupName] ~= #SAM.actions[groupName] then SAM.selectedActionsIndexes[groupName] = SAM.selectedActionsIndexes[groupName] + 1 else SAM.selectedActionsIndexes[groupName] = 1 end
        else -- При прокручивании вниз
            if SAM.selectedActionsIndexes[groupName] ~= 1 then SAM.selectedActionsIndexes[groupName] = SAM.selectedActionsIndexes[groupName] - 1 else SAM.selectedActionsIndexes[groupName] = #SAM.actions[groupName] end
        end
end

function SAM:updateButtonTitle(buttonName, description, listSize, listColor, selectColor, groupName)
    if not SAM.selectedActionsIndexes[groupName] then SAM.selectedActionsIndexes[groupName] = 1 end

    local newButtonTitle = buttonName .. description -- Шапка нового титула

    -- Определение нижнего и вернего индекса сокращённого списка
    local topIndex = SAM.selectedActionsIndexes[groupName] - math.floor(listSize / 2)
    local bottomIndex = SAM.selectedActionsIndexes[groupName] + math.floor(listSize / 2)
    if topIndex < 1 then
        topIndex = 1
        bottomIndex = listSize
    end
    if bottomIndex > #SAM.actions[groupName] then
        bottomIndex = bottomIndex - (bottomIndex - #SAM.actions[groupName]) + 1
        topIndex = bottomIndex - listSize
    end

    -- Добавление списка
    for index, value in ipairs(SAM.actions[groupName]) do
        if index >= topIndex and index <= bottomIndex then
            if index == SAM.selectedActionsIndexes[groupName]
                then newButtonTitle = newButtonTitle .. "\n " .. selectColor .. index .. ". " .. value[1]
                else newButtonTitle = newButtonTitle .. "\n " .. listColor .. index .. ". " .. value[1]
            end
        end
    end

    return newButtonTitle
end

return SAM
