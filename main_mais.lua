local lib = require("main_library")
local scene = lib.composer.newScene()

-- "scene:create()"
function scene:create( event )
    function ANDROID_RETURN_ACTION()
        lib.composer.gotoScene("main_menu")
    end
    
    local sceneGroup = self.view
    
    local layout
    
    function layout()
        
        local function botaoDeslogarTapped()
            
            local function funcaoRetorno(sim)
                if sim == 1 then
                    lib.removerCenas()
                    lib.composer.gotoScene("main_login")
                    lib.loadsave.saveTable(0,"logado.json")
                end
            end
            
            lib.confirmaSimNao(lib.textos.confirmarDeslogar,funcaoRetorno)
            
        end
        local function botaoVoltarTapped()
            lib.composer.gotoScene("main_menu")
        end
        
        local function funcaoRetornoCodigo()
            lib.composer.gotoScene("main_meuCadastro")
        end
        
        local function funcaoRetornoFalse()
        end
        
        local function funcaoRetorno(senha)
            lib.servicos({["nuCpf"] = lib.dadosUsuario.cpf , ["noSenha"] = senha},"mobile/usuario/autenticar",funcaoRetornoCodigo,funcaoRetornoFalse)
        end
        
        local function botaoCadastroTapped()
            lib.confirmarSenha(lib.textos.confirmarOperacao,funcaoRetorno)
        end
        local function botaoEditarCadastroTapped()
            lib.composer.gotoScene("main_editarCadastro")
        end
        local function botaoExtratoTapped()
            lib.mostrarExtrato()
        end
        local function botaoFaqTapped()
            
            if lib.faq ~=nil then
                lib.composer.gotoScene("main_faq")
            else
                lib.criarPopUp(lib.textos.servicoIndisponivel)
            end
            
            
        end
        
        local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
        backGround:scale(lib.scale,lib.scale)
        sceneGroup:insert(backGround)
        
        local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
        backGroundSecondLayer.anchorY = 0
        backGroundSecondLayer:scale(lib.scale,lib.scale)
        sceneGroup:insert(backGroundSecondLayer)
        
        local textoLogo = display.newText(sceneGroup, lib.textos.textLogoMais, lib.centerX, lib.topY+60, lib.textFont, 60)
        textoLogo = lib.maxWidth(textoLogo,380, 72)
        textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
        
        local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
        botaoVoltar:addEventListener("tap",botaoVoltarTapped)
        sceneGroup:insert(botaoVoltar)
        
        local caixaBrancaFundo = display.newImage("images/saldo/caixaBranca.png", lib.centerX, lib.centerY+80) 
        sceneGroup:insert(caixaBrancaFundo)
        
        
        local botaoCadastro = display.newImage("images/mais/botaoMeuCadastro.png", lib.centerX-10, lib.centerY-100)
        botaoCadastro:addEventListener("tap",botaoCadastroTapped)
        sceneGroup:insert(botaoCadastro)
        
        --        local botaoEditarCadastro = display.newImage("images/mais/botaoEditarCadastro.png", lib.centerX-10, lib.centerY+21)
        --        botaoEditarCadastro:addEventListener("tap",botaoEditarCadastroTapped)
        --        sceneGroup:insert(botaoEditarCadastro)
        --
        --        local botaoEsqueciSenha = display.newImage("images/mais/botaoEsqueciMinhaSenha.png", lib.centerX-10, lib.centerY+138)
        --        botaoEsqueciSenha:addEventListener("tap",lib.esqueciMinhaSenha)
        --        sceneGroup:insert(botaoEsqueciSenha)
        
        local botaoExtrato = display.newImage("images/mais/botaoExtrato.png", lib.centerX-10, lib.centerY+21)--138
        botaoExtrato:addEventListener("tap",botaoExtratoTapped)
        sceneGroup:insert(botaoExtrato)
        
        local botaoFaq = display.newImage("images/mais/botaoRegulamento.png", lib.centerX-10, lib.centerY+138)
        botaoFaq:addEventListener("tap",botaoFaqTapped)
        sceneGroup:insert(botaoFaq)
        
        local botaoDeslogar = display.newImage("images/mais/botaoSair.png", lib.centerX-10, lib.centerY+257)
        botaoDeslogar:addEventListener("tap",botaoDeslogarTapped)
        sceneGroup:insert(botaoDeslogar)
        
        
    end
    
    layout()
    
end

scene:addEventListener( "create", scene )

return scene