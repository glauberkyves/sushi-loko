local lib = require("main_library")
local scene = lib.composer.newScene()

-- "scene:create()"
function scene:create( event )
    function ANDROID_RETURN_ACTION()
        native.requestExit()
    end
    
    local sceneGroup = self.view
    
    local layout , progressao ,  progressaoGrupo , urlCompraOnline
    local bonusMask = graphics.newMask("images/menu/bonusMask.png")
    
    function layout()
        local function botaoCreditosTapped()
            lib.composer.gotoScene("main_saldo")
        end
        local function botaoMaisTapped() 
            lib.composer.gotoScene("main_mais")
        end
        local function botaoOpiniaoTapped()
            
            local function retornoOpiniao(decoded)
                
                lib.opiniao = {}
                lib.opiniao.ativo = decoded.opiniaoAtiva
                lib.opiniao.id = decoded.opiniao.idFeedBack
                
                lib.opiniao.item1  = {}
                lib.opiniao.item1.id = decoded.opiniao.arrResposta[1].idResposta
                lib.opiniao.item1.nome = decoded.opiniao.arrResposta[1].noResposta
                
                lib.opiniao.item2  = {}
                lib.opiniao.item2.id = decoded.opiniao.arrResposta[2].idResposta
                lib.opiniao.item2.nome = decoded.opiniao.arrResposta[2].noResposta
                
                lib.opiniao.item3  = {}
                lib.opiniao.item3.id = decoded.opiniao.arrResposta[3].idResposta
                lib.opiniao.item3.nome = decoded.opiniao.arrResposta[3].noResposta
                
                
                
                if  lib.opiniao.ativo == true then
                    lib.composer.gotoScene("main_opiniao")
                else
                    lib.criarPopUp(lib.textos.opiniaoFalse)
                end
                
            end
            
            
            if  lib.opiniao.ativo == true then
                lib.composer.gotoScene("main_opiniao")
            else
                lib.servicos({["idUsuario"] = lib.dadosUsuario.id },"mobile/enquete/listar",retornoOpiniao)
            end
            
            
        end
        local function botaoLojasTapped()
            
            local function retornoLojas()
                lib.composer.gotoScene("main_lojas")
            end
            
            if lib.cidadeSelecionada == nil then
                lib.mostrarLojas(retornoLojas)
            else
                retornoLojas()
            end
            
        end
        local function botaoComparOnlineTapped()
            if urlCompraOnline == nil or urlCompraOnline == "" then
                lib.criarPopUp(lib.textos.servicoIndisponivel)
            else
                system.openURL(urlCompraOnline)
            end
        end
        
        
        local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
        backGround:scale(lib.scale,lib.scale)
        sceneGroup:insert(backGround)
        
        local caixaFundo = display.newImage("images/menu/caixaDeMenu.png", lib.centerX, lib.centerY+10)
        sceneGroup:insert(caixaFundo)
        
        local botaoCompraOnline = display.newImage("images/menu/botaoComprarOnline.png",  lib.centerX+128, lib.centerY-293)
        botaoCompraOnline:addEventListener("tap",botaoComparOnlineTapped)
        sceneGroup:insert(botaoCompraOnline)
        
        local logo = display.newImage("images/menu/logo.png", lib.centerX - 160, lib.centerY-313)
        sceneGroup:insert(logo)
        
        local botaoCreditos = display.newImage("images/menu/botaoMeusCreditos.png", lib.centerX-10, lib.centerY-170)
        botaoCreditos:addEventListener("tap",botaoCreditosTapped)
        sceneGroup:insert(botaoCreditos)
        
        local botaoLojas = display.newImage("images/menu/botaoLojas.png", lib.centerX-10, lib.centerY-52)
        botaoLojas:addEventListener("tap",botaoLojasTapped) 
        sceneGroup:insert(botaoLojas)
        
        local botaoOpiniao = display.newImage("images/menu/botaoOpiniao.png", lib.centerX-10, lib.centerY+67)
        botaoOpiniao:addEventListener("tap",botaoOpiniaoTapped)
        sceneGroup:insert(botaoOpiniao)
        
        local botaoMais = display.newImage("images/menu/botaoMais.png", lib.centerX-10, lib.centerY+185)
        botaoMais:addEventListener("tap",botaoMaisTapped)
        sceneGroup:insert(botaoMais)
        
        
    end
    
    function progressao(nivelBonus, percentBonus)
        if progressaoGrupo ~= nil then
            progressaoGrupo:removeSelf()
            progressaoGrupo = nil
        end
        
        progressaoGrupo = display.newGroup()
        sceneGroup:insert(progressaoGrupo)
        
        
        --            local bonusFundo = display.newImage("images/menu/bonusFundo.png")
        --            bonusFundo.x = lib.centerX
        --            bonusFundo.y = lib.bottomY - 100
        --            progressaoGrupo:insert(bonusFundo)
        --            
        --            local textoNivel = display.newText(progressaoGrupo, nivelBonus, lib.centerX-190, lib.bottomY - 151,  lib.textFont, 30)
        --            textoNivel = lib.maxWidth(textoNivel,170, 36)
        --            
        --            local barraBonusCheia = display.newImage("images/menu/bonus100.png")
        --            barraBonusCheia.x = lib.centerX + 64
        --            barraBonusCheia.y = lib.bottomY - 81
        --            progressaoGrupo:insert(barraBonusCheia)
        --            
        
        --            --progressaoGrupo:insert(bonusMask)
        --            
        --            barraBonusCheia:setMask(bonusMask)
        --            
        --            --        local barraBonusVazia = display.newImage("images/menu/bonus0.png")
        --            --        barraBonusVazia.alpha = 0
        --            --        barraBonusVazia.x = lib.centerX + 64
        --            --        barraBonusVazia.y = lib.bottomY - 81
        --            --        progressaoGrupo:insert(barraBonusVazia)
        --            
        --            local maskPosition = barraBonusCheia.width * (percentBonus-1)
        --            
        --            barraBonusCheia.maskX = -barraBonusCheia.width
        --            
        --            transition.to(barraBonusCheia,{time = 1000,maskX = maskPosition})
        
    end
    
    
    layout()
    
    --    lib.enquete("ola tudo bem? pergunta grande pra caramba, isso mesmo, muito grande! muahahahahahahahahaha! yeah","sim, mas poderia ser melhor","nao","resposta Grande pra caramba top top")
    --    lib.opiniao("Sushiloko Asa Norte","Velocidade","Atendimento","Limpeza")
    
    
    local function funcaoRetornoListar(decoded)
        
        if decoded.responderEnquete == true then
            lib.enquete(decoded.enquete.idEnquete,decoded.enquete.noPergunta,decoded.enquete.arrResposta[1].noResposta,decoded.enquete.arrResposta[2].noResposta,decoded.enquete.arrResposta[3].noResposta,decoded.enquete.arrResposta[1].idResposta,decoded.enquete.arrResposta[2].idResposta,decoded.enquete.arrResposta[3].idResposta)
        end
        
        if decoded.responderFeedback == true then
            local idRequisicao = decoded.feedback.idRequisicao
            local pergunta = decoded.feedback.noPergunta
            local tabLoja = {}
            tabLoja.nome = decoded.feedback.noFranquia
            tabLoja.id = decoded.feedback.idFranquia
            local tabItem1 = {}
            tabItem1.id = decoded.feedback.arrResposta[1].idResposta
            tabItem1.nome = decoded.feedback.arrResposta[1].noResposta
            local tabItem2 = {}
            tabItem2.id = decoded.feedback.arrResposta[2].idResposta
            tabItem2.nome = decoded.feedback.arrResposta[2].noResposta
            local tabItem3 = {}
            tabItem3.id = decoded.feedback.arrResposta[3].idResposta
            tabItem3.nome = decoded.feedback.arrResposta[3].noResposta
            
            lib.feedBack(tabLoja,tabItem1,tabItem2,tabItem3,idRequisicao,pergunta)   
        end
        
        
        
        for i = 1 , #decoded.tags.remove do
            lib.OneSignal.DeleteTag("loja"..decoded.tags.remove[i].idFranquia)
        end    
        for i = 1 , #decoded.tags.send do
            lib.OneSignal.SendTag("loja"..decoded.tags.send[i].idFranquia, "1")
        end
        
        if decoded.possuiBonus == true then
            local nomeProgressao = decoded.bonus.noNivel
            local porcentagem
            if decoded.bonus.nuMax ~= nil then
                porcentagem = (decoded.bonus.nuBonus - decoded.bonus.nuMin )/(decoded.bonus.nuMax - decoded.bonus.nuMin )
            else
                porcentagem = 1
            end    
            progressao(nomeProgressao,porcentagem)  
            
            local function imageLoader(event)
                
                if ( event.isError ) then
                    print ( "Network error - download failed" )
                else
                    
                    event.target.width = 119
                    event.target.height = 85
                    sceneGroup:insert(event.target)
                    
                end
                
                
            end
            
            local urlImg = decoded.bonus.noImagem
            display.loadRemoteImage( urlImg, "GET", imageLoader, "bonusImage.png",system.TemporaryDirectory,lib.centerX-lib.leftX-227,lib.bottomY - 80)
            
            
        end
        
        
        lib.opiniao = {}
        lib.opiniao.ativo = decoded.opiniaoAtiva
        lib.opiniao.id = decoded.opiniao.idFeedBack
        
        lib.opiniao.item1  = {}
        lib.opiniao.item1.id = decoded.opiniao.arrResposta[1].idResposta
        lib.opiniao.item1.nome = decoded.opiniao.arrResposta[1].noResposta
        
        lib.opiniao.item2  = {}
        lib.opiniao.item2.id = decoded.opiniao.arrResposta[2].idResposta
        lib.opiniao.item2.nome = decoded.opiniao.arrResposta[2].noResposta
        
        lib.opiniao.item3  = {}
        lib.opiniao.item3.id = decoded.opiniao.arrResposta[3].idResposta
        lib.opiniao.item3.nome = decoded.opiniao.arrResposta[3].noResposta
        
        urlCompraOnline = decoded.urlCompraOnline or ""
        
        lib.faq = {}
        for i = 1, #decoded.arrFaq do
            
            lib.faq[i] = {}
            
            lib.faq[i].pergunta = decoded.arrFaq[i].noAssunto
            lib.faq[i].resposta = decoded.arrFaq[i].noDescricao
            
        end
        
        
    end
    
    --progressao("",0) 
    
    lib.servicos({["idUsuario"] = lib.dadosUsuario.id },"mobile/enquete/listar",funcaoRetornoListar)
    
    local usuarioLatitude, usuarioLongitude
    local enviaLocal , locationHandler
    function enviaLocal()
        if usuarioLatitude ~= nil and usuarioLongitude ~= nil then
            lib.servicosSemResposta({["idUsuario"] = lib.dadosUsuario.id,["noLatitude"] = usuarioLatitude, ["noLongitude"] = usuarioLongitude },"mobile/usuario/posicao")
        end
        Runtime:removeEventListener("location", locationHandler)
    end
    function locationHandler( event )
        -- Check for error (user may have turned off location services)
        if ( event.errorCode ) then
            
        else
            usuarioLatitude = event.latitude
            usuarioLongitude = event.longitude
        end
    end
    Runtime:addEventListener( "location", locationHandler )
    timer.performWithDelay(2000, enviaLocal)
    
    
    
end

scene:addEventListener( "create", scene )

return scene