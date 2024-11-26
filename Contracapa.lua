local composer = require( "composer" )
local scene = composer.newScene()
local audio = require("audio")
local backgroundSound 
local isSoundOn = false 

local MARGIN = 20

 
-- create()
function scene:create( event )
    local sceneGroup = self.view

    -- Carrega a imagem de fundo
    local bg = display.newImageRect(sceneGroup, "assets/pages/contracapa/contracapa.png", 768, 1024)
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY

    --botão volume
    local btnsom = display.newImage(sceneGroup, "/assets/bottons/som-desligado.png")
    btnsom.x = display.contentCenterX
    btnsom.y = display.contentCenterY + 400

    -- Code here runs when the scene is first created but has not yet appeared on screen
    --botão de voltar
    local btprev = display.newImage(sceneGroup, "/assets/bottons/back.png")
    btprev.x = display.contentWidth - btprev.width/2 - MARGIN - 530
    btprev.y = display.contentHeight - btprev.height/2 - MARGIN - 50

    btprev:addEventListener("tap", function (event)
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("Contracapa")
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("Contracapa")
        composer.gotoScene("pag6.pag_6", {
            effect = "fade",
            time = 500
        });
        
    end)


    --botão home
    local bthome = display.newImage(sceneGroup, "/assets/bottons/home.png")
    bthome.x = display.contentWidth - bthome.width/2 - MARGIN - 40
    bthome.y = display.contentHeight - bthome.height/2 - MARGIN - 50

    bthome:addEventListener("tap", function (event)
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("Contracapa")
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("Contracapa")
        composer.gotoScene("Capa", {
            effect = "fade",
            time = 500
        });

        local som = display.newImage(sceneGroup, "assets/bottons/som-desligado.png")
    som.x = display.contentCenterX
    som.y = display.contentCenterY + 400

    backgroundSound = audio.loadStream("assets/audios/contracapa.mp3")

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
        
    end)
    
end
 
 
-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "did" then
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
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene