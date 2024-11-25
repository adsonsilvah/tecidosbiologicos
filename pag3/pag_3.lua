local composer = require("composer")
local scene = composer.newScene()
local audio = require("audio")

local MARGIN = 20
local sun -- Declaração global do objeto `sun` para reiniciar sua posição
local backgroundSound 
local isSoundOn = false 


function scene:create(event)
    local sceneGroup = self.view

    -- Carrega a imagem de fundo
    local bg = display.newImageRect(sceneGroup, "assets/pages/pag-3/page_3.png", 768, 1024)
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY

    --botão volume
    local btnsom = display.newImage(sceneGroup, "/assets/bottons/som-ligado.png")
    btnsom.x = display.contentCenterX
    btnsom.y = display.contentCenterY + 400

    local text1 = display.newImage(sceneGroup, "assets/pages/pag-3/textoprincipal.png")
    text1.x = display.contentCenterX
    text1.y = 200

    -- Criação do objeto `sun`
    sun = display.newImageRect(sceneGroup, "assets/pages/pag-3/sun_shiny.png", 150, 150)
    sun.x, sun.y = 100, 425 -- Posição inicial do sol

    local zerohoras = display.newImage(sceneGroup, "assets/pages/pag-3/0horas.png", 150, 150)
    zerohoras.x, zerohoras.y = 100, 525

    local fourhoras = display.newImage(sceneGroup, "assets/pages/pag-3/4horas.png", 150, 150)
    fourhoras.x, fourhoras.y = display.contentCenterX, 525

    local sixhours = display.newImage(sceneGroup, "assets/pages/pag-3/6horas.png", 150, 150)
    sixhours.x, sixhours.y = display.contentWidth - 100, 525

    local images = {
        display.newImageRect(sceneGroup, "assets/pages/pag-3/saudavel.png", 650, 250),
        display.newImageRect(sceneGroup, "assets/pages/pag-3/queimadura.png", 650, 250),
        display.newImageRect(sceneGroup, "assets/pages/pag-3/grave.png", 650, 250)
    }

    -- Configuração inicial das imagens
    for i, img in ipairs(images) do
        img.x, img.y = 400, 700
        img.alpha = (i == 1) and 1 or 0
    end

    -- Limites para a troca de imagens
    local minX = 100
    local midX = display.contentCenterX
    local maxX = display.contentWidth - 100

    -- Função para atualizar as imagens com transições suaves
    local function updateImages(posX)
        if midX <= minX or maxX <= midX then
            print("Erro nos limites: Verifique minX, midX e maxX")
            return
        end

        -- Transição entre a primeira e a segunda imagem (do início ao meio da tela)
        if posX <= midX then
            local progress = (posX - minX) / (midX - minX)
            progress = math.max(0, math.min(1, progress))
            images[1].alpha = 1 - progress
            images[2].alpha = progress
            images[3].alpha = 0
        -- Transição entre a segunda e a terceira imagem (do meio ao final da tela)
        elseif posX > midX and posX <= maxX then
            local progress = (posX - midX) / (maxX - midX)
            progress = math.max(0, math.min(1, progress))
            images[1].alpha = 0
            images[2].alpha = 1 - progress
            images[3].alpha = progress
        end
    end

    -- Função de toque para arrastar o sol
    local function onTouch(event)
        if event.phase == "began" then
            display.currentStage:setFocus(event.target)
            event.target.touchOffsetX = event.x - event.target.x
        elseif event.phase == "moved" then
            local newX = event.x - event.target.touchOffsetX

            -- Restringir o movimento dentro dos limites
            if newX < minX then
                newX = minX
            elseif newX > maxX then
                newX = maxX
            end

            event.target.x = newX

            -- Atualizar as imagens com base na posição do sol
            updateImages(newX)
        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.currentStage:setFocus(nil)
        end
        return true
    end

    -- Adicionar o evento de toque ao sol
    sun:addEventListener("touch", onTouch)

    -- Botão "voltar"
    local btprev = display.newImage(sceneGroup, "assets/bottons/back.png")
    btprev.x = display.contentWidth - btprev.width / 2 - MARGIN - 530
    btprev.y = display.contentHeight - btprev.height / 2 - MARGIN - 50

    -- Botão "próximo"
    local btnext = display.newImage(sceneGroup, "assets/bottons/next.png")
    btnext.x = display.contentWidth - btnext.width / 2 - MARGIN - 40
    btnext.y = display.contentHeight - btnext.height / 2 - MARGIN - 50

    btprev:addEventListener("tap", function(event)
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_3")
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_3")
        composer.gotoScene("pag2.pag_2", {
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
        composer.removeScene("pag_3")
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_3")
        composer.gotoScene("pag4.pag_4", {
            effect = "fade",
            time = 500
        });
        
    end)

    local som = display.newImage(sceneGroup, "assets/bottons/som-ligado.png")
    som.x = display.contentCenterX
    som.y = display.contentCenterY + 400

    backgroundSound = audio.loadStream("assets/audios/pag3.mp3")

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

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "did" then
        if not isSoundOn then
            audio.play(backgroundSound, { loops = -1 })
            isSoundOn = true
        end
    end

    if (phase == "will") then
        if sun then
            sun.x, sun.y = 100, 425
        end
    elseif (phase == "did") then
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

    -- if (phase == "will") then
    --     -- Código para quando a cena está prestes a sair
    -- elseif (phase == "did") then
    --     -- Código para quando a cena sai completamente
    -- end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
    -- Código para limpar recursos (se necessário)
    if backgroundSound then
        audio.dispose(backgroundSound)
        backgroundSound = nil
    end
end

-- Scene event function listeners
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene