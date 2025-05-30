function pings.rotateMouth(degrees) -- Смена текстуры рта на заданную
    models.model.root.PNPAnchor.Body.Neck.Head.Face.Muzzle.Mouth:setRot(degrees)
    models.model.root.PNPAnchor.Body.Neck.Head.Face.Muzzle.TopPart:setRot(-degrees / 5)
end

if not (client:isModLoaded("figurasvc") and host:isHost()) then return end -- Дальше скрипт читает только хост если у него установлена figurasvc
local mouthRotationPreviousTick -- Текстура рта в предыдущем тике
local mouthRotation -- Текстура рта в текущем тике
events["svc.microphone"] = function(pcm) -- Ивент исполняющийся во время использования микрофона
    local averageVL = 0 -- Средняя громкость голоса

    for i = 1, #pcm do -- Вычисление суммы
        averageVL = averageVL + math.abs(pcm[i])
    end

    mouthRotation = -(averageVL / (#pcm * 100)) / 2 -- Вычисление угла поворота рта
    if mouthRotation < -60 then mouthRotation = -60 end
    if mouthRotation > -0.1 then mouthRotation = 0 end
end

function events.tick()
    if mouthRotation ~= mouthRotationPreviousTick then -- Оптимизированный пинг и определение того, работает ли микрофон
        pings.rotateMouth(mouthRotation)
        mouthRotationPreviousTick = mouthRotation
        isMicWorking = true
    else
        isMicWorking = false
    end
end
