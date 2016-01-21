
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
        
        local saldoText ,  textocodigo , textoUltimoCodigo
        
        local function botaoVoltarTapped()
            lib.composer.gotoScene("main_menu")
        end
        local function obterSaldo()
            
            local function funcaoRetorno(decoded)
                
                saldoText.text = lib.textos.sifrao..decoded.credito 
                saldoText = lib.maxWidth(saldoText,530,184)
                if decoded.codigo ~=nil and decoded.codigo ~= "" then
                    textocodigo.text = decoded.codigo
                    textocodigo.alpha = 1
                    textoUltimoCodigo.alpha = 1
                end
                
            end
            
            lib.servicos({["idUsuario"] = lib.dadosUsuario.id },"mobile/transacao/credito/usuario",funcaoRetorno)
            
        end
        local function usarSaldo(valor)
            
            local function funcaoRetornoCodigo(decoded)
                
                
                lib.criarPopUp(lib.textos.informeOCodigo..lib.textos.ultimoCodigo..decoded.codigo,nil,true) 
                textocodigo.text = decoded.codigo
                
            end
            
            local function funcaoRetorno(senha)
                print( lib.dadosUsuario.id,senha,valor)
                lib.servicos({["idUsuario"] = lib.dadosUsuario.id ,["noSenha"] = senha, ["nuValor"] = valor},"mobile/transacao/bonus/obter-senha",funcaoRetornoCodigo)
            end
            
            lib.confirmarSenha(lib.textos.confirmarOperacao,funcaoRetorno)
        end
        local function usarSaldoTapped()
            
            
            lib.confirmarValor(usarSaldo)
            
        end
        
        
        local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
        backGround:scale(lib.scale,lib.scale)
        sceneGroup:insert(backGround)
        
        local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
        backGroundSecondLayer.anchorY = 0
        backGroundSecondLayer:scale(lib.scale,lib.scale)
        sceneGroup:insert(backGroundSecondLayer)
        
        local textoLogo = display.newText(sceneGroup, lib.textos.textLogoSaldo, lib.centerX, lib.topY+60, lib.textFont, 60)
        textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
        
        local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
        botaoVoltar:addEventListener("tap",botaoVoltarTapped)
        sceneGroup:insert(botaoVoltar)
        
        local caixaBrancaFundo = display.newImage("images/saldo/caixaBranca.png", lib.centerX, lib.centerY+80) 
        sceneGroup:insert(caixaBrancaFundo)
        
        local fundoBrancaFundo = display.newImage("images/saldo/fundoCaixaBranca.png", lib.centerX+128, lib.centerY-228) 
        sceneGroup:insert(fundoBrancaFundo)
        
        local botaoAtualizarSaldo = display.newImage("images/saldo/botaoAtualizar.png", lib.centerX+148, lib.centerY-223) 
        botaoAtualizarSaldo:addEventListener("tap",obterSaldo)
        sceneGroup:insert(botaoAtualizarSaldo)
        
        local botaoUsarSaldo = display.newImage("images/saldo/botaoUsar.png", lib.centerX, lib.centerY+240) 
        botaoUsarSaldo:addEventListener("tap",usarSaldoTapped)
        sceneGroup:insert(botaoUsarSaldo)
        
        saldoText = display.newText(lib.textos.zeroReais, lib.centerX, lib.centerY-20,lib.textFont,125)
        saldoText:setFillColor(lib.saldoColor[1],lib.saldoColor[2],lib.saldoColor[3])
        sceneGroup:insert(saldoText)
        
        local options = {
            text = lib.textos.bonusParaUsar,
            x =  lib.centerX, 
            y = lib.centerY+110,
            width = 530,
            height = 116,
            font = lib.textFont,
            fontSize = 48,
            align = "center", 
            
        }
        local textoExplicacaoSaldo = display.newText( options )
        textoExplicacaoSaldo:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
        sceneGroup:insert(textoExplicacaoSaldo)
        
        
        textoUltimoCodigo = display.newText( sceneGroup, lib.textos.ultimoCodigo, lib.centerX-80, lib.centerY-120, lib.textFont ,48 )
        textoUltimoCodigo = lib.maxWidth(textoUltimoCodigo,320, 56)
        textoUltimoCodigo:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
        textoUltimoCodigo.alpha = 0
        
        textocodigo = display.newText( sceneGroup, "----", lib.centerX+170, lib.centerY-118, "Arial" ,48 )
        textocodigo:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
        textocodigo.alpha = 0
        
        
        obterSaldo()
        
    end
    
    
    layout()
    
end

scene:addEventListener( "create", scene )

return scene

