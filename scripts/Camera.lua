-- Меняем положение головы в приседе
local isCrouching = false
local isCrouchingPreviousTick = false
function events.tick()
    if player:isLoaded() then isCrouching = player:getPose() == "CROUCHING" end
    if isCrouching ~= isCrouchingPreviousTick then
        isCrouchingPreviousTick = isCrouching
        if isCrouching then models.model.root.CenterOfMass.Torso.Neck:setPos(0, -3.25, 0) else models.model.root.CenterOfMass.Torso.Neck:setPos(0, 0, 0) end
    end
end

if not host:isHost() then return end

-- Высота камеры
local eyeOffsetY = 0
local cameraOffsetY -- Смещение высоты камеры
function events.render()
    if player:isLoaded() and player:getPose() == "STANDING" then
        cameraOffsetY = models.model.root.CenterOfMass.Torso.Neck.Head.Face.Irises:partToWorldMatrix():apply().y - models.model.normalViewpoint:partToWorldMatrix():apply().y -- Вычисление смещения
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

-- Отклонение камеры мышью
local mousePositionCentered = {X = 0, Y = 0}
renderer:setOffsetCameraRot(0, 0, 0)
cameraRotationOffsetModifier = 6

function events.RENDER()
    if (host:isChatOpen() or host:isContainerOpen()) and client:isWindowFocused() then
        mousePositionCentered.X = client:getMousePos()[1] - client:getWindowSize()[1] / 2
        mousePositionCentered.Y = client:getMousePos()[2] - client:getWindowSize()[2] / 2
    else
        if mousePositionCentered ~= {X = 0, Y = 0} then mousePositionCentered = {X = 0, Y = 0} end
    end

    renderer:setOffsetCameraRot(
        math.lerp(renderer:getCameraOffsetRot()[1], mousePositionCentered.Y / client:getFOV() * cameraRotationOffsetModifier, 0.125),
        math.lerp(renderer:getCameraOffsetRot()[2], mousePositionCentered.X / client:getFOV() * cameraRotationOffsetModifier, 0.125),
        0
    )
end
