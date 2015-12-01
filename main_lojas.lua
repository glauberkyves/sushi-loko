
local lib = require("main_library")
local scene = lib.composer.newScene()

-- "scene:create()"

function scene:create( event )
  
    local sceneGroup = self.view
    local grupoCena
    local lojaSelecionada
    local scrollView
    
    
    local criaGrupos,layOut,endereco,cardapio,promocoes , markerTouched
    
    local carregaPromocao
    
    function criaGrupos()
        if grupoCena ~=nil then
            grupoCena:removeSelf()
            grupoCena = nil
        end
        grupoCena = display.newGroup()
        sceneGroup:insert(grupoCena)
        
    end
    
    
    function markerTouched(markerId)
        
        lojaSelecionada = markerId
        endereco()
        
    end
    
    function layOut()
        
        criaGrupos()
        
        local buttons = {}
        
        carregaPromocao = false
        
        local function botaoVoltarTapped()
            lib.composer.gotoScene("main_menu")
        end
        local function escolherTapped()
            
             lib.mostrarLojas(layOut)
        end
        local function lojaClicada(event)
           lojaSelecionada =  event.target.num
           endereco()
        end
        local function mapaTapped()
            
            lib.criarMapa(markerTouched)
            
        end
        
        local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
        backGround:scale(lib.scale,lib.scale)
        grupoCena:insert(backGround)

        local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
        backGroundSecondLayer.anchorY = 0
        backGroundSecondLayer:scale(lib.scale,lib.scale)
        grupoCena:insert(backGroundSecondLayer)

        local textoLogo = lib.maxWidth(display.newText(grupoCena, lib.tabCidades[lib.cidadeSelecionada].titulo, lib.centerX, lib.topY+60, lib.textFont, 60),380,72) 
        textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
        
        local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
        botaoVoltar:addEventListener("tap",botaoVoltarTapped)
        grupoCena:insert(botaoVoltar)
        
        local botaoMapa = display.newImage("images/lojas/botaoMapa.png", lib.centerX-150, lib.topY+207)
        botaoMapa:addEventListener("tap",mapaTapped)
        grupoCena:insert(botaoMapa)
        
        local botaoEscolherLocal = display.newImage("images/lojas/botaoEscolherCidade.png", lib.centerX+150, lib.topY+207)
        botaoEscolherLocal:addEventListener("tap",escolherTapped)
        grupoCena:insert(botaoEscolherLocal)

        local opts = {
            top = lib.topY+303,
            left = lib.leftX,
            width = lib.distanceX,
            height = lib.distanceY-314,
            --bottomPadding = 90,
            horizontalScrollDisabled = true,
            verticalScrollDisabled = false,
            hideBackground = false,
            hideScrollBar  = true ,
            backgroundColor = {lib.scrollViewBackColor[1],lib.scrollViewBackColor[2],lib.scrollViewBackColor[3] },
            }   
        scrollView = lib.widget.newScrollView(opts)  
        grupoCena:insert(scrollView)

        local barrinhaVermalhaCima = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.topY+297)
        barrinhaVermalhaCima:scale(lib.scale,1)
        grupoCena:insert(barrinhaVermalhaCima)

        local barrinhaVermalhaBaixo = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.bottomY-6)
        barrinhaVermalhaBaixo:scale(lib.scale,1)
        grupoCena:insert(barrinhaVermalhaBaixo)   
        
        
        for i = 1 , #lib.tabCidades[lib.cidadeSelecionada].lojas do
              buttons[i] = {}
      
              buttons[i].button = display.newImage("images/alertas/botaoListarLojas.png", lib.centerX-lib.leftX, 120*i-50)
              buttons[i].button.num = i
              buttons[i].button:addEventListener("tap",lojaClicada)
              scrollView:insert(buttons[i].button)

              buttons[i].text = lib.maxWidth(display.newText( lib.tabCidades[lib.cidadeSelecionada].lojas[i].nome, lib.centerX-lib.leftX, 120*i-50, lib.textFont, 48),350, 60)
              scrollView:insert(buttons[i].text)
            
        end
        
    end
    function endereco()
        
        criaGrupos()
        carregaPromocao = false
        local buttons = {}
        
        local function botaoVoltarTapped()
            layOut()
        end
        local function tracarRotaTapped()
            
            print(lib.tabCidades[lib.cidadeSelecionada].lojas[lojaSelecionada].latitude,lib.tabCidades[lib.cidadeSelecionada].lojas[lojaSelecionada].longitude)
          system.openURL( "http://www.google.com.br/maps/dir//"..lib.tabCidades[lib.cidadeSelecionada].lojas[lojaSelecionada].latitude..","..lib.tabCidades[lib.cidadeSelecionada].lojas[lojaSelecionada].longitude)
        end
  
        
        local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
        backGround:scale(lib.scale,lib.scale)
        grupoCena:insert(backGround)

        local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
        backGroundSecondLayer.anchorY = 0
        backGroundSecondLayer:scale(lib.scale,lib.scale)
        grupoCena:insert(backGroundSecondLayer)

        local textoLogo = display.newText(grupoCena, lib.tabCidades[lib.cidadeSelecionada].lojas[lojaSelecionada].titulo, lib.centerX, lib.topY+60, lib.textFont, 60)  
        textoLogo = lib.maxWidth(textoLogo,380,72)
        textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
        
        local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
        botaoVoltar:addEventListener("tap",botaoVoltarTapped)
        grupoCena:insert(botaoVoltar)
        
        local botaoEndereco = display.newImage("images/lojas/botaoEnderecoClicado.png", lib.centerX-200, lib.topY+210)
        grupoCena:insert(botaoEndereco)
        
        local botaoPromocoes = display.newImage("images/lojas/botaoPromocoes.png", lib.centerX, lib.topY+210)
        botaoPromocoes:addEventListener("tap",promocoes)
        grupoCena:insert(botaoPromocoes)
        
        local botaoCardapio = display.newImage("images/lojas/botaoCardapio.png", lib.centerX+200, lib.topY+210)
        botaoCardapio:addEventListener("tap",cardapio)
        grupoCena:insert(botaoCardapio)

        local opts = {
            top = lib.topY+303,
            left = lib.leftX,
            width = lib.distanceX,
            height = lib.distanceY-314,
            --bottomPadding = 90,
            horizontalScrollDisabled = true,
            verticalScrollDisabled = false,
            hideBackground = false,
            hideScrollBar  = true ,
            backgroundColor = {lib.scrollViewBackColor[1],lib.scrollViewBackColor[2],lib.scrollViewBackColor[3] },
            }   
        scrollView = lib.widget.newScrollView(opts)  
        grupoCena:insert(scrollView)

        local barrinhaVermalhaCima = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.topY+297)
        barrinhaVermalhaCima:scale(lib.scale,1)
        grupoCena:insert(barrinhaVermalhaCima)

        local barrinhaVermalhaBaixo = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.bottomY-6)
        barrinhaVermalhaBaixo:scale(lib.scale,1)
        grupoCena:insert(barrinhaVermalhaBaixo)  
        
        
        local optTextEnd = 
        {
            --parent = textGroup,
            text = lib.tabCidades[lib.cidadeSelecionada].lojas[lojaSelecionada].endereco,     
            x = lib.centerX-lib.leftX,
            y = 250,
            width = lib.distanceX-80,     --required for multi-line and alignment
            font = lib.textFont,   
            fontSize = 48,
            align = "center"  --new alignment parameter
        }

        
        local textEnd = display.newText(optTextEnd)
        textEnd:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
        scrollView:insert(textEnd)
        
        
        local botaoTracarRota = display.newImage("images/lojas/botaoTracarRota.png")
        botaoTracarRota.x = lib.centerX-lib.leftX
        botaoTracarRota.y = lib.distanceY -374
        botaoTracarRota:addEventListener("tap", tracarRotaTapped)
        scrollView:insert(botaoTracarRota)
        
        
        scrollView._view._isVerticalScrollingDisabled = true
        
        
        
        
    end
    function cardapio()
        
        criaGrupos()
        carregaPromocao = false
        
        
        local conteudo = {}
        local tabelaCardapio = {}
        
        local function botaoVoltarTapped()
            layOut()
        end
        local function funcaoRetornoCardapio(decoded)
            
            local posY 
            local reposicionarConteudo
            
            local function produtoTapped(event)
                print(event.target.nomeProduto , event.target.valor,event.target.urlImagem,event.target.descricao)
                
                lib.detalhesCardapio(event.target.nomeProduto,event.target.valor,event.target.descricao,event.target.urlImagem)
                
            end
            local function tituloTapped(event)
                tabelaCardapio[event.target.num].expand = tabelaCardapio[event.target.num].expand*-1
                reposicionarConteudo()
            end
            local function drawCardapioFirst()
                
                for i = 1, #tabelaCardapio do

                     posY = scrollView._view.height

                    conteudo[i] = {}
                    conteudo[i].produtos = {}

                    conteudo[i].rectCinza = display.newRect( 0, 0, lib.distanceX, 100)
                    conteudo[i].rectCinza:setFillColor(lib.barraCardapioColor[1],lib.barraCardapioColor[2],lib.barraCardapioColor[3])
                    conteudo[i].rectCinza.x = lib.centerX-lib.leftX
                    conteudo[i].rectCinza.num = i
                    conteudo[i].rectCinza.y = posY+50
                    conteudo[i].rectCinza:addEventListener("tap",tituloTapped)
                    scrollView:insert(conteudo[i].rectCinza)

                    conteudo[i].nomeCardapio = display.newText( tabelaCardapio[i].nome, lib.centerX-lib.leftX, posY+45,  lib.textFont, 48)
                    conteudo[i].nomeCardapio:setFillColor(lib.tituloCardapioColor[1],lib.tituloCardapioColor[2],lib.tituloCardapioColor[3])
                    scrollView:insert(conteudo[i].nomeCardapio)
                    conteudo[i].nomeCardapio = lib.maxWidth(conteudo[i].nomeCardapio,lib.distanceX-60, 56)
                    
                    if j ~= #tabelaCardapio then
                    
                        conteudo[i].rectPreto = display.newRect( 0, 0, lib.distanceX, 6)
                        conteudo[i].rectPreto:setFillColor(lib.imagemBackColor[1],lib.imagemBackColor[2],lib.imagemBackColor[3])
                        conteudo[i].rectPreto.x = lib.centerX-lib.leftX
                        conteudo[i].rectPreto.y = posY+100
                        scrollView:insert(conteudo[i].rectPreto)
                    
                    end


                    for j = 1 , #tabelaCardapio[i].produtos do

                         posY = scrollView._view.height

                        conteudo[i].produtos[j] = {}

                        conteudo[i].produtos[j].rectBranco = display.newRect( 0, 0, lib.distanceX, 100)
                        conteudo[i].produtos[j].rectBranco:setFillColor(lib.scrollViewBackColor[1],lib.scrollViewBackColor[2],lib.scrollViewBackColor[3])
                        conteudo[i].produtos[j].rectBranco.x = lib.centerX-lib.leftX
                        conteudo[i].produtos[j].rectBranco.y = posY+50
                        conteudo[i].produtos[j].rectBranco.nomeProduto = tabelaCardapio[i].produtos[j].nome
                        conteudo[i].produtos[j].rectBranco.valor = "R$ "..tabelaCardapio[i].produtos[j].valor
                        conteudo[i].produtos[j].rectBranco.urlImagem = tabelaCardapio[i].produtos[j].urlImg
                        conteudo[i].produtos[j].rectBranco.descricao = tabelaCardapio[i].produtos[j].descricao
                        conteudo[i].produtos[j].rectBranco:addEventListener("tap",produtoTapped)
                        scrollView:insert(conteudo[i].produtos[j].rectBranco)

                        conteudo[i].produtos[j].nomeProduto = display.newText(conteudo[i].produtos[j].rectBranco.nomeProduto, 20, posY+45,  lib.textFont, 36)
                        conteudo[i].produtos[j].nomeProduto.anchorX = 0
                        conteudo[i].produtos[j].nomeProduto:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[3])
                        scrollView:insert(conteudo[i].produtos[j].nomeProduto)

                        conteudo[i].produtos[j].valorProduto = display.newText(conteudo[i].produtos[j].rectBranco.valor, lib.distanceX-20, posY+45,  lib.textFont, 36)
                        conteudo[i].produtos[j].valorProduto.anchorX = 1
                        conteudo[i].produtos[j].valorProduto:setFillColor(lib.tituloCardapioColor[1],lib.tituloCardapioColor[2],lib.tituloCardapioColor[3])
                        scrollView:insert(conteudo[i].produtos[j].valorProduto)


                        conteudo[i].produtos[j].nomeProduto = lib.maxWidth(conteudo[i].produtos[j].nomeProduto,lib.distanceX-60-conteudo[i].produtos[j].valorProduto.contentWidth, 44)
                        
                        if j ~= #tabelaCardapio[i].produtos then

                            conteudo[i].produtos[j].rectPreto = display.newRect( 0, 0, lib.distanceX, 6)
                            conteudo[i].produtos[j].rectPreto:setFillColor(lib.imagemBackColor[1],lib.imagemBackColor[2],lib.imagemBackColor[3])
                            conteudo[i].produtos[j].rectPreto.x = lib.centerX-lib.leftX
                            conteudo[i].produtos[j].rectPreto.y = posY+100
                            scrollView:insert(conteudo[i].produtos[j].rectPreto)
                        
                        end




                    end




                end
                
                reposicionarConteudo()
                
            end
            function reposicionarConteudo()
                local positionY = 0
                for i = 1, #tabelaCardapio do
                    conteudo[i].rectCinza.y  = positionY + 50
                    conteudo[i].nomeCardapio.y = positionY + 45
                    
                    if tabelaCardapio[i].expand == 1 then
                        
                        if conteudo[i].rectPreto ~= nil then
                            conteudo[i].rectPreto.y = 100
                            conteudo[i].rectPreto.x = 10000
                        end
                            
                        
                        for j = 1 , #tabelaCardapio[i].produtos do
                            positionY = positionY +100
                            
                            conteudo[i].produtos[j].rectBranco.y = positionY + 50
                            conteudo[i].produtos[j].nomeProduto.y = positionY + 45
                            conteudo[i].produtos[j].valorProduto.y = positionY + 45
                            
                            
                            conteudo[i].produtos[j].rectBranco.x = lib.centerX-lib.leftX
                            conteudo[i].produtos[j].nomeProduto.x = 20
                            conteudo[i].produtos[j].valorProduto.x = lib.distanceX-20
                            
                            if conteudo[i].produtos[j].rectPreto ~= nil then
                                conteudo[i].produtos[j].rectPreto.y =  positionY + 100
                                conteudo[i].produtos[j].rectPreto.x =  lib.centerX-lib.leftX
                            end
                            
                        end
                        
                    else
                        
                        if conteudo[i].rectPreto ~= nil then
                            conteudo[i].rectPreto.y = positionY + 100
                            conteudo[i].rectPreto.x = lib.centerX-lib.leftX 
                        end
                        
                       for j = 1 , #tabelaCardapio[i].produtos do
                            
                            conteudo[i].produtos[j].rectBranco.y = 100
                            conteudo[i].produtos[j].nomeProduto.y = 100
                            conteudo[i].produtos[j].valorProduto.y = 100
                            
                            
                            conteudo[i].produtos[j].rectBranco.x = 10000
                            conteudo[i].produtos[j].nomeProduto.x = 10000
                            conteudo[i].produtos[j].valorProduto.x = 10000
                            
                            if conteudo[i].produtos[j].rectPreto ~= nil then
                                conteudo[i].produtos[j].rectPreto.y =  100
                                conteudo[i].produtos[j].rectPreto.x =  10000
                            end
                            
                        end
                        
                        
                        
                    end
                    
                    
                    positionY = positionY +100
                end
                
                scrollView:setScrollHeight( positionY )
            end
            
                                
            for i = 1 , #decoded.arrCardapio do
                tabelaCardapio[i] = {}
                tabelaCardapio[i].nome = decoded.arrCardapio[i].noCardapio
                tabelaCardapio[i].expand = 1
                tabelaCardapio[i].produtos = {}
                for j = 1 , #decoded.arrCardapio[i].arrProdutos do
                    tabelaCardapio[i].produtos[j] = {}
                    tabelaCardapio[i].produtos[j].nome = decoded.arrCardapio[i].arrProdutos[j].noProduto
                    tabelaCardapio[i].produtos[j].descricao = decoded.arrCardapio[i].arrProdutos[j].dsProduto
                    tabelaCardapio[i].produtos[j].valor = decoded.arrCardapio[i].arrProdutos[j].nuValor
                    tabelaCardapio[i].produtos[j].urlImg = decoded.arrCardapio[i].arrProdutos[j].noImagem 
                end
                
                
            end
                
                        
            drawCardapioFirst()   
            
        end
  
        
        local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
        backGround:scale(lib.scale,lib.scale)
        grupoCena:insert(backGround)

        local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
        backGroundSecondLayer.anchorY = 0
        backGroundSecondLayer:scale(lib.scale,lib.scale)
        grupoCena:insert(backGroundSecondLayer)

        local textoLogo = display.newText(grupoCena,  lib.tabCidades[lib.cidadeSelecionada].lojas[lojaSelecionada].titulo, lib.centerX, lib.topY+60, lib.textFont, 60)  
        textoLogo = lib.maxWidth(textoLogo,380,72)
        textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
        
        local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
        botaoVoltar:addEventListener("tap",botaoVoltarTapped)
        grupoCena:insert(botaoVoltar)
        
        local botaoEndereco = display.newImage("images/lojas/botaoEndereco.png", lib.centerX-200, lib.topY+210)
        botaoEndereco:addEventListener("tap",endereco)
        grupoCena:insert(botaoEndereco)
        
        local botaoPromocoes = display.newImage("images/lojas/botaoPromocoes.png", lib.centerX, lib.topY+210)
        botaoPromocoes:addEventListener("tap",promocoes)
        grupoCena:insert(botaoPromocoes)
        
        local botaoCardapio = display.newImage("images/lojas/botaoCardapioClicado.png", lib.centerX+200, lib.topY+210)
        grupoCena:insert(botaoCardapio)

        local opts = {
            top = lib.topY+303,
            left = lib.leftX,
            width = lib.distanceX,
            height = lib.distanceY-314,
            --bottomPadding = 20,
            horizontalScrollDisabled = true,
            verticalScrollDisabled = false,
            hideBackground = false,
            hideScrollBar  = true ,
            backgroundColor = {lib.scrollViewBackColor[1],lib.scrollViewBackColor[2],lib.scrollViewBackColor[3] },
            }   
        scrollView = lib.widget.newScrollView(opts)  
        grupoCena:insert(scrollView)

        local barrinhaVermalhaCima = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.topY+297)
        barrinhaVermalhaCima:scale(lib.scale,1)
        grupoCena:insert(barrinhaVermalhaCima)

        local barrinhaVermalhaBaixo = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.bottomY-6)
        barrinhaVermalhaBaixo:scale(lib.scale,1)
        grupoCena:insert(barrinhaVermalhaBaixo)  
        
--        local textCard = lib.maxWidth(display.newText("Cardapio "..lib.cidadeSelecionada..lojaSelecionada, lib.centerX-lib.leftX, 120, lib.textFont, 48),lib.distanceX-60, 60)
--        textCard:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
--        scrollView:insert(textCard)
        
        lib.servicos({["idFranquia"] =lib.tabCidades[lib.cidadeSelecionada].lojas[lojaSelecionada].id },"mobile/franquia/listar/cardapio",funcaoRetornoCardapio)
   
        
        
    end
    function promocoes()
        
        criaGrupos()
        
        local conteudoPromocoes = {}
        
        local function botaoVoltarTapped()
            layOut()
        end
        local function funcaoRetornoPromocao(decoded)
            
            
            local destFile ,url 
            
            carregaPromocao = true
            
            function imageLoader(event)
                
                if ( event.isError ) then
                    print ( "Network error - download failed" )
                else
                    
                    if carregaPromocao == true then
                        event.target.width = 640
                        event.target.height = 268
                        scrollView:insert(event.target)
                        --event.target:toBack()
                    else
                       event.target:removeSelf()
                       event.target = nil
                    end
                        
                end
                
               
            end
            
              for i = 1 , #decoded.promocoes do

                  destFile =  "promocao"..lib.cidadeSelecionada..lojaSelecionada..i
                  url = decoded.promocoes[i].noImagem
                  print(url)
                  conteudoPromocoes[i] = {}
                  conteudoPromocoes[i].img =  display.loadRemoteImage( url, "GET", imageLoader, destFile,system.TemporaryDirectory,lib.centerX-lib.leftX,i*275-141)

                  conteudoPromocoes[i].rect = display.newRect( 0, 0, 640, 268)
                  conteudoPromocoes[i].rect.x = lib.centerX-lib.leftX
                  conteudoPromocoes[i].rect.y = i*275-141
                  conteudoPromocoes[i].rect:setFillColor(lib.imagemBackColor[1],lib.imagemBackColor[2],lib.imagemBackColor[2])
                  scrollView:insert(conteudoPromocoes[i].rect)

                  conteudoPromocoes[i].carregando = display.newImage("images/lojas/iconeCamera.png")
                  conteudoPromocoes[i].carregando.x = lib.centerX-lib.leftX
                  conteudoPromocoes[i].carregando.y = i*275-141
                  scrollView:insert(conteudoPromocoes[i].carregando)


    --              conteudoPromocoes[i].descricao = display.newText( decoded.promocoes[i].dsPromocao, lib.centerX - lib.leftX, i*300+50,  lib.textFont, 48)
    --              conteudoPromocoes[i].descricao:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
    --              scrollView:insert(conteudoPromocoes[i].descricao)


              end

            
        end
  
        
        local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
        backGround:scale(lib.scale,lib.scale)
        grupoCena:insert(backGround)

        local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
        backGroundSecondLayer.anchorY = 0
        backGroundSecondLayer:scale(lib.scale,lib.scale)
        grupoCena:insert(backGroundSecondLayer)

        local textoLogo = display.newText(grupoCena, lib.tabCidades[lib.cidadeSelecionada].lojas[lojaSelecionada].titulo, lib.centerX, lib.topY+60, lib.textFont, 60)  
        textoLogo = lib.maxWidth(textoLogo,380,72)
        textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
        
        local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
        botaoVoltar:addEventListener("tap",botaoVoltarTapped)
        grupoCena:insert(botaoVoltar)
        
        local botaoEndereco = display.newImage("images/lojas/botaoEndereco.png", lib.centerX-200, lib.topY+210)
        botaoEndereco:addEventListener("tap",endereco)
        grupoCena:insert(botaoEndereco)
        
        local botaoPromocoes = display.newImage("images/lojas/botaoPromocoesClicado.png", lib.centerX, lib.topY+210)
        grupoCena:insert(botaoPromocoes)
        
        local botaoCardapio = display.newImage("images/lojas/botaoCardapio.png", lib.centerX+200, lib.topY+210)
        botaoCardapio:addEventListener("tap",cardapio)
        grupoCena:insert(botaoCardapio)

        local opts = {
            top = lib.topY+303,
            left = lib.leftX,
            width = lib.distanceX,
            height = lib.distanceY-314,
            --bottomPadding = 90,
            horizontalScrollDisabled = true,
            verticalScrollDisabled = false,
            hideBackground = false,
            hideScrollBar  = true ,
            backgroundColor = {lib.scrollViewBackColor[1],lib.scrollViewBackColor[2],lib.scrollViewBackColor[3] },
            }   
        scrollView = lib.widget.newScrollView(opts)  
        grupoCena:insert(scrollView)

        local barrinhaVermalhaCima = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.topY+297)
        barrinhaVermalhaCima:scale(lib.scale,1)
        grupoCena:insert(barrinhaVermalhaCima)

        local barrinhaVermalhaBaixo = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.bottomY-6)
        barrinhaVermalhaBaixo:scale(lib.scale,1)
        grupoCena:insert(barrinhaVermalhaBaixo)  
        
--        local texProm = lib.maxWidth(display.newText("Promocoes "..lib.cidadeSelecionada..lojaSelecionada, lib.centerX-lib.leftX, 120, lib.textFont, 48),lib.distanceX-60, 60)
--        texProm:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
--        scrollView:insert(texProm)
        
        lib.servicos({["idFranquia"] =lib.tabCidades[lib.cidadeSelecionada].lojas[lojaSelecionada].id },"mobile/franquia/listar/promocao",funcaoRetornoPromocao)
   
        
        
    end
    
    
    layOut()

end

scene:addEventListener( "create", scene )

return scene

