--[[
    ■■■■■ Sh1zok's Actions Manager
    ■   ■ Author: @sh1zok_was_here
    ■■■■  v3.4
]]--

SAM = {}

--[[
    Non-host side
]]--
SAM.incompatibleProvisions = {} -- List of provisions that are not compatible with animations
SAM.actions = {} -- Actions list
SAM.actions.groups = {} -- Action groups enum
SAM.activeActions = {} -- Active actions list

-- GSAnimBlend integration
SAM.GSAnimBlendIsHere = false
SAM.blendTime = 7.5
for _, key in ipairs(listFiles(nil, true)) do
    if key:find("GSAnimBlend$") then
        SAM.GSAnimBlendIsHere = true
        break
    end
end

-- Function to stop the actions of one group
function SAM:stopActionsIn(actionsGroupName)
    if SAM.actions[actionsGroupName] == nil then error("Actions group with this name(" .. actionsGroupName .. ") does not exist") end

    for _, action in ipairs(SAM.actions[actionsGroupName]) do
        if action[2] ~= nil then
            if type(action[2]) ~= "Animation" then error("Expected animation, got" .. type(action[2])) end
            action[2]:stop()
        end
    end

    SAM.activeActions[actionsGroupName] = nil
end

-- Check for true incompatible Provisions
events.TICK:register(function()
    for _, actionGroupName in ipairs(SAM.actions.groups) do -- Take the names of the groups from SAM.actions.groups
        if SAM.activeActions[actionGroupName] then -- If there is an active action from this group
            for _, incProvisionName in ipairs(SAM.activeActions[actionGroupName][4]) do -- For each group of incompatible Provisions
                if SAM.incompatibleProvisions[incProvisionName] then -- If the Provision exists
                    if SAM.incompatibleProvisions[incProvisionName]() then SAM:stopActionsIn(actionGroupName) end -- If the Provision is true, stop the action
                end
            end
        end
    end
end, "SAM_checkForIncompatibleProvisions")

-- Ping that plays the action. Good for button:onLeftClick() event and keybinds
-- Ex1: button:onLeftClick(function() pings.SAM_playActionFrom("Arms", SAM.selectedActionsIndexes["Arms"]) end) -- Plays SELECTED VIA BUTTON action
-- Ex2: button:onLeftClick(function() pings.SAM_playActionFrom("Arms", 3) end) -- Plays action from group called "Arms" with index of 3. Good for keybinds
function pings.SAM_playActionFrom(actionsGroupName, actionIndex)
    if SAM.actions[actionsGroupName] == nil then error("Actions group with this name(" .. actionsGroupName .. ") does not exist") end

    SAM:stopActionsIn(actionsGroupName) -- Stops all actions from the received group

    if SAM.actions[actionsGroupName][actionIndex] == nil then error("Action with this index does not exist in this group") end
    SAM.activeActions[actionsGroupName] = SAM.actions[actionsGroupName][actionIndex]


    if SAM.activeActions[actionsGroupName][2] ~= nil then
        if type(SAM.activeActions[actionsGroupName][2]) ~= "Animation" then error("Expected animation, got" .. type(SAM.activeActions[actionsGroupName][2])) end
        SAM.activeActions[actionsGroupName][2]:setBlendTime(SAM.blendTime):setPriority(SAM.activeActions[actionsGroupName][3]):play() -- Проигрывание активного действия
    end
end

-- Ping that stops the action. Good for button:onRightClick() event
-- Ex. button:onRightClick(function() pings.SAM_stopActionIn("Arms") end)
function pings.SAM_stopActionIn(actionsGroupName)
    if SAM.actions[actionsGroupName] == nil then error("Actions group with this name(" .. actionsGroupName .. ") does not exist") end
    SAM:stopActionsIn(actionsGroupName)
end

-- Ping that stops ALL actions from ALL groups. Good for keybind
function pings.SAM_stopAllActions()
    for _, groupName in ipairs(SAM.actions.groups) do SAM:stopActionsIn(groupName) end
end

if not host:isHost() then return SAM end

--[[
    Host side
]]--
SAM.selectedActionsIndexes = {} -- Stores index of selected action for each group

-- Define a new selected action when scrolling on a button. Good for button:onScroll() event.
-- Ex: button:onScroll(function(direction) SAM:buttonScroll(direction, "Arms") end)
function SAM:buttonScroll(scrollDirection, groupName)
    if SAM.actions[groupName] == nil then error("Actions group with this name(" .. groupName .. ") does not exist") end

    -- Define a new index of the selected action
    if scrollDirection < 0 then -- When user scrolling up
        if SAM.selectedActionsIndexes[groupName] ~= #SAM.actions[groupName] then SAM.selectedActionsIndexes[groupName] = SAM.selectedActionsIndexes[groupName] + 1 else SAM.selectedActionsIndexes[groupName] = 1 end
    else -- When user scrolling down
        if SAM.selectedActionsIndexes[groupName] ~= 1 then SAM.selectedActionsIndexes[groupName] = SAM.selectedActionsIndexes[groupName] - 1 else SAM.selectedActionsIndexes[groupName] = #SAM.actions[groupName] end
    end
end

-- Makes a new title for the button
-- Ex: button:title(SAM:updateButtonTitle("Arms", "§7\n Actions list:\n", 99, "§6", "§e", "Arms"))
function SAM:updateButtonTitle(buttonName, description, listSize, listColor, selectColor, groupName)
    if SAM.actions[groupName] == nil then error("Actions group with this name(" .. groupName .. ") does not exist") end
    if not SAM.selectedActionsIndexes[groupName] then SAM.selectedActionsIndexes[groupName] = 1 end

    local newButtonTitle = buttonName .. description

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
