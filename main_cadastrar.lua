local lib = require("main_library")
local scene = lib.composer.newScene()

-- "scene:create()"
function scene:create( event )
    
    function ANDROID_RETURN_ACTION()
        lib.composer.gotoScene("main_login")
    end
    
    local sceneGroup = self.view
    
    local cena = "cadastro"
    lib.tableDefaultText[cena], lib.tableText[cena] = {},{}
    
    local campoSexoMCliqued , campoSexoFCliqued , sexo
    
    local layout
    
    
    function layout()
        
        local campoSexoMText , campoSexoFText
        
        local function botaoCadastrarTapped()
            
            
            
            
            local sG = string.gsub
            local nome,sobrenome,cpf,data,cep,email,telefone,senha,confSenha = lib.tableText[cena][1].text,lib.tableText[cena][2].text,lib.tableText[cena][3].text,lib.tableText[cena][4].text,lib.tableText[cena][5].text,lib.tableText[cena][6].text,lib.tableText[cena][7].text,lib.tableText[cena][8].text,lib.tableText[cena][9].text
            local checkCep = lib.cepMask.getRealText(cep)
            local checkData = lib.dataMask.getRealText(data)
            local checkCpf = lib.cpfMask.getRealText(cpf)
            local checkTelefone =  lib.phoneMask.getRealText(telefone)
            local finalName = nome.." "..sobrenome
            local finalData = checkData:sub(1,2).."/"..checkData:sub(3,4).."/"..checkData:sub(5,8)
            
            local function funcaoRetorno(decoded)
                
                
                local function logar()
                    
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
                    
                    lib.servicos({["nuCpf"] = cpf , ["noSenha"] = senha},"mobile/usuario/autenticar",funcaoRetorno)
                    
                end
                
                lib.composer.gotoScene("main_login")
                lib.criarPopUp(decoded.mensagem,logar,true)
                
            end
            
            if nome == ""  then
                lib.criarPopUp(lib.textos.preenchaNome)
                
            elseif   checkData == "" then
                lib.criarPopUp(lib.textos.preenchaDataNasc)
                
            elseif   checkTelefone == "" then
                lib.criarPopUp(lib.textos.preenchaTelefone)
                
            elseif   email == "" then
                lib.criarPopUp(lib.textos.preenchaEmail)     
                
            elseif  senha ~=   confSenha then     
                lib.criarPopUp(lib.textos.senhasNaoConferem) 
                
            elseif    string.len(senha) <6 then
                lib.criarPopUp(lib.textos.senha6digitos)
                
            elseif  string.len(checkCpf) ~= 11 then
                lib.criarPopUp(lib.textos.cpfIncompleto)    
                
            elseif lib.validarCpf(checkCpf) == false then
                lib.criarPopUp(lib.textos.cpfInvalido) 
                
            elseif sexo == nil then
                lib.criarPopUp(lib.textos.selecioneSexo)
                
            elseif  senha ~=   confSenha then     
                print(senha, confSenha)
                lib.criarPopUp(lib.textos.novasSenhasNaoConferem) 
                
            elseif  senha ~= "" and  string.len(senha) <6 then
                lib.criarPopUp(lib.textos.novaSenha6digitos)
                
            elseif  string.len(checkData) ~= 8 then
                lib.criarPopUp(lib.textos.dataIncompleta)
                
            elseif string.len(checkTelefone)< 8  then
                lib.criarPopUp(lib.textos.telefoneIncompleto) 
            else 
                lib.servicos({["nuCpf"] = checkCpf , ["nuTelefone"] = checkTelefone ,["dtNascimento"] = checkData, ["noSenha"] = senha, ["noPessoa"] = finalName, ["noEmail"] = email,["sgSexo"] = sexo,["nuCep"] = checkCep},"mobile/usuario/cadastrar",funcaoRetorno)
            end
        end
        
        local function botaoVoltarTapped()
            lib.composer.gotoScene("main_login")
        end
        
        local function sexoMTapped()
            sexo = "M"
            campoSexoMCliqued.alpha = 1 
            campoSexoFCliqued.alpha = 0
            campoSexoMText:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[3])
            campoSexoFText:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
            
        end
        local function sexoFTapped()
            sexo = "F"
            campoSexoMCliqued.alpha = 0 
            campoSexoFCliqued.alpha = 1
            campoSexoFText:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[3])
            campoSexoMText:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
        end
        
        local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
        backGround:scale(lib.scale,lib.scale)
        sceneGroup:insert(backGround)
        
        local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
        backGroundSecondLayer.anchorY = 0
        backGroundSecondLayer:scale(lib.scale,lib.scale)
        sceneGroup:insert(backGroundSecondLayer)
        
        local textoLogo = display.newText(sceneGroup, lib.textos.cadastrar, lib.centerX, lib.topY+60, lib.textFont, 60)
        textoLogo = lib.maxWidth(textoLogo,380, 72)
        textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
        
        local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
        botaoVoltar:addEventListener("tap",botaoVoltarTapped)
        sceneGroup:insert(botaoVoltar)
        
        local barrinhaVermalhaCima = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.topY+126)
        barrinhaVermalhaCima:scale(lib.scale,1)
        sceneGroup:insert(barrinhaVermalhaCima)
        
        local barrinhaVermalhaBaixo = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.bottomY-127)
        barrinhaVermalhaBaixo:scale(lib.scale,1)
        sceneGroup:insert(barrinhaVermalhaBaixo)
        
        
        local opts = {
            top = lib.topY+132,
            left = lib.leftX,
            width = lib.distanceX,
            height = lib.distanceY-264,
            bottomPadding = 90,
            horizontalScrollDisabled = true,
            verticalScrollDisabled = false,
            hideBackground = false,
            hideScrollBar  = true ,
            backgroundColor = {lib.scrollViewBackColor[1],lib.scrollViewBackColor[2],lib.scrollViewBackColor[3] },
        }   
        lib.scrollView[cena] = lib.widget.newScrollView(opts)  
        sceneGroup:insert(lib.scrollView[cena])
        
        
        local botaoCadastrar = display.newImage("images/cadastro/botaoCadastrar.png", lib.centerX, lib.bottomY-60)
        botaoCadastrar:addEventListener("tap",botaoCadastrarTapped)
        sceneGroup:insert(botaoCadastrar)
        
        
        local campoSexoM = display.newImage("images/cadastro/botaoSexoDesmarcado.png", lib.centerX-lib.leftX-225, 375)
        campoSexoM:addEventListener("tap",sexoMTapped)
        lib.scrollView[cena]:insert(campoSexoM) 
        
        campoSexoMText = display.newText(lib.textos.masculino, lib.centerX-lib.leftX-175, campoSexoM.y, lib.textFont, 40)
        campoSexoMText = lib.maxWidth(campoSexoMText,150, 56)
        campoSexoMText.anchorX = 0
        campoSexoMText:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
        lib.scrollView[cena]:insert(campoSexoMText) 
        
        local campoSexoF = display.newImage("images/cadastro/botaoSexoDesmarcado.png", lib.centerX-lib.leftX+75,campoSexoM.y)
        campoSexoF:addEventListener("tap",sexoFTapped)
        lib.scrollView[cena]:insert(campoSexoF)
        
        campoSexoFText = display.newText(lib.textos.feminino , lib.centerX-lib.leftX+125, campoSexoM.y, lib.textFont, 40)
        campoSexoFText = lib.maxWidth(campoSexoFText,150, 56)
        campoSexoFText.anchorX = 0
        campoSexoFText:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
        lib.scrollView[cena]:insert(campoSexoFText) 
        
        campoSexoMCliqued = display.newImage("images/cadastro/botaoSexoMasculino.png", lib.centerX-lib.leftX-225, campoSexoM.y)
        campoSexoMCliqued.alpha = 0
        lib.scrollView[cena]:insert(campoSexoMCliqued) 
        
        campoSexoFCliqued = display.newImage("images/cadastro/botaoSexoFeminino.png", lib.centerX-lib.leftX+75, campoSexoM.y)
        campoSexoFCliqued.alpha = 0
        lib.scrollView[cena]:insert(campoSexoFCliqued)
        
        
        local campoNome = display.newImage("images/cadastro/campoTexto.png", lib.centerX-lib.leftX, 70)
        campoNome.textEdit = 1
        campoNome.cena = cena
        campoNome.maxChar = 35
        campoNome.inputType = "default"
        campoNome.mask = "noMask"
        campoNome.maxHeight = 60
        campoNome:addEventListener("tap", lib.campTapped)
        lib.scrollView[cena]:insert(campoNome)
        
        lib.tableDefaultText[cena][1] = display.newText( lib.textos.nome, 0, 0,lib.textFont, 40)
        lib.tableDefaultText[cena][1].x = lib.centerX-lib.leftX-265
        lib.tableDefaultText[cena][1].anchorX = 0
        lib.tableDefaultText[cena][1].y = campoNome.y
        lib.tableDefaultText[cena][1]:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
        lib.scrollView[cena]:insert(lib.tableDefaultText[cena][1])
        
        lib.tableText[cena] [1] = display.newText( "", 0, 0,lib.textFont, 40)
        lib.tableText[cena] [1].x = lib.centerX-lib.leftX-265
        lib.tableText[cena] [1].anchorX = 0
        lib.tableText[cena] [1].y = campoNome.y
        lib.tableText[cena] [1]:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[3])
        lib.scrollView[cena]:insert(lib.tableText[cena] [1])
        
        local campoSobreNome = display.newImage("images/cadastro/campoTexto.png", lib.centerX-lib.leftX, 170)
        campoSobreNome.textEdit = 2
        campoSobreNome.cena = cena
        campoSobreNome.maxChar = 35
        campoSobreNome.inputType = "default"
        campoSobreNome.mask = "noMask"
        campoSobreNome.maxHeight = 60
        campoSobreNome:addEventListener("tap", lib.campTapped)
        lib.scrollView[cena]:insert(campoSobreNome)
        
        lib.tableDefaultText[cena][2] = display.newText( lib.textos.sobrenome, 0, 0,lib.textFont, 40)
        lib.tableDefaultText[cena][2].x = lib.centerX-lib.leftX-265
        lib.tableDefaultText[cena][2].anchorX = 0
        lib.tableDefaultText[cena][2].y = campoSobreNome.y
        lib.tableDefaultText[cena][2]:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
        lib.scrollView[cena]:insert(lib.tableDefaultText[cena][2])
        
        lib.tableText[cena] [2] = display.newText( "", 0, 0,lib.textFont, 40)
        lib.tableText[cena] [2].x = lib.centerX-lib.leftX-265
        lib.tableText[cena] [2].anchorX = 0
        lib.tableText[cena] [2].y = campoSobreNome.y
        lib.tableText[cena] [2]:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[3])
        lib.scrollView[cena]:insert(lib.tableText[cena] [2])
        
        
        local campoCpf = display.newImage("images/cadastro/campoTexto.png", lib.centerX-lib.leftX, 270)
        campoCpf.textEdit = 3
        campoCpf.cena = cena
        campoCpf.maxChar = 11
        campoCpf.inputType = "number"
        campoCpf.mask = "cpfMask"
        campoCpf.maxHeight = 60
        campoCpf:addEventListener("tap", lib.campTapped)
        lib.scrollView[cena]:insert(campoCpf)
        
        lib.tableDefaultText[cena][3] = display.newText( lib.textos.cpf, 0, 0,lib.textFont, 40)
        lib.tableDefaultText[cena][3].x = lib.centerX-lib.leftX-265
        lib.tableDefaultText[cena][3].anchorX = 0
        lib.tableDefaultText[cena][3].y = campoCpf.y
        lib.tableDefaultText[cena][3]:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
        lib.scrollView[cena]:insert(lib.tableDefaultText[cena][3])
        
        lib.tableText[cena] [3] = display.newText( "", 0, 0,lib.textFont, 40)
        lib.tableText[cena] [3].x = lib.centerX-lib.leftX-265
        lib.tableText[cena] [3].anchorX = 0
        lib.tableText[cena] [3].y = campoCpf.y
        lib.tableText[cena] [3]:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[3])
        lib.scrollView[cena]:insert(lib.tableText[cena] [3])
        
        local campoData = display.newImage("images/cadastro/campoTexto.png", lib.centerX-lib.leftX, 480)
        campoData.textEdit = 4
        campoData.cena = cena
        campoData.maxChar = 8
        campoData.inputType = "number"
        campoData.mask = "dataMask"
        campoData.maxHeight = 60
        campoData:addEventListener("tap", lib.campTapped)
        lib.scrollView[cena]:insert(campoData)
        
        lib.tableDefaultText[cena][4] = display.newText( lib.textos.dataNasc, 0, 0,lib.textFont, 40)
        lib.tableDefaultText[cena][4].x = lib.centerX-lib.leftX-265
        lib.tableDefaultText[cena][4].anchorX = 0
        lib.tableDefaultText[cena][4].y = campoData.y
        lib.tableDefaultText[cena][4]:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
        lib.scrollView[cena]:insert(lib.tableDefaultText[cena][4])
        
        lib.tableText[cena] [4] = display.newText( "", 0, 0,lib.textFont, 40)
        lib.tableText[cena] [4].x = lib.centerX-lib.leftX-265
        lib.tableText[cena] [4].anchorX = 0
        lib.tableText[cena] [4].y = campoData.y
        lib.tableText[cena] [4]:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[3])
        lib.scrollView[cena]:insert(lib.tableText[cena] [4])
        
        local campoCep = display.newImage("images/cadastro/campoTexto.png", lib.centerX-lib.leftX, 580)
        campoCep.textEdit = 5
        campoCep.cena = cena
        campoCep.maxChar = 8
        campoCep.inputType = "number"
        campoCep.mask = "cepMask"
        campoCep.maxHeight = 60
        campoCep:addEventListener("tap", lib.campTapped)
        lib.scrollView[cena]:insert(campoCep)
        
        lib.tableDefaultText[cena][5] = display.newText( lib.textos.cep, 0, 0,lib.textFont, 40)
        lib.tableDefaultText[cena][5].x = lib.centerX-lib.leftX-265
        lib.tableDefaultText[cena][5].anchorX = 0
        lib.tableDefaultText[cena][5].y = campoCep.y
        lib.tableDefaultText[cena][5]:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
        lib.scrollView[cena]:insert(lib.tableDefaultText[cena][5])
        
        lib.tableText[cena] [5] = display.newText( "", 0, 0,lib.textFont, 40)
        lib.tableText[cena] [5].x = lib.centerX-lib.leftX-265
        lib.tableText[cena] [5].anchorX = 0
        lib.tableText[cena] [5].y = campoCep.y
        lib.tableText[cena] [5]:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[3])
        lib.scrollView[cena]:insert(lib.tableText[cena] [5])
        
        
        local campoEmail = display.newImage("images/cadastro/campoTexto.png", lib.centerX-lib.leftX, 680)
        campoEmail.textEdit = 6
        campoEmail.cena = cena
        campoEmail.maxChar = 50
        campoEmail.inputType = "default"
        campoEmail.mask = "noMask"
        campoEmail.maxHeight = 60
        campoEmail:addEventListener("tap", lib.campTapped)
        lib.scrollView[cena]:insert(campoEmail)
        
        lib.tableDefaultText[cena][6] = display.newText( lib.textos.email, 0, 0,lib.textFont, 40)
        lib.tableDefaultText[cena][6].x = lib.centerX-lib.leftX-265
        lib.tableDefaultText[cena][6].anchorX = 0
        lib.tableDefaultText[cena][6].y = campoEmail.y
        lib.tableDefaultText[cena][6]:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
        lib.scrollView[cena]:insert(lib.tableDefaultText[cena][6])
        
        lib.tableText[cena] [6] = display.newText( "", 0, 0,lib.textFont, 40)
        lib.tableText[cena] [6].x = lib.centerX-lib.leftX-265
        lib.tableText[cena] [6].anchorX = 0
        lib.tableText[cena] [6].y = campoEmail.y
        lib.tableText[cena] [6]:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[3])
        lib.scrollView[cena]:insert(lib.tableText[cena] [6])
        
        local campoTelefone = display.newImage("images/cadastro/campoTexto.png", lib.centerX-lib.leftX, 780)
        campoTelefone.textEdit = 7
        campoTelefone.cena = cena
        campoTelefone.maxChar = 50
        campoTelefone.inputType = "number"
        campoTelefone.mask = "phoneMask"
        campoTelefone.maxHeight = 60
        campoTelefone:addEventListener("tap", lib.campTapped)
        lib.scrollView[cena]:insert(campoTelefone)
        
        lib.tableDefaultText[cena][7] = display.newText( lib.textos.telefone, 0, 0,lib.textFont, 40)
        lib.tableDefaultText[cena][7].x = lib.centerX-lib.leftX-265
        lib.tableDefaultText[cena][7].anchorX = 0
        lib.tableDefaultText[cena][7].y = campoTelefone.y
        lib.tableDefaultText[cena][7]:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
        lib.scrollView[cena]:insert(lib.tableDefaultText[cena][7])
        
        lib.tableText[cena] [7] = display.newText( "", 0, 0,lib.textFont, 40)
        lib.tableText[cena] [7].x = lib.centerX-lib.leftX-265
        lib.tableText[cena] [7].anchorX = 0
        lib.tableText[cena] [7].y = campoTelefone.y
        lib.tableText[cena] [7]:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[3])
        lib.scrollView[cena]:insert(lib.tableText[cena] [7])
        
        local campoSenha = display.newImage("images/cadastro/campoTexto.png", lib.centerX-lib.leftX, 880)
        campoSenha.textEdit = 8
        campoSenha.cena = cena
        campoSenha.maxChar = 50
        campoSenha.isSecure = true
        campoSenha.inputType = "default"
        campoSenha.mask = "noMask"
        campoSenha.maxHeight = 60
        campoSenha:addEventListener("tap", lib.campTapped)
        lib.scrollView[cena]:insert(campoSenha)
        
        lib.tableDefaultText[cena][8] = display.newText( lib.textos.senha, 0, 0,lib.textFont, 40)
        lib.tableDefaultText[cena][8].x = lib.centerX-lib.leftX-265
        lib.tableDefaultText[cena][8].anchorX = 0
        lib.tableDefaultText[cena][8].y = campoSenha.y
        lib.tableDefaultText[cena][8]:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
        lib.scrollView[cena]:insert(lib.tableDefaultText[cena][8])
        
        lib.tableText[cena] [8] = display.newText( "", 0, 0,lib.passFont, 40)
        lib.tableText[cena] [8].x = lib.centerX-lib.leftX-265
        lib.tableText[cena] [8].anchorX = 0
        lib.tableText[cena] [8].y = campoSenha.y
        lib.tableText[cena] [8]:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[3])
        lib.scrollView[cena]:insert(lib.tableText[cena] [8])
        
        local campoConfSenha = display.newImage("images/cadastro/campoTexto.png", lib.centerX-lib.leftX, 980)
        campoConfSenha.textEdit = 9
        campoConfSenha.cena = cena
        campoConfSenha.maxChar = 50
        campoConfSenha.isSecure = true
        campoConfSenha.inputType = "default"
        campoConfSenha.mask = "noMask"
        campoConfSenha.maxHeight = 60
        campoConfSenha:addEventListener("tap", lib.campTapped)
        lib.scrollView[cena]:insert(campoConfSenha)
        
        lib.tableDefaultText[cena][9] = display.newText( lib.textos.confSenha, 0, 0,lib.textFont, 40)
        lib.tableDefaultText[cena][9].x = lib.centerX-lib.leftX-265
        lib.tableDefaultText[cena][9].anchorX = 0
        lib.tableDefaultText[cena][9].y = campoConfSenha.y
        lib.tableDefaultText[cena][9]:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
        lib.scrollView[cena]:insert(lib.tableDefaultText[cena][9])
        
        lib.tableText[cena] [9] = display.newText( "", 0, 0,lib.passFont, 40)
        lib.tableText[cena] [9].x = lib.centerX-lib.leftX-265
        lib.tableText[cena] [9].anchorX = 0
        lib.tableText[cena] [9].y = campoConfSenha.y
        lib.tableText[cena] [9]:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[3])
        lib.scrollView[cena]:insert(lib.tableText[cena] [9])
        
    end
    
    layout()
    
    
end

scene:addEventListener( "create", scene )

return scene

