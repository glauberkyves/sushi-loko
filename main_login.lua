local lib = require("main_library")
local scene = lib.composer.newScene()

-- "scene:create()"
function scene:create( event )
  
    local sceneGroup = self.view
    
    local cena = "login"
    lib.tableDefaultText[cena], lib.tableText[cena] = {},{}
  
    local podeLogar = true
    local contErrors = 0
    local horaBloqueio
    
    local layout
    
    
    function layout()
        
        
        local function botaoEntrarTapped()
            
            local function funcaoRetorno(decoded)
                
                   local tabela = {}
                   tabela.id = decoded.dados.idUsuario
                   tabela.nome = decoded.dados.noPessoa or ""
                   tabela.cpf = decoded.dados.nuCpf or ""
                   tabela.email = decoded.dados.noEmail or ""
                   tabela.sexo = decoded.dados.sgSexo or "u"
                   tabela.dataNasc = decoded.dados.dtNascimento or "" 
                   tabela.cep = decoded.dados.nuCep or "" 
                
                
                   tabela.telefone = decoded.dados.nuTelefone or "5555555555"
                   tabela.cidade = decoded.dados.arrEndereco.noMunicipio or "bra"
                   tabela.estado = decoded.dados.arrEndereco.noEstado or "bra"
                   
                   local dia = tabela.dataNasc:sub(1,2)
                   local mes = tabela.dataNasc:sub(4,5)
                   local ano = tabela.dataNasc:sub(7,10)
                
                   lib.OneSignal.SendTags({["sexo"] = tabela.sexo,["cidade"] = tabela.cidade,["estado"] = tabela.estado,["dia"] = dia , ["mes"] = mes , ["ano"] = ano  });
                
                   lib.dadosUsuario = tabela 
                   lib.loadsave.saveTable(tabela, "dadosUsuario.json")   
                   lib.loadsave.saveTable(1,"logado.json") 
                   lib.dadosUsuario = lib.loadsave.loadTable("dadosUsuario.json")
                   lib.composer.gotoScene("main_menu")
                
            end
            local function funcaoRetornoFalse()
                local function voltaLogin()
                    podeLogar = true
                    print("pode logar!")
                end
                
                contErrors = contErrors +1
                if contErrors > 2 then
                    contErrors = 0
                    podeLogar = false
                    horaBloqueio = os.time()
                    timer.performWithDelay(30000, voltaLogin)
                end
                
            end
            
            
            sG = string.gsub
            local cpf , senha = sG(lib.tableText[cena][1].text," ",""),sG(lib.tableText[cena][2].text," ","")
            if cpf =="" or senha =="" then
                lib.criarPopUp(lib.textos.prenchaCampos)
            elseif podeLogar == false then
                                
                 local horaAtual = os.time() 
                 print(horaAtual,horaBloqueio)
                 local tempoRestante =  30 - (horaAtual-horaBloqueio )  
                 local msg
                   msg = lib.textos.seguranca..tempoRestante..lib.textos.segundos
                 
                 lib.criarPopUp(msg)
                
            else
                
                lib.servicos({["nuCpf"] = cpf , ["noSenha"] = senha},"mobile/usuario/autenticar",funcaoRetorno,funcaoRetornoFalse)
                
            end
            
        end
        local function botaoCadastrarTapped()
            lib.composer.gotoScene("main_cadastrar")
        end
        
        local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
        backGround:scale(lib.scale,lib.scale)
        sceneGroup:insert(backGround)
        
        local opts = {
        top = lib.topY,
        left = lib.leftX,
        width = lib.distanceX,
        height = lib.distanceY,
        horizontalScrollDisabled = true,
        verticalScrollDisabled = true,
        hideBackground = true,
        hideScrollBar  = true ,
        backgroundColor = { 1,1,1 },
        }   
        lib.scrollView[cena] = lib.widget.newScrollView(opts)  
        sceneGroup:insert(lib.scrollView[cena])
        

        local logo = display.newImage("images/login/logo.png", lib.centerX-lib.leftX, lib.centerY-330) 
        lib.scrollView[cena]:insert(logo)
        
        local campoLogin = display.newImage("images/login/campoTexto.png", lib.centerX-lib.leftX, lib.centerY-80) 
        campoLogin.textEdit = 1
        campoLogin.cena = cena
        campoLogin:addEventListener("tap", lib.campTapped)
        lib.scrollView[cena]:insert(campoLogin)
        
        lib.tableDefaultText[cena][1] = display.newText( lib.textos.logintext, 0, 0,lib.textFont, 60)
        lib.tableDefaultText[cena][1].x = lib.centerX-lib.leftX-265
        lib.tableDefaultText[cena][1].anchorX = 0
        lib.tableDefaultText[cena][1].y = lib.centerY-80
        lib.tableDefaultText[cena][1]:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
        lib.scrollView[cena]:insert(lib.tableDefaultText[cena][1])
        
        lib.tableText[cena][1] = display.newText( "", 0, 0,lib.textFont, 60)
        lib.tableText[cena][1].x = lib.centerX-lib.leftX-265
        lib.tableText[cena][1].anchorX = 0
        lib.tableText[cena][1].y = lib.centerY-80
        lib.tableText[cena][1]:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[3])
        lib.scrollView[cena]:insert(lib.tableText[cena][1])
        
        local campoSenha = display.newImage("images/login/campoTexto.png", lib.centerX-lib.leftX, lib.centerY+70) 
        campoSenha.textEdit = 2
        campoSenha.cena = cena
        campoSenha.isSecure = true
        campoSenha:addEventListener("tap", lib.campTapped)
        lib.scrollView[cena]:insert(campoSenha)
        
        lib.tableDefaultText[cena][2] = display.newText( lib.textos.loginSenha, 0, 0,lib.textFont, 60)
        lib.tableDefaultText[cena][2].x = lib.centerX-lib.leftX-265
        lib.tableDefaultText[cena][2].anchorX = 0
        lib.tableDefaultText[cena][2].y = lib.centerY+70
        lib.tableDefaultText[cena][2]:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
        lib.scrollView[cena]:insert(lib.tableDefaultText[cena][2])
        
        lib.tableText[cena][2] = display.newText( "", 0, 0,lib.passFont, 60)
        lib.tableText[cena][2].x = lib.centerX-lib.leftX-265
        lib.tableText[cena][2].anchorX = 0
        lib.tableText[cena][2].y = lib.centerY+70
        lib.tableText[cena][2]:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[3])
        lib.scrollView[cena]:insert(lib.tableText[cena][2])
        
        local botaoEntrar = display.newImage("images/login/botaoEntrar.png", lib.centerX-lib.leftX, lib.centerY+245) 
        botaoEntrar:addEventListener("tap",botaoEntrarTapped)
        lib.scrollView[cena]:insert(botaoEntrar)
        
        local botaoEsqueciSenha = display.newImage("images/login/botaoEsqueciMinhaSenha.png", lib.centerX-lib.leftX - 150, lib.bottomY-85) 
        botaoEsqueciSenha:addEventListener("tap",lib.esqueciMinhaSenha)
        lib.scrollView[cena]:insert(botaoEsqueciSenha)
        
        local botaoCadastrar = display.newImage("images/login/botaoCadastrar.png", lib.centerX-lib.leftX + 150, lib.bottomY-85) 
        botaoCadastrar:addEventListener("tap",botaoCadastrarTapped)
        lib.scrollView[cena]:insert(botaoCadastrar)
        
        
        
    end
  
    
    layout()
   
  
end


scene:addEventListener( "create", scene )


return scene

