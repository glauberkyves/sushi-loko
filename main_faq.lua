
local lib = require("main_library")
local scene = lib.composer.newScene()

-- "scene:create()"

function scene:create( event )
  
    local sceneGroup = self.view
    
    local function botaoVoltarTapped()
            lib.composer.gotoScene("main_mais")
    end
    local function buttonTapped(event)
        
        print(event.target.pergunta,event.target.resposta)
        lib.detalhesFaq(event.target.pergunta,event.target.resposta)
        
    end

    local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
    backGround:scale(lib.scale,lib.scale)
    sceneGroup:insert(backGround)

    local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
    backGroundSecondLayer.anchorY = 0
    backGroundSecondLayer:scale(lib.scale,lib.scale)
    sceneGroup:insert(backGroundSecondLayer)

    local textoLogo = lib.maxWidth(display.newText(sceneGroup, lib.textos.titulofaq, lib.centerX, lib.topY+60, lib.textFont, 60),380,72) 
    textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
    
    local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
    botaoVoltar:addEventListener("tap",botaoVoltarTapped)
    sceneGroup:insert(botaoVoltar)
    
    local textOpts = {
        --parent = textGroup,
        text = lib.textos.conhecaPerguntas,     
        x = lib.centerX,
        y = lib.topY +210,
        width = lib.distanceX - 60,     --required for multi-line and alignment
        font = lib.textFont,   
        fontSize = 48,
        align = "center"  --new alignment parameter
    }
    
    local textDescricao = display.newText(textOpts)
    textDescricao:setFillColor(lib.textEnqueteColor[1],lib.textEnqueteColor[2],lib.textEnqueteColor[3])
    sceneGroup:insert(textDescricao)
    
    local opts = {
        top = lib.topY+303,
        left = lib.leftX,
        width = lib.distanceX,
        height = lib.distanceY-314,
        bottomPadding = 50,
        horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
        hideBackground = false,
        hideScrollBar  = true ,
        backgroundColor = {lib.scrollViewBackColor[1],lib.scrollViewBackColor[2],lib.scrollViewBackColor[3] },
        }   
    scrollView = lib.widget.newScrollView(opts)  
    sceneGroup:insert(scrollView)

    local barrinhaVermalhaCima = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.topY+297)
    barrinhaVermalhaCima:scale(lib.scale,1)
    sceneGroup:insert(barrinhaVermalhaCima)

    local barrinhaVermalhaBaixo = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.bottomY-6)
    barrinhaVermalhaBaixo:scale(lib.scale,1)
    sceneGroup:insert(barrinhaVermalhaBaixo)
    
    
    local buttons = {}
    
    local perguntaOpts = {
         --parent = scrollView,
        text ="oi oi oi oi o",     
        x = lib.centerX,
        y = 0,
        width = 550 ,     --required for multi-line and alignment
        --height = 120,
        font = lib.textFont,   
        fontSize = 36,
        align = "center"  --new alignment parameter
    }
    
    for i = 1, #lib.faq do
        
        buttons[i] = {}
        
        buttons[i].botao = display.newImage("images/alertas/botao.png", lib.centerX-lib.leftX, i*160-70)
        buttons[i].botao.pergunta = lib.faq[i].pergunta
        buttons[i].botao.resposta = lib.faq[i].resposta
        buttons[i].botao:addEventListener("tap",buttonTapped)
        scrollView:insert(buttons[i].botao)
        
        
        buttons[i].textPergunta = display.newText(perguntaOpts)
        buttons[i].textPergunta.text = lib.faq[i].pergunta
        buttons[i].textPergunta.y = i*160-70
        buttons[i].textPergunta = lib.maxHeight(buttons[i].textPergunta,550,120)
        buttons[i].textPergunta:setFillColor(lib.textEnqueteColor[1],lib.textEnqueteColor[2],lib.textEnqueteColor[3])
        scrollView:insert(buttons[i].textPergunta)
        
        
        
    end


end

scene:addEventListener( "create", scene )

return scene


