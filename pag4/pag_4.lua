local composer = require("composer")
local scene = composer.newScene()
local audio = require("audio")
local MARGIN = 20
local physics = require("physics")
local backgroundSound 
local isSoundOn = false 
physics.start()

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Carrega a imagem de fundo
    local bg = display.newImageRect(sceneGroup, "assets/pages/pag-4/page_4.png", 768, 1024)
    bg.x = display.contentCenterX
    bg.y = display.contentCenterY

    --botão volume
    local btnsom = display.newImage(sceneGroup, "/assets/bottons/som-ligado.png")
    btnsom.x = display.contentCenterX
    btnsom.y = display.contentCenterY + 400

    local text1 = display.newImage(sceneGroup, "assets/pages/pag-4/textoprincipal.png")
    text1.x = display.contentCenterX
    text1.y = 200

    -- Elementos da cena
    local feixe = display.newImage(sceneGroup, "assets/pages/pag-4/feixe.png")
    feixe.x, feixe.y = display.contentCenterX - 250, 600

    local maquina = display.newImage(sceneGroup, "assets/pages/pag-4/maquina.png")
    maquina.x, maquina.y = display.contentCenterX + 175, 600

    local btninvisivel = display.newRect(sceneGroup, display.contentCenterX + 175, 600, 50, 50)
    btninvisivel.isVisible = false
    btninvisivel.isHitTestable = true 

    local maca = display.newImage(sceneGroup, "assets/pages/pag-4/maca.png")
    maca.x, maca.y = display.contentCenterX, 600

    local pessoa = display.newImage(sceneGroup, "assets/pages/pag-4/pessoa.png")
    pessoa.x, pessoa.y = display.contentCenterX, 600

    -- Imagem do raio-x (inicialmente invisível)
    local raiox = display.newImage(sceneGroup, "assets/pages/pag-4/raiox.png")
    raiox.x, raiox.y = display.contentCenterX, display.contentCenterY
    raiox.isVisible = false
    raiox:scale(0.1, 0.1) 

    -- Função para detectar movimento do acelerômetro
    local function onAccelerate(event)
        local xGravity = event.xGravity
        local yGravity = event.yGravity

        feixe.x = feixe.x + (xGravity * 50)
        feixe.y = feixe.y + (yGravity * 50)

        feixe.x = math.max(0, math.min(display.contentWidth, feixe.x))
        feixe.y = math.max(0, math.min(display.contentHeight, feixe.y))
    end

    -- Função para mostrar o raio-x com efeito de zoom
    local function showRaioX()
        raiox.isVisible = true
        transition.to(raiox, {
            xScale = 1,
            yScale = 1,
            time = 1000,
            transition = easing.outExpo
        })
    end

    -- Adiciona evento ao botão invisível
    btninvisivel:addEventListener("tap", function(event)
        if math.abs(feixe.x - pessoa.x) < 50 and math.abs(feixe.y - pessoa.y) < 50 then
            showRaioX()
        end
    end)

    -- Ativa o acelerômetro
    Runtime:addEventListener("accelerometer", onAccelerate)

    -- Botão "voltar"
    local btprev = display.newImage(sceneGroup, "/assets/bottons/back.png")
    btprev.x = display.contentWidth - btprev.width / 2 - MARGIN - 530
    btprev.y = display.contentHeight - btprev.height / 2 - MARGIN - 50
    btprev:addEventListener("tap", function(event)
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_4")
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("pag_4")
        composer.gotoScene("pag3.pag_3", {
            effect = "fade",
            time = 500
        })
    end)

    -- Botão "próximo"
    local btnext = display.newImage(sceneGroup, "/assets/bottons/next.png")
    btnext.x = display.contentWidth - btnext.width / 2 - MARGIN - 40
    btnext.y = display.contentHeight - btnext.height / 2 - MARGIN - 50
    btnext:addEventListener("tap", function (event)
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("cap_4")
        if backgroundSound then
            audio.stop()
            audio.dispose(backgroundSound)
            backgroundSound = nil
        end
        composer.removeScene("cap_4")
        composer.gotoScene("pag5.pag_5", {
            effect = "fade",
            time = 500
        });
        
    end)

    local som = display.newImage(sceneGroup, "assets/bottons/som-desligado.png")
    som.x = display.contentCenterX
    som.y = display.contentCenterY + 400

    backgroundSound = audio.loadStream("assets/audios/pag4.mp3")

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

    if phase == "will" then
        Runtime:removeEventListener("accelerometer", onAccelerate)
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view

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
