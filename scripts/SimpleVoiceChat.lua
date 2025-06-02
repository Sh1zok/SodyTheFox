function pings.rotateMouth(degrees) -- Смена текстуры рта на заданную
    models.model.root.PNPAnchor.Body.Neck.Head.Face.Muzzle.Mouth:setRot(degrees)
    models.model.root.PNPAnchor.Body.Neck.Head.Face.Muzzle.TopPart:setRot(-degrees / 5)
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
    mouthRotation = math.clamp(-getVoiceLevel(audio) / 200, -60, -0.1)
    if mouthRotation == -0.1 then mouthRotation = 0 end
end

-- Поворачиваем рот
function events.tick()
    if mouthRotation ~= mouthRotationPreviousTick then
        pings.rotateMouth(mouthRotation)
        mouthRotationPreviousTick = mouthRotation
        isMicWorking = true
    else
        isMicWorking = false
    end
end
