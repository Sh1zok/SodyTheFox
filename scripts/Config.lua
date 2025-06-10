squapi = require("scripts.libraries.SquAPI") -- Подключение SquAPI
squapi.smoothHead:new({models.model.root.CenterOfMass.Torso, models.model.root.CenterOfMass.Torso.Body.Neck, models.model.root.CenterOfMass.Torso.Body.Neck.Head}, {0, 0.375, 0.375}, nil, 1, false) -- Гладкий поворот головы
squapi.eye:new(models.model.root.CenterOfMass.Torso.Body.Neck.Head.Face.Irises.LeftIris, 0.3, 0.3, 0.3, 0.3) -- Настройка левого глаза
squapi.eye:new(models.model.root.CenterOfMass.Torso.Body.Neck.Head.Face.Irises.RightIris, 0.3, 0.3, 0.3, 0.3) -- Настройка правого глаза
squapi.ear:new(models.model.root.CenterOfMass.Torso.Body.Neck.Head.Ears.LeftEar, models.model.root.CenterOfMass.Torso.Body.Neck.Head.Ears.RightEar, 0.5, false, 1, true, 400, 0.1, 0.9) -- Настройка ушей
squapi.randimation:new(animations.model.randBlink, 60, true) -- Настройка анимации моргания
squapi.randimation:new(animations.model.randSniffs, 1000, false) -- Настройка анимации принюхивания
squapi.randimation:new(animations.model.randChews, 1000, false) -- Настройка анимации пожёвывания
squapi.bounceWalk:new(models.model.root, 0.75)
playerTail = squapi.tail:new({models.model.root.CenterOfMass.Torso.Body.Tail, models.model.root.CenterOfMass.Torso.Body.Tail.MainPart, models.model.root.CenterOfMass.Torso.Body.Tail.MainPart.EndPart}, 15, 5, 1, 2, 2, 0, 1, 1, 0.005, 0.9, 90, -60, 60) -- Настройка хвоста



SAM = require("scripts.libraries.SAM") -- Инициализация SAM
SAM.incompatibleAnimations = { -- Группы несовместимых анимаций
    ["triggers"] = { -- Разные триггеры
        animations.model.falling
    },
    ["walking"] = { -- Анимации ходьбы
        animations.model.walking,
        animations.model.walkingback
    },
    ["sprinting"] = { -- Анимация бега
        animations.model.sprinting,
    },
    ["crouching"] = { -- Анимации приседа
        animations.model.crouching,
        animations.model.sitting
    },
    ["arms"] = { -- Анимации рук
        animations.model.spearL,
        animations.model.spearR,
        animations.model.crossL,
        animations.model.crossR,
        animations.model.bowL,
        animations.model.bowR,
    },
    ["flying"] = { -- Анимации полёта
        animations.model.flying,
        animations.model.elytra
    }
}
SAM.actions = { -- Задание действий: Имя, анимация, приоритет анимации, несовместимые анимации
    groups = {"poses", "arms", "head", "misc"},
    ["poses"] = {
        {"Отдыхает", animations.model.actionResting, 30, {"sprinting", "crouching", "arms", "flying", "triggers"}},
        {"Сесть на пол", animations.model.actionSittingOnAFloor, 30, {"sprinting", "crouching", "arms", "flying", "triggers"}},
        {'Танец "Удар казачка"', animations.model.actionKazotskyKick, 29, {"crouching", "sprinting", "triggers"}},
        {"Сальто назад", animations.model.actionBackflip, 33, {"arms", "crouching", "sprinting", "triggers"}}
    },
    ["arms"] = {
        {"Приветствие", animations.model.actionWave, 31, {"arms", "triggers"}},
        {"Указать на место", animations.model.actionPointUp, 31, {"arms", "triggers"}},
        {"Пятюня", animations.model.actionHighFive, 31, {"sprinting", "crouching", "arms", "triggers"}},
        {"Сложить руки", animations.model.actionCrossArms, 31, {"crouching", "arms", "sprinting", "triggers"}},
        {"Руки за спиной", animations.model.actionHandsBehindBack, 31, {"arms", "sprinting", "triggers"}},
        {"Рука на бедре", animations.model.actionArmOnHip, 31, {"crouching", "sprinting", "arms", "triggers"}},
        {"Боевая стойка", animations.model.actionBattlePose, 31, {"crouching", "sprinting", "arms", "triggers"}}
    },
    ["head"] = {
        {"Счастье", animations.model.actionHappy, 32, {}},
        {"Грусть", animations.model.actionSad, 32 , {}},
        {"Подмигивание", animations.model.actionWink, 31, {}},
        {"Интерес", animations.model.actionInterested, 32, {}},
        {"Агрессия", animations.model.actionAggro, 32, {}},
        {"Заносчивость", animations.model.actionArrogance, 32, {"crouching", "sprinting", "arms", "triggers"}},
        {"Милашка", animations.model.actionAdorable, 32, {}}
    },
    ["misc"] = {
        {"Дымовая шашка", animations.model.actionSmokeBomb, 31, {}},
        {"Плевок", animations.model.actionSpit, 0, {}},
        {"Обнюхать", animations.model.randSniffs, 32, {}},
    }
}



require("scripts.libraries.SOM") -- Инициализация SOM
outfitsList = { -- Список нарядов
    {"Пляжный", "textures.Outfits.beach", "textures.Icons.beachOutfitIcon", 0, 1, "textures.Misc.hatDefault"},
    {"Мафия", "textures.Outfits.mafia", "textures.Icons.mafiaOutfitIcon", 1, 1, "textures.Misc.hatMafia"},
    {"Бармен", "textures.Outfits.barman", "textures.Icons.barmanOutfitIcon", 0, 1, "textures.Misc.hatDefault"},
    {"Джокер", "textures.Outfits.joker", "textures.Icons.jokerOutfitIcon", 0, 1, "textures.Misc.hatDefault"}
}
outfitModelParts = { -- Части модели для нарядов
    models.model.root.CenterOfMass.Torso.Body,
    models.model.root.CenterOfMass.Torso.Body.Neck.Neck,
    models.model.root.CenterOfMass.Torso.Body.Neck.Head.Head,
    models.model.root.CenterOfMass.Torso.Body.Neck.Head.Fluff,
    models.model.root.CenterOfMass.Torso.Body.Neck.Head.Ears,
    models.model.root.CenterOfMass.Torso.Body.Neck.Head.Face,
    models.model.root.CenterOfMass.Torso.LeftArm,
    models.model.root.CenterOfMass.Torso.RightArm,
    models.model.root.CenterOfMass.LeftLeg,
    models.model.root.CenterOfMass.RightLeg
}
hatModelPart = models.model.root.CenterOfMass.Torso.Body.Neck.Head.Hat -- Часть модели для шляпы
headSecondLayerModelPart = models.model.root.CenterOfMass.Torso.Body.Neck.Head.Fluff -- Часть модели для волос/шерсти
outfitButtonCommonColor = "§6" -- Цвет нарядов в списке
outfitButtonDescription = "Список нарядов:\n" -- Описание кнопки



--[[
    Горячие клавиши(только для хоста)
]]--
if not host:isHost() then return end
keybinds:newKeybind("Остановить действие", "key.keyboard.keypad.0"):onPress(pings.SAM_stopAllActions)
keybinds:newKeybind(SAM.actions["arms"][1][1], "key.keyboard.keypad.1"):onPress(function () pings.SAM_playActionFrom("arms", 1) end) -- Приветствие
keybinds:newKeybind(SAM.actions["arms"][2][1], "key.keyboard.keypad.2"):onPress(function () pings.SAM_playActionFrom("arms", 2) end) -- Указать на место
keybinds:newKeybind(SAM.actions["arms"][4][1], "key.keyboard.keypad.3"):onPress(function () pings.SAM_playActionFrom("arms", 4) end) -- Сложить руки
keybinds:newKeybind(SAM.actions["head"][3][1], "key.keyboard.keypad.4"):onPress(function () pings.SAM_playActionFrom("head", 3) end) -- Подмигивание
keybinds:newKeybind(SAM.actions["head"][1][1], "key.keyboard.keypad.5"):onPress(function () pings.SAM_playActionFrom("head", 1) end) -- Счастье
keybinds:newKeybind(SAM.actions["misc"][3][1], "key.keyboard.keypad.6"):onPress(function () pings.SAM_playActionFrom("misc", 3) end) -- Обнюхать
keybinds:newKeybind(SAM.actions["misc"][2][1], "key.keyboard.keypad.7"):onPress(function () pings.SAM_playActionFrom("misc", 2) end) -- Плевок
keybinds:newKeybind(SAM.actions["misc"][1][1], "key.keyboard.keypad.8"):onPress(function () pings.SAM_playActionFrom("misc", 1) end) -- Дымовая шашка
keybinds:newKeybind(SAM.actions["poses"][3][1], "key.keyboard.keypad.9"):onPress(function () pings.SAM_playActionFrom("poses", 3) end) -- Танец "Удар казачка"
