local lib = require("main_library")
local scene = lib.composer.newScene()

-- "scene:create()"
function scene:create( event )
  
    local sceneGroup = self.view
    
    local scrollView
    
    
    local layout
    
    
    function layout()
        
        local function botaoVoltarTapped()
            lib.composer.gotoScene("main_mais")
        end
        local function botaoEditarTapped()
             lib.composer.gotoScene("main_editarCadastro")
        end
        
        local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
        backGround:scale(lib.scale,lib.scale)
        sceneGroup:insert(backGround)
        
        
        local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
        backGroundSecondLayer.anchorY = 0
        backGroundSecondLayer:scale(lib.scale,lib.scale)
        sceneGroup:insert(backGroundSecondLayer)

        local textoLogo = display.newText(sceneGroup, lib.textos.textLogoMeuCadastro, lib.centerX, lib.topY+60, lib.textFont, 60)
        textoLogo = lib.maxWidth(textoLogo,380, 72)
        textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
        
        local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
        botaoVoltar:addEventListener("tap",botaoVoltarTapped)
        sceneGroup:insert(botaoVoltar)
        
        local botaoEditar = display.newImage("images/perfil/botaoEditarCadastro.png", lib.centerX-150, lib.topY+207)
        botaoEditar:addEventListener("tap",botaoEditarTapped)
        sceneGroup:insert(botaoEditar)
        
        local botaoEsqueciMinhaSenha = display.newImage("images/perfil/botaoEsqueciMinhaSenha.png", lib.centerX+150, lib.topY+207)
        botaoEsqueciMinhaSenha:addEventListener("tap",lib.esqueciMinhaSenha)
        sceneGroup:insert(botaoEsqueciMinhaSenha)
        
        local opts = {
            top = lib.topY+303,
            left = lib.leftX,
            width = lib.distanceX,
            height = lib.distanceY-314,
            bottomPadding = 60,
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
        
        
        
        local nomeTitulo = display.newText( lib.textos.nome, lib.centerX-lib.leftX, 60, lib.textFont, 48)
        nomeTitulo:setFillColor(lib.saldoColor[1],lib.saldoColor[2],lib.saldoColor[3])
        scrollView:insert(nomeTitulo)
        
        local nomeValor = display.newText( lib.dadosUsuario.nome, lib.centerX-lib.leftX, nomeTitulo.y+60, lib.textFont, 48)
        nomeValor = lib.maxWidth(nomeValor,600, 56)
        nomeValor:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
        scrollView:insert(nomeValor)
        
        local sexoTitulo = display.newText( lib.textos.sexo, lib.centerX-lib.leftX, nomeTitulo.y+130, lib.textFont, 48)
        sexoTitulo:setFillColor(lib.saldoColor[1],lib.saldoColor[2],lib.saldoColor[3])
        scrollView:insert(sexoTitulo)
        
        local sexoValor = display.newText( lib.mostraSexo(lib.dadosUsuario.sexo), lib.centerX-lib.leftX, nomeTitulo.y+190, lib.textFont, 48)
        sexoValor = lib.maxWidth(sexoValor,600, 56)
        sexoValor:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
        scrollView:insert(sexoValor)
        
        local nascimentoTitulo = display.newText( lib.textos.minhaDataNasc, lib.centerX-lib.leftX, nomeTitulo.y+260, lib.textFont, 48)
        nascimentoTitulo:setFillColor(lib.saldoColor[1],lib.saldoColor[2],lib.saldoColor[3])
        scrollView:insert(nascimentoTitulo)
        
        local nascimentoValor = display.newText( lib.dataMask.apply( lib.dadosUsuario.dataNasc), lib.centerX-lib.leftX, nomeTitulo.y+320, lib.textFont, 48)
        nascimentoValor = lib.maxWidth(nascimentoValor,600, 56)
        nascimentoValor:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
        scrollView:insert(nascimentoValor)
        
        local cpfTitulo = display.newText( lib.textos.cpf, lib.centerX-lib.leftX, nomeTitulo.y+390, lib.textFont, 48)
        cpfTitulo:setFillColor(lib.saldoColor[1],lib.saldoColor[2],lib.saldoColor[3])
        scrollView:insert(cpfTitulo)
        
        local cpfValor = display.newText( lib.cpfMask.apply( lib.dadosUsuario.cpf), lib.centerX-lib.leftX, nomeTitulo.y+450, lib.textFont, 48)
        cpfValor = lib.maxWidth(cpfValor,600, 56)
        cpfValor:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
        scrollView:insert(cpfValor)
        
        local telefoneTitulo = display.newText( lib.textos.telefone, lib.centerX-lib.leftX, nomeTitulo.y+520, lib.textFont, 48)
        telefoneTitulo:setFillColor(lib.saldoColor[1],lib.saldoColor[2],lib.saldoColor[3])
        scrollView:insert(telefoneTitulo)
        
        
        local telefoneValor = display.newText( string.gsub(lib.phoneMask.apply(lib.dadosUsuario.telefone),"_",""), lib.centerX-lib.leftX, nomeTitulo.y+580, lib.textFont, 48)
        telefoneValor = lib.maxWidth(telefoneValor,600, 56)
        telefoneValor:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
        scrollView:insert(telefoneValor)
        
        local emailTitulo = display.newText(lib.textos.email, lib.centerX-lib.leftX, nomeTitulo.y+650, lib.textFont, 48)
        emailTitulo:setFillColor(lib.saldoColor[1],lib.saldoColor[2],lib.saldoColor[3])
        scrollView:insert(emailTitulo)
        
        local emailValor = display.newText( lib.dadosUsuario.email, lib.centerX-lib.leftX, nomeTitulo.y+710, lib.textFont, 48)
        emailValor = lib.maxWidth(emailValor,600, 56)
        emailValor:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
        scrollView:insert(emailValor)
        
    end
    
    
    layout()
    

end

scene:addEventListener( "create", scene )

return scene

