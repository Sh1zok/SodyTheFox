squapi = require("scripts.libraries.SquAPI") -- Подключение SquAPI
squapi.smoothHead:new({models.model.root.CenterOfMass.Torso, models.model.root.CenterOfMass.Torso.Neck, models.model.root.CenterOfMass.Torso.Neck.Head}, {0, 0.375, 0.375}, nil, 1, false) -- Гладкий поворот головы
squapi.eye:new(models.model.root.CenterOfMass.Torso.Neck.Head.Face.Irises.LeftIris, 0.3, 0.3, 0.3, 0.3) -- Настройка левого глаза
squapi.eye:new(models.model.root.CenterOfMass.Torso.Neck.Head.Face.Irises.RightIris, 0.3, 0.3, 0.3, 0.3) -- Настройка правого глаза
squapi.ear:new(models.model.root.CenterOfMass.Torso.Neck.Head.Ears.LeftEar, models.model.root.CenterOfMass.Torso.Neck.Head.Ears.RightEar, 0.5, false, 1, true, 400, 0.1, 0.9) -- Настройка ушей
squapi.randimation:new(animations.model.randBlink, 60, true) -- Настройка анимации моргания
squapi.randimation:new(animations.model.randSniffs, 1000, false) -- Настройка анимации принюхивания
squapi.bounceWalk:new(models.model.root, 0.75)
playerTail = squapi.tail:new({models.model.root.CenterOfMass.Torso.Body.Tail, models.model.root.CenterOfMass.Torso.Body.Tail.MainPart, models.model.root.CenterOfMass.Torso.Body.Tail.MainPart.EndPart}, 15, 5, 1, 2, 2, 0, 1, 1, 0.005, 0.9, 90, -60, 60) -- Настройка хвоста



-- Конфигурация FOXpat
local foxpat = require("scripts.libraries.FOXAPI.api").foxpat

function events.entity_pat(_, state)
    if state == "UNPAT" then return end
    if math.random(100) > 99 then
        sounds["entity.fox.death"]:setPos(player:getPos()):setPitch(0.125):play()
    else
        sounds["entity.fox.ambient"]:setPos(player:getPos()):play()
    end
end
foxpat.config.patAnimation = animations.model.FOXpatAnim
foxpat.config.holdFor = 40
foxpat.config.swingArm = false



SAM = require("scripts.libraries.SAM") -- Инициализация SAM
SAM.incompatibleProvisions = {
    ["CROUCHING"] = function()
        return player:getPose() == "CROUCHING"
    end,
    ["WALKING"] = function()
        return math.sqrt(player:getVelocity()[1] ^ 2 + player:getVelocity()[2] ^ 2 + player:getVelocity()[3] ^ 2) > 0.2
    end,
    ["SWINGING"] = function()
        return player:isSwingingArm()
    end,
    ["NOTSITTING"] = function ()
        return player:getVehicle() == nil
    end
}
SAM.actions = {
    groups = {"poses", "arms", "head", "misc"},
    ["poses"] = {
        {"Resting", animations.model.actionResting, 30, {"CROUCHING", "WALKING"}},
        {"Sitting on the floor", animations.model.actionSittingOnAFloor, 30, {"CROUCHING", "WALKING"}},
        {"Kazotsky kick", animations.model.actionKazotskyKick, 29, {"CROUCHING"}},
        {"Backflip", animations.model.actionBackflip, 33, {"CROUCHING"}},
        {"Sitting 1", animations.model.actionSitting1, 30, {"NOTSITTING"}},
        {"Sitting 2", animations.model.actionSitting2, 30, {"NOTSITTING"}},
        {"Laying", animations.model.actionLaying, 30, {"NOTSITTING"}}
    },
    ["arms"] = {
        {"Wave", animations.model.actionWave, 31, {"SWINGING"}},
        {"Point up", animations.model.actionPointUp, 31, {"SWINGING"}},
        {"High five", animations.model.actionHighFive, 31, {"SWINGING"}},
        {"Crossed arms", animations.model.actionCrossArms, 31, {"SWINGING"}},
        {"Arms behind the back", animations.model.actionHandsBehindBack, 31, {"SWINGING"}},
        {"Arm on hip", animations.model.actionArmOnHip, 31, {"CROUCHING", "SWINGING"}}
    },
    ["head"] = {
        {"Happy", animations.model.actionHappy, 32, {}},
        {"Sad", animations.model.actionSad, 32 , {}},
        {"Wink", animations.model.actionWink, 31, {}},
        {"Aggro", animations.model.actionAggro, 32, {}},
        {"Sleppy", animations.model.actionSleepy, 33, {"SWINGING", "CROUCHING"}}
    },
    ["misc"] = {
        {"Smoke bomb", animations.model.actionSmokeBomb, 31, {}},
        {"Spit", animations.model.actionSpit, 0, {}},
        {"Sniffs", animations.model.randSniffs, 32, {}}
    }
}



require("scripts.libraries.SOM") -- Инициализация SOM
outfitsList = { -- Список нарядов
    {"Beach", "textures.Outfits.beach", "textures.Icons.beachOutfitIcon", 0, 1, "textures.Misc.hatDefault"},
    {"Mafia", "textures.Outfits.mafia", "textures.Icons.mafiaOutfitIcon", 1, 1, "textures.Misc.hatMafia"},
    {"Barman", "textures.Outfits.barman", "textures.Icons.barmanOutfitIcon", 0, 1, "textures.Misc.hatDefault"},
    {"Joker 2019", "textures.Outfits.joker", "textures.Icons.jokerOutfitIcon", 0, 1, "textures.Misc.hatDefault"},
    {"Garden outfit", "textures.Outfits.garden", "textures.Icons.gardenOutfitIcon", 0, 1, "textures.Misc.hatDefault"},
    {"Autumn outfit", "textures.Outfits.autumn", "textures.Icons.autumnOutfitIcon", 0, 1, "textures.Misc.hatDefault"}
}
outfitModelParts = { -- Части модели для нарядов
    models.model.root.CenterOfMass.Torso.Body,
    models.model.root.CenterOfMass.Torso.Neck.Neck,
    models.model.root.CenterOfMass.Torso.Neck.Head.Head,
    models.model.root.CenterOfMass.Torso.Neck.Head.Fluff,
    models.model.root.CenterOfMass.Torso.Neck.Head.Ears,
    models.model.root.CenterOfMass.Torso.Neck.Head.Face,
    models.model.root.CenterOfMass.Torso.LeftArm,
    models.model.root.CenterOfMass.Torso.RightArm,
    models.model.root.CenterOfMass.LeftLeg,
    models.model.root.CenterOfMass.RightLeg
}
hatModelPart = models.model.root.CenterOfMass.Torso.Neck.Head.Hat -- Часть модели для шляпы
headSecondLayerModelPart = models.model.root.CenterOfMass.Torso.Neck.Head.Fluff -- Часть модели для волос/шерсти
outfitButtonCommonColor = "§6" -- Цвет нарядов в списке
outfitButtonTitle = "Outfit"
outfitButtonDescription = "Scroll down: Next outfit\n Scroll up: Previous outfit\n\n Outfits:\n" -- Описание кнопки



--[[
    Горячие клавиши(только для хоста)
]]--
if not host:isHost() then return end
keybinds:newKeybind("Stop actions", "key.keyboard.keypad.0"):onPress(pings.SAM_stopAllActions)
keybinds:newKeybind(SAM.actions["arms"][1][1], "key.keyboard.keypad.1"):onPress(function () pings.SAM_playActionFrom("arms", 1) end) -- Приветствие
keybinds:newKeybind(SAM.actions["arms"][2][1], "key.keyboard.keypad.2"):onPress(function () pings.SAM_playActionFrom("arms", 2) end) -- Указать на место
keybinds:newKeybind(SAM.actions["arms"][4][1], "key.keyboard.keypad.3"):onPress(function () pings.SAM_playActionFrom("arms", 4) end) -- Сложить руки
keybinds:newKeybind(SAM.actions["head"][3][1], "key.keyboard.keypad.4"):onPress(function () pings.SAM_playActionFrom("head", 3) end) -- Подмигивание
keybinds:newKeybind(SAM.actions["head"][1][1], "key.keyboard.keypad.5"):onPress(function () pings.SAM_playActionFrom("head", 1) end) -- Счастье
keybinds:newKeybind(SAM.actions["misc"][3][1], "key.keyboard.keypad.6"):onPress(function () pings.SAM_playActionFrom("misc", 3) end) -- Обнюхать
keybinds:newKeybind(SAM.actions["misc"][2][1], "key.keyboard.keypad.7"):onPress(function () pings.SAM_playActionFrom("misc", 2) end) -- Плевок
keybinds:newKeybind(SAM.actions["misc"][1][1], "key.keyboard.keypad.8"):onPress(function () pings.SAM_playActionFrom("misc", 1) end) -- Дымовая шашка
keybinds:newKeybind(SAM.actions["poses"][3][1], "key.keyboard.keypad.9"):onPress(function () pings.SAM_playActionFrom("poses", 3) end) -- Танец "Удар казачка"
