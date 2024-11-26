local composer = require("composer")
local scene = composer.newScene()
local audio = require("audio")
local MARGIN = 20
local backgroundSound 
local isSoundOn = false 
local images = {
    "assets/pages/pag-2/braco.png",
    "assets/pages/pag-2/epitelial.png",
    "assets/pages/pag-2/conjutivo.png",
    "assets/pages/pag-2/muscular.png",
    "assets/pages/pag-2/nervous.png"
}

local currentImageIndex = 1
local currentImage = nil
    
-- Função para carregar e exibir a imagem atual
local function loadImage(index)
    if currentImage then
        currentImage:removeSelf()
        currentImage = nil
    end
    currentImage = display.newImage(images[index])
    currentImage.x = display.contentCenterX
    currentImage.y = display.contentCenterY
    currentImage.width = 300  -- Define a largura como 300
    currentImage.height = 300 -- Define a altura como 300
end
-- create()
function scene:create( event )
    local sceneGroup = self.view

    -- Carrega a imagem de fundo
    local bg = display.newImageRect(sceneGroup, "assets/pages/pag-2/page_2.png", 768, 1024)
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY

    local text1 = display.newImage(sceneGroup, "assets/pages/pag-2/textoprincipal.png")
    text1.x = display.contentCenterX
    text1.y = 200
    
    loadImage(currentImageIndex)

    -- Função de zoom (movimento de pinça)
    local function onPinch(event)
        local phase = event.phase
        local scale = event.scale
    
        if phase == "ended" then
            if scale > 1.2 then -- Detecta gesto de "zoom in"
                currentImageIndex = currentImageIndex + 1
            elseif scale < 0.8 then -- Detecta gesto de "zoom out"
                currentImageIndex = currentImageIndex - 1
            end
    
            -- Mantém o índice dentro dos limites
            if currentImageIndex < 1 then
                currentImageIndex = 1
            elseif currentImageIndex > #images then
                currentImageIndex = #images
            end
    
            -- Carrega a nova imagem
            loadImage(currentImageIndex)
        end
    end
    
    -- Listener para detectar movimento multitouch
    local function onTouch(event)
        if event.numTaps == 2 or event.numTouches == 2 then
            -- Detecção do movimento de pinça
            local touches = event.touches
            if touches and #touches == 2 then
                onPinch(event)
            end
        end
        return true
    end
    
    -- Habilitar multitouch
    system.activate("multitouch")
    
    -- Adiciona o listener de toque global
    Runtime:addEventListener("touch", onTouch)

    --botão back
    local btprev = display.newImage(sceneGroup, "/assets/bottons/back.png")
    btprev.x = display.contentWidth - btprev.width/2 - MARGIN - 500
    btprev.y = display.contentHeight - btprev.height/2 - MARGIN - 50
    --botão next
    local btnext = display.newImage(sceneGroup, "/assets/bottons/next.png")
    btnext.x = display.contentWidth - btnext.width/2 - MARGIN - 40
    btnext.y = display.contentHeight - btnext.height/2 - MARGIN - 50

    btprev:addEventListener("tap", function(event)
        if currentImage then
            currentImage:removeSelf()
            currentImage = nil
        end        
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_2")
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_2")
        composer.gotoScene("Capa", {
            effect = "fade",
            time = 500
        })
    end)

    btnext:addEventListener("tap", function (event)
        if currentImage then
            currentImage:removeSelf()
            currentImage = nil
        end        
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_2")
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_2")
        composer.gotoScene("pag3.pag_3", {
            effect = "fade",
            time = 500
        });
        
    end)

    local som = display.newImage(sceneGroup, "assets/bottons/som-desligado.png")
    som.x = display.contentCenterX
    som.y = display.contentCenterY + 400

    backgroundSound = audio.loadStream("assets/audios/pag2.mp3")

    local function handleButtonTouch(event)
        if event.phase == "began" then
            local newImage
            if isSoundOn then
                audio.stop()
                isSoundOn = false
                newImage = display.newImage(sceneGroup, "assets/bottons/som-ligado.png")
            else
                audio.play(backgroundSound, { loops = 0 })
                isSoundOn = true
                newImage = display.newImage(sceneGroup, "assets/bottons/som-desligado.png")
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

    if phase == "did" then
        if not currentImage then
            loadImage(currentImageIndex)
        end

        -- Reproduz o som de fundo
        if not isSoundOn then
            audio.play(backgroundSound, { loops = 0 })
            isSoundOn = true
        end
    end
end



-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Remove a imagem atual ao sair da página
        if currentImage then
            currentImage:removeSelf()
            currentImage = nil
        end

        -- Para o som de fundo se estiver ativo
        if isSoundOn then
            audio.stop()
            isSoundOn = false
        end
    end
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