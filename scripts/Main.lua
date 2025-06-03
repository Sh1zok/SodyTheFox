-- Определение видимости рук от первого лица
if host:isHost() then
    function events.render()
        renderer:setRenderLeftArm(player:getHeldItem(not player:isLeftHanded()).id == "minecraft:air") -- Левая рука
        renderer:setRenderRightArm(player:getHeldItem(player:isLeftHanded()).id == "minecraft:air") -- Правая рука
    end
end

-- Звук лисы во время отправки сообщения
function events.chat_send_message(msg)
    sounds:playSound("minecraft:entity.fox.ambient", player:getPos(), 1, 0.75, false)
    return msg
end

-- Регулировка размера брони
models.model.root.PNPAnchor.Body.Neck.Head.HelmetPivot:setScale(0.8)
models.model.root.PNPAnchor.Body.ChestplatePivot:setScale(0.8)
models.model.root.PNPAnchor.Body.LeftArm.LeftShoulderPivot:setScale(0.81)
models.model.root.PNPAnchor.Body.RightArm.RightShoulderPivot:setScale(0.81)
models.model.root.PNPAnchor.Body.LeggingsPivot:setScale(0.8)
models.model.root.PNPAnchor.LeftLeg.LeftLeggingPivot:setScale(0.8)
models.model.root.PNPAnchor.RightLeg.RightLeggingPivot:setScale(0.8)
models.model.root.PNPAnchor.LeftLeg.LLBottom.LeftBootPivot:setScale(0.8)
models.model.root.PNPAnchor.RightLeg.RLBottom.RightBootPivot:setScale(0.8)

-- Высота камеры
if host:isHost() then
    local eyeOffsetY = 0
    local cameraOffsetY -- Смещение высоты камеры

    function events.render()
        if player:isLoaded() then
            cameraOffsetY = models.model.root.PNPAnchor.Body.Neck.Head.Face.Irises:partToWorldMatrix():apply().y - models.model.normalViewpoint:partToWorldMatrix():apply().y -- Вычисление смещения
            if player:getPose() == "CROUCHING" then cameraOffsetY = cameraOffsetY + 0.25 end -- Поправка на присед
        end

        renderer:offsetCameraPivot(0, cameraOffsetY, 0) -- Задание смещения

        if player:getPose() ~= "CROUCHING" and eyeOffsetY ~= -0.28 then
            eyeOffsetY = -0.28
            renderer:setEyeOffset(0, eyeOffsetY, 0) -- Поправка селекта блоков
        elseif player:getPose() == "CROUCHING" and eyeOffsetY ~= -0.05 then
            eyeOffsetY = -0.05
            renderer:setEyeOffset(0, eyeOffsetY, 0) -- Поправка селекта блоков
        end
    end
end

-- Постановка рук от первого лица
if host:isHost() then
    function events.render(_, context)
        if context == "FIRST_PERSON" then
            models.model.root.PNPAnchor.Body.LeftArm.Arm:setScale(1.5)
            models.model.root.PNPAnchor.Body.LeftArm.Sleeve:setScale(1.5)
            models.model.root.PNPAnchor.Body.LeftArm.LABottom:setScale(1.5)

            models.model.root.PNPAnchor.Body.LeftArm.Arm:setPos(0, 5, 0)
            models.model.root.PNPAnchor.Body.LeftArm.Sleeve:setPos(0, 5, 0)
            models.model.root.PNPAnchor.Body.LeftArm.LABottom:setPos(0.15, 4, 0)

            models.model.root.PNPAnchor.Body.RightArm.Arm:setScale(1.5)
            models.model.root.PNPAnchor.Body.RightArm.Sleeve:setScale(1.5)
            models.model.root.PNPAnchor.Body.RightArm.RABottom:setScale(1.5)

            models.model.root.PNPAnchor.Body.RightArm.Arm:setPos(0, 5, 0)
            models.model.root.PNPAnchor.Body.RightArm.Sleeve:setPos(0, 5, 0)
            models.model.root.PNPAnchor.Body.RightArm.RABottom:setPos(-0.15, 4, 0)
        else
            models.model.root.PNPAnchor.Body.LeftArm.Arm:setScale(1)
            models.model.root.PNPAnchor.Body.LeftArm.Sleeve:setScale(1)
            models.model.root.PNPAnchor.Body.LeftArm.LABottom:setScale(1)

            models.model.root.PNPAnchor.Body.LeftArm.Arm:setPos(0, 0, 0)
            models.model.root.PNPAnchor.Body.LeftArm.Sleeve:setPos(0, 0, 0)
            models.model.root.PNPAnchor.Body.LeftArm.LABottom:setPos(0, 0, 0)

            models.model.root.PNPAnchor.Body.RightArm.Arm:setScale(1)
            models.model.root.PNPAnchor.Body.RightArm.Sleeve:setScale(1)
            models.model.root.PNPAnchor.Body.RightArm.RABottom:setScale(1)

            models.model.root.PNPAnchor.Body.RightArm.Arm:setPos(0, 0, 0)
            models.model.root.PNPAnchor.Body.RightArm.Sleeve:setPos(0, 0, 0)
            models.model.root.PNPAnchor.Body.RightArm.RABottom:setPos(0, 0, 0)
        end
    end
end

-- Убираем ванильную модель
vanilla_model.PLAYER:setVisible(false) -- Модель игрока
vanilla_model.CAPE:setVisible(false) -- Плащ
vanilla_model.ELYTRA:setVisible(false) -- Элитра

-- Настройка анимаций
animations.model.idling:setPriority(-1)
animations.model.holdR:setBlendTime(0)
animations.model.holdL:setBlendTime(0)
animations.model.actionHighFiveCheck:setPriority(32)
animations.model.spearR:setPriority(1)
animations.model.spearL:setPriority(1)
animations.model.bowR:setPriority(1)
animations.model.bowL:setPriority(1)
animations.model.crossR:setPriority(1)
animations.model.crossL:setPriority(1)

-- Видимость брони и её синхронизация
local armorVisibilitySyncCooldown = 10
function pings.setArmorVisibility(state) vanilla_model.ARMOR:setVisible(state) end

function events.tick()
    armorVisibilitySyncCooldown = armorVisibilitySyncCooldown - 1
    if armorVisibilitySyncCooldown <= 0 then
        armorVisibilitySyncCooldown = 200
        pings.setArmorVisibility(config:load("isArmorVisible"))
    end
end

pings.setArmorVisibility(config:load("isArmorVisible"))

-- Видимость головного убора и её синхронизация
local hatVisibilitySyncCooldown = 10
function pings.setHatVisibility(state) models.model.root.PNPAnchor.Body.Neck.Head.Hat:setVisible(state) end

function events.tick()
    hatVisibilitySyncCooldown = hatVisibilitySyncCooldown - 1
    if hatVisibilitySyncCooldown <= 0 then
        hatVisibilitySyncCooldown = 200
        pings.setHatVisibility(config:load("isHatVisible"))
    end
end
