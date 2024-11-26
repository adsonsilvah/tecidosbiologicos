local composer = require( "composer" )
 
local scene = composer.newScene()

local audio = require("audio")
local backgroundSound 
local isSoundOn = false 

local MARGIN = 20
local boyRedness = 0 
local arrowSpeed = 1500 
-- create()
function scene:create( event )
    local sceneGroup = self.view

    -- Carrega a imagem de fundo
    local bg = display.newImageRect(sceneGroup, "assets/pages/pag-6/page_6.png", 768, 1024)
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY

    --botão volume
    local btnsom = display.newImage(sceneGroup, "/assets/bottons/som-ligado.png")
    btnsom.x = display.contentCenterX
    btnsom.y = display.contentCenterY + 400

    local text1 = display.newImage(sceneGroup, "assets/pages/pag-6/textoprincipal.png")
    text1.x = display.contentCenterX
    text1.y = 225

    local sol = display.newImage(sceneGroup, "assets/pages/pag-6/sol.png")
    sol.x = display.contentCenterX
    sol.y = display.contentCenterY - 115

    local praia = display.newImage(sceneGroup, "assets/pages/pag-6/praia.png")
    praia.x = display.contentCenterX
    praia.y = display.contentCenterY + 200

    local guarda = display.newImage(sceneGroup, "assets/pages/pag-6/guardasol.png")
    guarda.x = display.contentCenterX - 150
    guarda.y = display.contentCenterY + 220

    local boy = display.newImage(sceneGroup, "assets/pages/pag-6/boy.png")
    boy.x = display.contentCenterX
    boy.y = display.contentCenterY + 235
    -- Code here runs when the scene is first created but has not yet appeared on screen

     
    local function updateBoyColor()
        boyRedness = math.min(boyRedness + 0.1, 1) 
        boy:setFillColor(1, 1 - boyRedness, 1 - boyRedness) 


        if boyRedness >= 1 then
            timer.performWithDelay(500, function()
                boyRedness = 0 
                boy:setFillColor(1, 1, 1) 
            end)
        end
    end


    -- Função para criar as setas (raios solares)
    local function createArrow()
        local arrow = display.newImage(sceneGroup, "assets/pages/pag-6/setas.png")
        arrow.x = sol.x
        arrow.y = sol.y + 50

        transition.to(arrow, {
            x = boy.x,
            y = boy.y,
            time = arrowSpeed,
            onComplete = function()
                -- Verifica se o guarda-sol está protegendo o menino
                if math.abs(arrow.x - guarda.x) < 50 and math.abs(arrow.y - guarda.y) < 100 then
                    display.remove(arrow) 
                elseif math.abs(arrow.x - boy.x) < 50 and math.abs(arrow.y - boy.y) < 50 then
                    updateBoyColor() 
                    display.remove(arrow)
                else
                    display.remove(arrow)
                end
            end
        })
    end

    -- Função para arrastar o guarda-sol
    local function dragGuarda(event)
        if event.phase == "began" then
            display.getCurrentStage():setFocus(event.target)
            event.target.isFocus = true
        elseif event.phase == "moved" then
            event.target.x = event.x
            event.target.y = event.y
        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.getCurrentStage():setFocus(nil)
            event.target.isFocus = false
        end
        return true
    end

    
    guarda:addEventListener("touch", dragGuarda)

    
    timer.performWithDelay(1000, createArrow, 0)

    -- Botão "Voltar"
    local btprev = display.newImage(sceneGroup, "/assets/bottons/back.png")
    btprev.x = display.contentWidth - btprev.width / 2 - MARGIN - 530
    btprev.y = display.contentHeight - btprev.height / 2 - MARGIN - 50

    -- Botão "Próximo"
    local btnext = display.newImage(sceneGroup, "/assets/bottons/next.png")
    btnext.x = display.contentWidth - btnext.width / 2 - MARGIN - 40
    btnext.y = display.contentHeight - btnext.height / 2 - MARGIN - 50

    btprev:addEventListener("tap", function(event)
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_6")
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_6")
        composer.gotoScene("pag5.pag_5", {
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
        composer.removeScene("pag_6")
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_6")
        composer.gotoScene("Contracapa", {
            effect = "fade",
            time = 500
        });
        
    end)

    local som = display.newImage(sceneGroup, "assets/bottons/som-desligado.png")
    som.x = display.contentCenterX
    som.y = display.contentCenterY + 400

    backgroundSound = audio.loadStream("assets/audios/pag6.mp3")

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

-- show(), hide(), destroy() permanecem os mesmos
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene