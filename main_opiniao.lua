local lib = require("main_library")
local scene = lib.composer.newScene()

local textBox, createTextBox, deleteTextBox
local textboxText = ""

function deleteTextBox()
    textBox:removeSelf()
    textBox = nil
end

function createTextBox()
    
    local function textBoxListener(textEvent)
        
        if ( textEvent.phase == "began" ) then
            
            
        elseif ( textEvent.phase == "ended" or textEvent.phase == "submitted" ) then
            
            
        elseif ( textEvent.phase == "editing" ) then
            
            
            
        end
        
    end
    
    textBox = native.newTextBox(lib.centerX, lib.centerY-80, 603, 162)
    textBox.isEditable = true
    textBox.isFontSizeScaled = true  
    textBox.size = 40
    textBox.hasBackground = false
    textBox.placeholder = lib.textos.digiteOpiniao
    textBox:addEventListener( "userInput", textBoxListener )
    
end

-- "scene:create()"
function scene:create( event )
    
    local sceneGroup = self.view
    
    local layout
    local tableDefaultText , tableText = {} , {}
    
    function campTapped(event)
        
        local maxChar =  event.target.maxChar or 50
        local mask = event.target.mask or "noMask"
        local inputType = event.target.inputType or "default"
        local maxWidth = event.target.maxWidth or 580
        local maxHeight = event.target.maxHeight or 88
        tableDefaultText[event.target.textEdit].alpha = 0
        
        local function focusTextField()
            
            native.setKeyboardFocus(textField)
            
            
        end
        
        local function deleteTextField(ob)
            
            
            if textField.text == "" then
                
                tableDefaultText[event.target.textEdit].alpha = 1
                tableText[event.target.textEdit].text = ""
                
            end
            
            textField:removeSelf()
            textField = nil
            native.setKeyboardFocus( nil )
            
            ob.target:removeSelf()
            ob.target = nil
            
            -- print( lib.cpfMask.getRealText(tableText[event.target.textEdit].text) )
            
            
            
            --                local opts = {
            --                y = 0,
            --                time = 300,
            --                }
            --                scrollView:scrollToPosition( opts ) 
            
            -- return true
            
        end
        
        local function textos(textEvent)
            
            if ( textEvent.phase == "began" ) then
                
                
                -- tableText[event.target.textEdit].text = lib[mask].apply("")
                
                textField.text = lib[mask].getRealText(tableText[event.target.textEdit].text)
                tableText[event.target.textEdit].text = lib[mask].apply(textField.text)
                
            elseif ( textEvent.phase == "ended" or textEvent.phase == "submitted" ) then
                
                
            elseif ( textEvent.phase == "editing" ) then
                
                
                if string.len(textField.text) <= maxChar then
                    
                    tableText[event.target.textEdit].text = lib[mask].apply(textField.text)
                    tableText[event.target.textEdit] = lib.maxWidth(tableText[event.target.textEdit],maxWidth, maxHeight)
                    
                    
                else
                    
                    textField.text =  string.sub(textField.text,1,maxChar)  
                    
                end
                
            end
            
        end 
        
        textField = native.newTextField( 0,-1000, 447, 50 )
        textField.x = -1000
        textField.y = -1000
        textField.inputType = inputType
        textField:addEventListener( "userInput", textos )
        
        deleteRect = display.newRect( lib.leftX, lib.topY, lib.distanceX, lib.distanceY)
        deleteRect:setFillColor(1,0,0)
        deleteRect.alpha = 0.01
        deleteRect.anchorX = 0
        deleteRect.anchorY = 0
        deleteRect:addEventListener("touch",deleteTextField)
        
        timer.performWithDelay(200, focusTextField)
        
    end
    
    function layout()
        
        function ANDROID_RETURN_ACTION()
            if textBox then
                textBox:removeSelf()
                textBox = nil
            end
            
            --best to remove keyboard focus, in case keyboard is still on screen
            native.setKeyboardFocus(nil)
            
            lib.composer.gotoScene("main_menu")
        end
        
        local tabLojaSelecionada
        local lojaSelecionada
        local item1Text,item2Text,item3Text
        local item1,item2,item3  = 0,0,0
        local estrelasItem1,estrelasItem2,estrelasItem3 = {},{},{}
        local estrelasItem1Amarela,estrelasItem2Amarela,estrelasItem3Amarela = {},{},{}
        
        
        local function textBoxSaiDaTela()
            textBox.x = -1000
            textBox.y = -1000
        end
        local function textBoxVoltaNaTela()
            if textBox then
                textBox.x = lib.centerX
                textBox.y = lib.centerY-80                
            end
        end
        
        local function botaoVoltarTapped()
            textboxText = textBox.text
            deleteTextBox()
            lib.composer.gotoScene("main_menu")
        end
        local function mudaItem1(event)
            item1 = event.target.item
            for i = 1,4 do
                estrelasItem1Amarela[i].alpha = 0
            end
            for i = 1,event.target.item do
                estrelasItem1Amarela[i].alpha = 1
            end
        end
        local function mudaItem2(event)
            item2 = event.target.item
            for i = 1,4 do
                estrelasItem2Amarela[i].alpha = 0
            end
            for i = 1,event.target.item do
                estrelasItem2Amarela[i].alpha = 1
            end
        end
        local function mudaItem3(event)
            item3 = event.target.item
            for i = 1,4 do
                estrelasItem3Amarela[i].alpha = 0
            end
            for i = 1,event.target.item do
                estrelasItem3Amarela[i].alpha = 1
            end
        end
        local function botaoConcluidoTapped()
            
            local function funcaoRetornoOpiniao(decoded)
                lib.criarPopUp(decoded.mensagem,textBoxVoltaNaTela,true)
            end
            
            if tabLojaSelecionada == nil then
                
                textBoxSaiDaTela()
                lib.criarPopUp(lib.textos.selecioneUmaLoja,textBoxVoltaNaTela) 
                
            elseif item1 == 0 or item2 == 0 or item3 == 0 then
                
                textBoxSaiDaTela()
                lib.criarPopUp(lib.textos.coloqueEstrela,textBoxVoltaNaTela) 
                
            else
                
                textBoxSaiDaTela()
                
                local tabResposta = {
                    {idResposta = lib.opiniao.item1.id,nuResposta = item1 },
                    {idResposta = lib.opiniao.item2.id,nuResposta = item2 },
                    {idResposta = lib.opiniao.item3.id,nuResposta = item3 },
                }
                
                lib.servicos({["tipo"]= 2,["idRequisicao"] = "",["idUsuario"] = lib.dadosUsuario.id ,["idFranquia"]=tabLojaSelecionada.id, ["dsResposta"] = textBox.text,["arrResposta"] = tabResposta },"mobile/feedback/responder",funcaoRetornoOpiniao)
                
            end
            
        end
        local function botaoSelecionarLojaTapped()
            local function funcRetornoLojas(tabLoja)
                tabLojaSelecionada = tabLoja
                print(tabLojaSelecionada.id,tabLojaSelecionada.nome)
                lojaSelecionada.text = tabLojaSelecionada.nome
                lojaSelecionada = lib.maxWidth(lojaSelecionada,550, 44)
            end
            
            textBoxSaiDaTela()
            lib.mostrarCidadesOpiniao(funcRetornoLojas,textBoxVoltaNaTela)
        end
        local function backgroundTapped()
            native.setKeyboardFocus( nil )
        end
        
        local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
        backGround:addEventListener("tap",backgroundTapped)
        backGround:scale(lib.scale,lib.scale)
        sceneGroup:insert(backGround)
        
        local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
        backGroundSecondLayer.anchorY = 0
        backGroundSecondLayer:scale(lib.scale,lib.scale)
        sceneGroup:insert(backGroundSecondLayer)
        
        local textoLogo = display.newText(sceneGroup, lib.textos.deSuaOpiniao, lib.centerX+20, lib.topY+60, lib.textFont, 60)
        textoLogo = lib.maxWidth(textoLogo,380, 72)
        textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
        
        local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
        botaoVoltar:addEventListener("tap",botaoVoltarTapped)
        sceneGroup:insert(botaoVoltar)
        
        lojaSelecionada = display.newText(sceneGroup, lib.textos.nenhumaLojaSelecionada, lib.centerX,lib.topY+150, lib.textFont, 36)
        lojaSelecionada:setFillColor(lib.textEnqueteColor[1],lib.textEnqueteColor[2],lib.textEnqueteColor[3])
        
        local botaoSelecionarLoja = display.newImage("images/opiniao/botaoSelecionarLoja.png", lib.centerX, lib.topY+240)
        botaoSelecionarLoja:addEventListener("tap",botaoSelecionarLojaTapped)
        sceneGroup:insert(botaoSelecionarLoja)
        
        local campoOpiniao = display.newImage("images/opiniao/caixa.png", lib.centerX, lib.centerY-80)
        campoOpiniao:addEventListener("tap",textBoxVoltaNaTela)
        sceneGroup:insert(campoOpiniao)
        
        
        item1Text = display.newText(sceneGroup, lib.opiniao.item1.nome, lib.centerX - 295, lib.centerY+80, lib.textFont, 36)
        item1Text.anchorX = 0
        item1Text = lib.maxWidth(item1Text,180, 44)
        item1Text:setFillColor(lib.textEnqueteColor[1],lib.textEnqueteColor[2],lib.textEnqueteColor[3])
        
        for i = 1,4 do
            estrelasItem1[i] = display.newImage("images/opiniao/botaoEstrela.png", lib.centerX - 180+(i*110), lib.centerY+70)
            estrelasItem1[i].item = i
            estrelasItem1[i]:addEventListener("tap",mudaItem1)
            sceneGroup:insert( estrelasItem1[i])
        end
        for i = 1,4 do
            estrelasItem1Amarela[i] = display.newImage("images/opiniao/botaoEstrelaClicado.png", lib.centerX - 180+(i*110), lib.centerY+70)
            estrelasItem1Amarela[i].alpha = 0
            sceneGroup:insert( estrelasItem1Amarela[i])
        end
        
        
        item2Text = display.newText(sceneGroup, lib.opiniao.item2.nome, lib.centerX - 295, lib.centerY+170, lib.textFont, 36)
        item2Text = lib.maxWidth(item2Text,180, 44)
        item2Text.anchorX = 0
        item2Text:setFillColor(lib.textEnqueteColor[1],lib.textEnqueteColor[2],lib.textEnqueteColor[3])
        
        for i = 1,4 do
            estrelasItem2[i] = display.newImage("images/opiniao/botaoEstrela.png", lib.centerX - 180+(i*110), lib.centerY+160)
            estrelasItem2[i].item = i
            estrelasItem2[i]:addEventListener("tap",mudaItem2)
            sceneGroup:insert( estrelasItem2[i])
        end
        for i = 1,4 do
            estrelasItem2Amarela[i] = display.newImage("images/opiniao/botaoEstrelaClicado.png", lib.centerX - 180+(i*110), lib.centerY+160)
            estrelasItem2Amarela[i].alpha = 0
            sceneGroup:insert( estrelasItem2Amarela[i])
        end
        
        item3Text = display.newText(sceneGroup, lib.opiniao.item3.nome, lib.centerX - 295, lib.centerY+260, lib.textFont, 36)
        item3Text = lib.maxWidth(item3Text,180, 44)
        item3Text.anchorX = 0
        item3Text:setFillColor(lib.textEnqueteColor[1],lib.textEnqueteColor[2],lib.textEnqueteColor[3])
        
        for i = 1,4 do
            estrelasItem3[i] = display.newImage("images/opiniao/botaoEstrela.png", lib.centerX - 180+(i*110), lib.centerY+250)
            estrelasItem3[i].item = i
            estrelasItem3[i]:addEventListener("tap",mudaItem3)
            sceneGroup:insert( estrelasItem3[i])
        end
        for i = 1,4 do
            estrelasItem3Amarela[i] = display.newImage("images/opiniao/botaoEstrelaClicado.png", lib.centerX - 180+(i*110), lib.centerY+250)
            estrelasItem3Amarela[i].alpha = 0
            sceneGroup:insert( estrelasItem3Amarela[i])
        end
        
        
        local botaoConcluido = display.newImage("images/opiniao/botaoConcluido.png", lib.centerX, lib.bottomY - 100)
        botaoConcluido:addEventListener("tap",botaoConcluidoTapped)
        sceneGroup:insert(botaoConcluido)
        
        
    end
    
    layout()
    
end

function scene:show( event )
    
    local sceneGroup = self.view
    local phase = event.phase
    
    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        createTextBox()
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

return scene

