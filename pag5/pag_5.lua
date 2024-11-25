local composer = require("composer")
local scene = composer.newScene()
local audio = require("audio")
local backgroundSound 
local isSoundOn = false 
local MARGIN = 20

-- Variáveis globais para animação
local frameIndex = 1
local totalFrames = 23
local frames = {} -- Armazena as imagens carregadas
local arrowsInTargets = {} -- Verifica se ambas as setas estão em alvos
local animationTimer -- Inicializa a variável no escopo global do módulo
local interactionCompleted = false -- Controla o estado da interação

-- Posições-alvo para as setas
local targetPositions = {
    { x = display.contentCenterX - 250, y = display.contentCenterY + 25 },
    { x = display.contentCenterX - 250, y = display.contentCenterY + 150 }
}

-- Posição central da animação
local animationPosition = { x = display.contentCenterX + 150, y = display.contentCenterY + 100 }

-- Função para resetar variáveis de estado
local function resetInteractionState()
    arrowsInTargets = { arrow1 = false, arrow2 = false }
    interactionCompleted = false
    frameIndex = 1 -- Reinicia o índice dos frames
    -- Torna apenas o primeiro frame visível
    for i, frame in ipairs(frames) do
        frame.isVisible = (i == 1)
    end
end

-- Função para iniciar ou reiniciar a animação
local function startAnimation()
    -- Cancela o timer anterior, se existir
    if animationTimer then
        timer.cancel(animationTimer)
        animationTimer = nil
    end

    -- Reinicia a lógica de alternância dos frames
    animationTimer = timer.performWithDelay(100, function()
        -- Esconde o frame atual
        frames[frameIndex].isVisible = false
        -- Incrementa o índice do frame
        frameIndex = frameIndex + 1
        if frameIndex > totalFrames then
            frameIndex = 1 -- Reinicia a animação
        end
        -- Mostra o próximo frame
        frames[frameIndex].isVisible = true
    end, 0)
end

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Reseta o estado ao criar a cena
    resetInteractionState()

    -- Carrega a imagem de fundo
    local bg = display.newImageRect(sceneGroup, "assets/pages/pag-5/page_5.png", 768, 1024)
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY

    --botão volume
    local btnsom = display.newImage(sceneGroup, "/assets/bottons/som-ligado.png")
    btnsom.x = display.contentCenterX
    btnsom.y = display.contentCenterY + 400

    local text1 = display.newImage(sceneGroup, "assets/pages/pag-5/textoprincipal.png")
    text1.x = display.contentCenterX
    text1.y = 250

    -- Botão back
    local btnprev = display.newImage(sceneGroup, "/assets/bottons/back.png")
    btnprev.x = display.contentWidth - btnprev.width / 2 - MARGIN - 530
    btnprev.y = display.contentHeight - btnprev.height / 2 - MARGIN - 50

    -- Botão next
    local btnext = display.newImage(sceneGroup, "/assets/bottons/next.png")
    btnext.x = display.contentWidth - btnext.width / 2 - MARGIN - 40
    btnext.y = display.contentHeight - btnext.height / 2 - MARGIN - 50

    -- Alvos visuais para as setas
    local targets = {}
    for i, position in ipairs(targetPositions) do
        local target = display.newRect(sceneGroup, position.x, position.y, 100, 100)
        target:setFillColor(0, 1, 0, 0.3) -- Verde semitransparente
        targets[i] = target
    end

    -- Carregar as setas
    local arrows = {}
    arrows[1] = display.newImage(sceneGroup, "assets/pages/pag-5/arrows.png")
    arrows[2] = display.newImage(sceneGroup, "assets/pages/pag-5/arrows-1.png")

    -- Configura limites verticais para a posição das setas
    local arrowMinY = text1.y + 175
    local arrowMaxY = math.min(btnprev.y, btnext.y) - 50

    for _, arrow in ipairs(arrows) do
        arrow.x = math.random(50, display.contentWidth - 50)
        arrow.y = math.random(arrowMinY, arrowMaxY)
    end

    -- Carregar as 23 imagens da animação
    for i = 1, totalFrames do
        local frame = display.newImage(sceneGroup, "assets/pages/pag-5/DNA/" .. i .. ".png")
        frame.x = animationPosition.x
        frame.y = animationPosition.y
        frame.isVisible = (i == 1) -- Apenas o primeiro frame está visível inicialmente
        table.insert(frames, frame)
    end

    -- Inicia a animação do DNA
    startAnimation()

    -- Função para verificar se ambas as setas estão posicionadas corretamente
    local function checkAllArrows()
        if arrowsInTargets.arrow1 and arrowsInTargets.arrow2 and not interactionCompleted then
            interactionCompleted = true -- Marca a interação como concluída para evitar múltiplas ativações

            -- Move as setas em direção à animação
            transition.to(arrows[1], { x = animationPosition.x - 30, y = animationPosition.y, time = 500 })
            transition.to(arrows[2], { x = animationPosition.x + 30, y = animationPosition.y, time = 500, onComplete = function()
                -- Para a animação do DNA
                if animationTimer then -- Verifica se o timer existe antes de cancelar
                    timer.cancel(animationTimer)
                    animationTimer = nil
                end
                for _, frame in ipairs(frames) do
                    frame.isVisible = false -- Esconde todos os frames
                end

                -- Mostra a quebra do DNA na posição da animação
                local brokenLeft = display.newImage(sceneGroup, "assets/pages/pag-5/dna_broke_left.png")
                local brokenRight = display.newImage(sceneGroup, "assets/pages/pag-5/dna_broke_rigth.png")

                brokenLeft.x = animationPosition.x - 30
                brokenLeft.y = animationPosition.y

                brokenRight.x = animationPosition.x + 30
                brokenRight.y = animationPosition.y

                -- Faz os pedaços caírem
                transition.to(brokenLeft, { y = display.contentHeight + 100, time = 1000 })
                transition.to(brokenRight, {
                    y = display.contentHeight + 100,
                    time = 1000,
                    onComplete = function()
                        -- Aguarda 3 segundos antes de reiniciar a cena
                        timer.performWithDelay(1000, function()
                            composer.removeScene("pag5.pag_5", true)
                            composer.gotoScene("pag5.pag_5", {
                                effect = "fade",
                                time = 1000
                            })
                        end)
                    end
                })
            end })
        end
    end

    -- Função para verificar posições das setas
    local function checkPosition(arrow, arrowIndex)
        for i, target in ipairs(targets) do
            if math.abs(arrow.x - target.x) < 25 and math.abs(arrow.y - target.y) < 25 then
                arrowsInTargets["arrow" .. arrowIndex] = true
                checkAllArrows()
                return
            end
        end
        arrowsInTargets["arrow" .. arrowIndex] = false
    end

    -- Função para arrastar as setas
    local function dragArrow(event)
        if interactionCompleted then return end -- Ignora arrastar se a interação já foi concluída

        local arrow = event.target
        local arrowIndex = arrow == arrows[1] and 1 or 2

        if event.phase == "began" then
            display.getCurrentStage():setFocus(arrow)
            arrow.isFocus = true
        elseif event.phase == "moved" then
            arrow.x = event.x
            arrow.y = event.y
        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.getCurrentStage():setFocus(nil)
            arrow.isFocus = false

            -- Verifica posição após o movimento
            checkPosition(arrow, arrowIndex)
        end
    end

    -- Adiciona eventos de toque para as setas
    for _, arrow in ipairs(arrows) do
        arrow:addEventListener("touch", dragArrow)
    end

    btnprev:addEventListener("tap", function(event)
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_5")
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_5")
        composer.gotoScene("pag4.pag_4", {
            effect = "fade",
            time = 500
        })
    end)

    btnext:addEventListener("tap", function (event)
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_5")
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_5")
        composer.gotoScene("pag6.pag_6", {
            effect = "fade",
            time = 500
        });
        
    end)

    local som = display.newImage(sceneGroup, "assets/bottons/som-ligado.png")
    som.x = display.contentCenterX
    som.y = display.contentCenterY + 400

    backgroundSound = audio.loadStream("assets/audios/pag5.mp3")

    local function handleButtonTouch(event)
        if event.phase == "began" then
            local newImage
            if isSoundOn then
                audio.stop()
                isSoundOn = false
                newImage = display.newImage(sceneGroup, "assets/bottons/som-desligado.png")
            else
                audio.play(backgroundSound, { loops = -1 })
                isSoundOn = true
                newImage = display.newImage(sceneGroup, "assets/bottons/som-ligado.png")
            end
    
            newImage.x = som.x
            newImage.y = som.y
    
            som:removeEventListener("touch", handleButtonTouch)
            som:removeSelf()
            som = nil
    
            som = newImage
            som:addEventListener("touch", handleButtonTouch) 
        end
        return true
    end

    som:addEventListener("touch", handleButtonTouch)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "did" then
        if not isSoundOn then
            audio.play(backgroundSound, { loops = -1 })
            isSoundOn = true
        end
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        if isSoundOn then
            audio.stop()
            isSoundOn = false
        end
    end
end

-- destroy()
function scene:destroy(event)
    if backgroundSound then
        audio.dispose(backgroundSound)
        backgroundSound = nil
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
