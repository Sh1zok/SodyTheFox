local mouthRotationAngleNonHost

-- Задание градуса поворота для не хоста
function pings.setAngle(degrees) mouthRotationAngleNonHost = degrees end

-- Поворот рта
function events.render()
    local angle = math.lerp(models.model.root.CenterOfMass.Body.Neck.Head.Face.Muzzle.Mouth:getRot()[1], mouthRotationAngleNonHost, 0.5)

    models.model.root.CenterOfMass.Body.Neck.Head.Face.Muzzle.Mouth:setRot(angle)
    models.model.root.CenterOfMass.Body.Neck.Head.Face.Muzzle.TopPart:setRot(-angle / 10)
end

if not (client:isModLoaded("figurasvc") and host:isHost()) then return end -- Дальше скрипт читает только хост если у него установлен figurasvc
-- Функция получает сырой аудио поток(импульсно-кодовая модуляция)
-- и вычисляет среднее арефметическое из списка rawAudioStream,
-- тем самым демодулируя этот поток
function getVoiceLevel(rawAudioStream)
    local pcmSum = 0

    for index = 1, #rawAudioStream do pcmSum = pcmSum + math.abs(rawAudioStream[index]) end -- Берём сумму

    return (pcmSum / #rawAudioStream) -- Делим сумму на количество, получаем уровень громкости голоса
end

-- Вычисляем градус открытия рта каждый момент работы микрофона, макс. -60, мин. -0.1(для отсечения слишком мелких значений)
function events.host_microphone(audio)
    mouthRotationAngle = math.clamp(-getVoiceLevel(audio) / 200, -60, -0.1)
    if mouthRotationAngle == -0.1 then mouthRotationAngle = 0 end
end

-- Поворачиваем рот
function events.tick()
    if mouthRotationAngle ~= mouthRotationAnglePreviousTick then
        pings.setAngle(mouthRotationAngle)
        mouthRotationAnglePreviousTick = mouthRotationAngle
        isMicWorking = true
    else
        isMicWorking = false
    end

    -- Если микрофон не работает а рот не закрыт то закрываем его
    if not isMicWorking and mouthRotationAngle ~= 0 and mouthRotationAngle ~= -60 then
        mouthRotationAngle = 0
        mouthRotationAnglePreviousTick = 0
        pings.setAngle(mouthRotationAngle)
    end
end
