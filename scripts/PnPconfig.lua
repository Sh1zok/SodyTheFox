local pnp = require("scripts.libraries.PushNPull")

pnp.active = true;
pnp.ignoreWhitelist = false;

for _, v in pairs({
    "NikoSolstice",
    "JANICHRIS5963",
    "Simon255",
    "KingRoboLizard",
    "MCJesta"
}) do
    pnp.WhitelistedPlayers[v] = true
end

isGrabbed = false
pnp.config.launchDistance = 100
pnp.config.grabDistance = 8


local isGrabbing = false
-- all these changes are setup now and applied on entity_init !
-- If you got vscode hovering over them should give you a nice tooltip telling you what they do.

--[[
    CUSTOMIZE ANYTHING UNDER THIS WITH WHATFUCKEN EVER CODE YOU WANT
    THIS IS YOUR LIFE, THIS IS JUST AN EXAMPLE!!!!!!!!!!!!!!!
]]

-- Simple function to just get the look position of the player, this is because im lazy :3c
local function lookPos(r)
    if not player:isLoaded() then return 0; end
    return player:getPos() + vec(0, player:getEyeHeight(), 0) + (player:getLookDir() * (r or 30))
end


-- Setting up the whileGrabbing function so I can do cool particles if i grab someone!
-- Ent is the player that im grabbing and V is the vector / velocity im grabbing them at!
-- If you have vscode Hover over the function to see what is passed through.
function pnp.functions.whileGrabbing(ent, v)
    isGrabbing = true
end

-- Setting up while grabbed function, i want to do a little broken heart particle whenever people grab me!
-- Seems basic cuz it is!
-- If you have vscode Hover over the function to see what is passed through.
function pnp.functions.whileGrabbed()
    isGrabbed = true
end

function events.tick()
    animations.model.pnpWhileGrabbed:setPlaying(isGrabbed)
    animations.model.pnpWhileGrabbing:setPlaying(isGrabbing)

    isGrabbed = false
    isGrabbing = false
end


-- Here i setup a quick keybind to grab the person I'm looking at
-- then using pings.pnpSetMode, passing through the pnp.modesLogic[INDEX], in this example INDEX is forceChoke!
-- Look at forceChoke in the main file to look at what it does! and how to make your own function!
-- Then I also pass through the UUID of the person I'm doing this on and if I want to remove or add it to the tick events list, 
-- in this case I put in false because I want this to be added to the list!
local lastForceChokeTarget;
local key = keybinds:newKeybind("Схватить/отпустить игрока", "key.mouse.5", false)
key:setOnPress(function()
    -- Using a raycast cuz fancy :3c
    local t = raycast:entity(lookPos(0),lookPos(60), function(e) return e ~= player; end);
    if not t then return end;
    lastForceChokeTarget = t:getUUID()
    pings.pnpSetMode("forceChoke", lastForceChokeTarget, false)
end)

-- And in here i pass through the last entity's UUID and do true so that I remove it from the tick events list and reset it!
key:setOnRelease(function()
    if not lastForceChokeTarget then return; end
    pings.pnpSetMode("forceChoke", lastForceChokeTarget, true);
    lastForceChokeTarget = nil;
end)


-- This is a function I made custom (aka does not come with the pnp file) that lets me throw whoever I want, 
-- technically this can be ran at any time! as long as you pass through an entity and a vector.
---@param ent Entity
---@param v Vector3
function pnp.functions.throwEntity(ent, v)
    local vars = pnp.functions.validOverallChecker(ent)
    if not vars then return; end

    -- New thing added! Timers! It adds a timeout to each instruction (defaults to 5 ticks) and it ticks off the instruction, neat right?
    pnp.functions.setInstruction(ent, "setVel", { value = v, extra = "throw", timer=3 })
end


-- Little ping so I can run it with the keybind!
function pings.launch(uuid)
    -- In here I remove the person from the tick events list so I dont regrab them!
    -- True is there so i remove them!
    pnp.functions.setMode("forceChoke", uuid, true);

    local t = world.getEntity(uuid)
    if type(t) == "PlayerAPI" then
        -- Running the function as thou can see
        pnp.functions.throwEntity(t,player:getVelocity() + (lookPos(pnp.config.launchDistance) - t:getPos()) * 0.1)
    end
    lastForceChokeTarget = nil;
end

-- See how easy this is! I check if the lastForceChokeTarget isnt nil / has a UUID and i throw em >:3
keybinds:newKeybind("Метнуть игрока", "key.mouse.left", false):setOnPress(function(modifiers, self)
    if lastForceChokeTarget then
        -- Yeet
        pings.launch(lastForceChokeTarget)
    end
    isGrabbing = false
end)

-- In here is where I do the leash function!
function events.tick()
    -- Get if player is swinging
    if player:getSwingTime() == 1 then
        -- Check if I'm holding a lead! and if im looking at something!
        if player:getHeldItem():getID():gsub("^.+:", "") == "lead" then
            local t = player:getTargetedEntity();
            if t then
                -- Then yoink i grab them, as you can see in the final field i didnt put in a true or false, this is because i want to toggle!
                -- Well then i did a small little nil check
                -- As you can see every tick event is stored in pnp.activeModes
                pings.pnpSetMode("leash", t:getUUID(), pnp.activeModes["leash" .. t:getUUID()] ~= nil)
            end
        end
    end
end