if not host:isHost() then return end -- Этот скрипт только для хоста

-- Создание страниц колеса действий
mainPage = action_wheel:newPage() -- Основная страница
actionsPage = action_wheel:newPage() -- Страница действий
wardrobePage = action_wheel:newPage() -- Страница гардероба
settingsPage = action_wheel:newPage() -- Страница настроек
action_wheel:setPage(actionsPage) -- Задание активной страницы

--[[
    Кнопки главной страницы
]]--
goToSettingsPage = mainPage:newAction()
    :title("Настройки")
    :item("minecraft:command_block")
    :hoverColor(1, 0.6, 0.75)
    :color(1, 0.25, 0.375)
    :onLeftClick(function()
        action_wheel:setPage(settingsPage)
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
    end)
goToWardrobePage = mainPage:newAction()
    :title("Гардероб")
    :item("minecraft:chainmail_chestplate")
    :hoverColor(1, 0.75, 0)
    :color(0.75, 0.5, 0)
    :onLeftClick(function()
        action_wheel:setPage(wardrobePage)
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
    end)
goToActionsPage = mainPage:newAction()
    :title("Действия")
    :item("minecraft:ender_eye")
    :hoverColor(0.25, 1, 0.9)
    :color(0.125, 0.5, 0.45)
    :onLeftClick(function()
        action_wheel:setPage(actionsPage)
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
    end)



--[[
    Кнопки страницы действий
]]--
goBack1 = actionsPage:newAction()
    :title("Главная страница")
    :item("minecraft:spectral_arrow")
    :hoverColor(1, 1, 1)
    :color(0.75, 0.75, 0.75)
    :onLeftClick(function()
        action_wheel:setPage(mainPage)
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
    end)
SAM_poses = actionsPage:newAction()
    :title(SAM:updateButtonTitle("Позы", "§7\n Список действий:\n", 99, "§9", "§b", "poses"))
    :item("minecraft:warped_stairs")
    :hoverColor(0.5, 0, 1)
    :color(0.25, 0, 0.75)
    :onLeftClick(function()
        pings.SAM_playActionFrom("poses", SAM.selectedActionsIndexes["poses"]) -- Воспроизведение действия
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
    end)
    :onRightClick(function()
        pings.SAM_stopActionIn("poses") -- Остановка действия
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
    end)
    :onScroll(function(scrollDirection) -- Прокручивание
        SAM:buttonScroll(scrollDirection, "poses")
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
        SAM_poses:title(SAM:updateButtonTitle("Позы", "§7\n Список действий:\n", 99, "§9", "§b", "poses"))
    end)
SAM_arms = actionsPage:newAction()
    :title(SAM:updateButtonTitle("Руки", "§7\n Список действий:\n", 99, "§6", "§e", "arms"))
    :item("minecraft:piston")
    :hoverColor(1, 0.75, 0)
    :color(0.75, 0.5, 0)
    :onLeftClick(function()
        pings.SAM_playActionFrom("arms", SAM.selectedActionsIndexes["arms"]) -- Воспроизведение действия
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
    end)
    :onRightClick(function()
        pings.SAM_stopActionIn("arms") -- Остановка действия
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
    end)
    :onScroll(function(scrollDirection) -- Прокручивание
        SAM:buttonScroll(scrollDirection, "arms")
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
        SAM_arms:title(SAM:updateButtonTitle("Руки", "§7\n Список действий:\n", 99, "§6", "§e", "arms"))
    end)
SAM_head = actionsPage:newAction()
    :title(SAM:updateButtonTitle("Мимика и голова", "§7\n Список действий:\n", 99, "§5", "§d", "head"))
    :item("minecraft:axolotl_bucket")
    :hoverColor(1, 0.6, 0.75)
    :color(1, 0.25, 0.375)
    :onLeftClick(function()
        pings.SAM_playActionFrom("head", SAM.selectedActionsIndexes["head"]) -- Воспроизведение действия
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
    end)
    :onRightClick(function()
        pings.SAM_stopActionIn("head") -- Остановка действия
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
    end)
    :onScroll(function(scrollDirection) -- Прокручивание
        SAM:buttonScroll(scrollDirection, "head")
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
        SAM_head:title(SAM:updateButtonTitle("Мимика и голова", "§7\n Список действий:\n", 99, "§5", "§d", "head"))
    end)
SAM_misc = actionsPage:newAction()
    :title(SAM:updateButtonTitle("Другое", "§7\n Список действий:\n", 99, "§4", "§c", "misc"))
    :item("minecraft:redstone")
    :hoverColor(1, 0, 0)
    :color(0.75, 0, 0)
    :onLeftClick(function()
        pings.SAM_playActionFrom("misc", SAM.selectedActionsIndexes["misc"]) -- Воспроизведение действия
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
    end)
    :onRightClick(function()
        pings.SAM_stopActionIn("misc") -- Остановка действия
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
    end)
    :onScroll(function(scrollDirection) -- Прокручивание
        SAM:buttonScroll(scrollDirection, "misc")
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
        SAM_misc:title(SAM:updateButtonTitle("Другое", "§7\n Список действий:\n", 99, "§4", "§c", "misc"))
    end)



--[[
    Кнопки страницы гардероба
]]--
goBack2 = wardrobePage:newAction()
    :title("Главная страница")
    :item("minecraft:spectral_arrow")
    :hoverColor(1, 1, 1)
    :color(0.75, 0.75, 0.75)
    :onLeftClick(function()
        action_wheel:setPage(mainPage)
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
    end)
armorVisibilityManager = wardrobePage:newAction()
    :title("Сделать броню видимой")
    :toggleTitle("Сделать броню невидимой")
    :color(0.75, 0, 0)
    :toggleColor(0, 0.75, 0)
    :hoverColor(1, 1, 1)
    :item("minecraft:chainmail_chestplate")
    :toggleItem("minecraft:netherite_chestplate")
    :toggled(config:load("isArmorVisible"))
    :onToggle(function()
        config:save("isArmorVisible", armorVisibilityManager:isToggled())

        pings.setArmorVisibility(armorVisibilityManager:isToggled())

        if armorVisibilityManager:isToggled() then
            sounds:playSound("block.beacon.activate", player:getPos())
        else
            sounds:playSound("block.beacon.deactivate", player:getPos())
        end
    end)
hatVisibilityManager = wardrobePage:newAction()
    :title("Сделать головной убор видимым")
    :toggleTitle("Сделать головной убор невидимым")
    :color(0.75, 0, 0)
    :toggleColor(0, 0.75, 0)
    :hoverColor(1, 1, 1)
    :item("minecraft:chainmail_helmet")
    :toggleItem("minecraft:netherite_helmet")
    :toggled(config:load("isHatVisible"))
    :onToggle(function()
        config:save("isHatVisible", hatVisibilityManager:isToggled())

        pings.setHatVisibility(hatVisibilityManager:isToggled())

        if hatVisibilityManager:isToggled() then
            sounds:playSound("block.beacon.activate", player:getPos())
        else
            sounds:playSound("block.beacon.deactivate", player:getPos())
        end
    end)
outfits = wardrobePage:newAction() -- Кнопка SOM
    :setTitle(updateOutfitButtonTitle()) -- Начальный титул кнопки
    :setTexture(updateOutfitButtonTexture()) -- Начальная текстура кнопки
    :hoverColor(1, 0.75, 0)
    :color(0.75, 0.5, 0)
    :onScroll(function(dir) -- Прокручивание
        outfitButtonSelect(dir) -- Выбор наряда
        outfits:title(updateOutfitButtonTitle()) -- Обновление титула
        outfits:setTexture(updateOutfitButtonTexture()) -- Обновление текстуры
    end)



--[[
    Кнопки страницы настроек
]]--
goBack3 = settingsPage:newAction()
    :title("Главная страница")
    :item("minecraft:spectral_arrow")
    :hoverColor(1, 1, 1)
    :color(0.75, 0.75, 0.75)
    :onLeftClick(function()
        action_wheel:setPage(mainPage)
        sounds:playSound("block.calcite.place", player:getPos()) -- Звук
    end)