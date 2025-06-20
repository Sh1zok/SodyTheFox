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
models.model.root.CenterOfMass.Torso.Neck.Head.HelmetPivot:setScale(0.8)
models.model.root.CenterOfMass.Torso.Body.ChestplatePivot:setScale(0.8)
models.model.root.CenterOfMass.Torso.LeftArm.LeftShoulderPivot:setScale(0.81)
models.model.root.CenterOfMass.Torso.RightArm.RightShoulderPivot:setScale(0.81)
models.model.root.CenterOfMass.Torso.Body.LeggingsPivot:setScale(0.8)
models.model.root.CenterOfMass.LeftLeg.LeftLeggingPivot:setScale(0.8)
models.model.root.CenterOfMass.RightLeg.RightLeggingPivot:setScale(0.8)
models.model.root.CenterOfMass.LeftLeg.LLBottom.LeftBootPivot:setScale(0.8)
models.model.root.CenterOfMass.RightLeg.RLBottom.RightBootPivot:setScale(0.8)

-- Постановка рук от первого лица
if host:isHost() then
    function events.render(_, context)
        if context == "FIRST_PERSON" then
            models.model.root.CenterOfMass.Torso.LeftArm.Arm:setScale(1.5)
            models.model.root.CenterOfMass.Torso.LeftArm.Sleeve:setScale(1.5)
            models.model.root.CenterOfMass.Torso.LeftArm.LABottom:setScale(1.5)

            models.model.root.CenterOfMass.Torso.LeftArm.Arm:setPos(0, 5, 0)
            models.model.root.CenterOfMass.Torso.LeftArm.Sleeve:setPos(0, 5, 0)
            models.model.root.CenterOfMass.Torso.LeftArm.LABottom:setPos(0.15, 4, 0)

            models.model.root.CenterOfMass.Torso.RightArm.Arm:setScale(1.5)
            models.model.root.CenterOfMass.Torso.RightArm.Sleeve:setScale(1.5)
            models.model.root.CenterOfMass.Torso.RightArm.RABottom:setScale(1.5)

            models.model.root.CenterOfMass.Torso.RightArm.Arm:setPos(0, 5, 0)
            models.model.root.CenterOfMass.Torso.RightArm.Sleeve:setPos(0, 5, 0)
            models.model.root.CenterOfMass.Torso.RightArm.RABottom:setPos(-0.15, 4, 0)
        else
            models.model.root.CenterOfMass.Torso.LeftArm.Arm:setScale(1)
            models.model.root.CenterOfMass.Torso.LeftArm.Sleeve:setScale(1)
            models.model.root.CenterOfMass.Torso.LeftArm.LABottom:setScale(1)

            models.model.root.CenterOfMass.Torso.LeftArm.Arm:setPos(0, 0, 0)
            models.model.root.CenterOfMass.Torso.LeftArm.Sleeve:setPos(0, 0, 0)
            models.model.root.CenterOfMass.Torso.LeftArm.LABottom:setPos(0, 0, 0)

            models.model.root.CenterOfMass.Torso.RightArm.Arm:setScale(1)
            models.model.root.CenterOfMass.Torso.RightArm.Sleeve:setScale(1)
            models.model.root.CenterOfMass.Torso.RightArm.RABottom:setScale(1)

            models.model.root.CenterOfMass.Torso.RightArm.Arm:setPos(0, 0, 0)
            models.model.root.CenterOfMass.Torso.RightArm.Sleeve:setPos(0, 0, 0)
            models.model.root.CenterOfMass.Torso.RightArm.RABottom:setPos(0, 0, 0)
        end
    end
end

-- Убираем ванильную модель
vanilla_model.PLAYER:setVisible(false) -- Модель игрока
vanilla_model.CAPE:setVisible(false) -- Плащ
vanilla_model.ELYTRA:setVisible(false) -- Элитра

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
function pings.setHatVisibility(state) models.model.root.CenterOfMass.Torso.Neck.Head.Hat:setVisible(state) end

function events.tick()
    hatVisibilitySyncCooldown = hatVisibilitySyncCooldown - 1
    if hatVisibilitySyncCooldown <= 0 then
        hatVisibilitySyncCooldown = 200
        pings.setHatVisibility(config:load("isHatVisible"))
    end
end
