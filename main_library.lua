local lib = {}



-- coisas editaveis
lib.idFranqueador = 56

lib.textLogoColor = {0,0,0}
lib.textLightColor = {0.60,0.60,0.60}
lib.textDarkColor = {0.19,0.19,0.19}
lib.textConteudoColor = {0,0,0}
lib.imagemBackColor = {0.92,0.92,0.92}
lib.barraCardapioColor = {0.96,0.96,0.96}
lib.tituloCardapioColor = {0.67,0,0}
lib.saldoColor = {0.67,0,0}
lib.successTextColor = {0,0,0}
lib.errorTextColor = {0,0,0}
lib.scrollViewBackColor = {1,1,1}
lib.textEnqueteColor = {1,1,1}

lib.nomeFranquia = "Sushiloko"

lib.textFont = "ArialRoundedMTBold"
lib.passFont = "Password"


lib.json      = require "json"
lib.composer  = require "composer" 
lib.loadsave  = require "loadsave"
lib.widget    = require "widget"
lib.openssl   = require "plugin.openssl"
lib.mime      = require "mime"
lib.OneSignal = require "plugin.OneSignal"
lib.ga        = require "GoogleAnalytics.ga"
lib.textos    = require "textos"
lib.lfs       = require "lfs"

lib.centerY = display.contentCenterY
lib.centerX = display.contentCenterX
lib.distanceX = display.actualContentWidth
lib.distanceY = display.actualContentHeight
lib.leftX = display.screenOriginX
lib.rightX = lib.leftX + lib.distanceX
lib.topY = display.screenOriginY
lib.bottomY = lib.topY + lib.distanceY

lib.scaleX =  lib.distanceX/640
lib.scaleY = lib.distanceY/960
if lib.scaleX  > lib.scaleY then
    lib.scale = lib.scaleX
else
    lib.scale = lib.scaleY   
end



-- conecao com servidor

-- funcao carregando
local  grupoCarregando
function lib.criaCarregando()
    
    grupoCarregando = display.newGroup()
    
    
    local function tocaFundoCarregando()
        return true
    end
    
    
    local fundoRect = display.newRect( lib.leftX,lib.topY,lib.distanceX,lib.distanceY) 
    fundoRect:setFillColor(0,0,0)
    fundoRect.alpha = 0.7
    fundoRect.anchorX  = 0
    fundoRect.anchorY = 0
    fundoRect:addEventListener("tap",tocaFundoCarregando)
    fundoRect:addEventListener("touch",tocaFundoCarregando)
    grupoCarregando:insert(fundoRect)
    
    local carregando = display.newImage("images/alertas/processando.png",lib.centerX,lib.centerY )
    carregando.anchorY = 0.55
    grupoCarregando:insert(carregando)
    
    transition.to(carregando,{rotation=carregando.rotation-16880, time=32000})
    
    
    
    
end
function lib.deletaCarregando()
    
    if grupoCarregando ~=nil then
        grupoCarregando:removeSelf()
        grupoCarregando = nil
    end
    
end


lib.key       = 'lAtM86mDWBMMXHBMu/I7jXLh9Unn4i4='
lib.iv        = '3JHJCpIKFqvcdg=='
lib.method    = 'AES-256-CBC'
lib.cypher    = lib.openssl.get_cipher(lib.method)
lib.mensagemErro = "Ops, algo deu errado. Tente novamente mais tarde."
--lib.url = "http://127.0.0.1:8000/"
--lib.url = "http://192.168.25.222:8000/"
--lib.url = "http://192.168.25.223:8000/"
lib.url = "http://ec2-52-34-184-94.us-west-2.compute.amazonaws.com/"


function lib.urlEncode( str )
    if ( str ) then
        str = string.gsub( str, "\n", "\r\n" )
        str = string.gsub( str, "([^%w ])",
        function (c) return string.format( "%%%02X", string.byte(c) ) end )
        str = string.gsub( str, " ", "+" )
    end
    return str
end
function lib.decryptRequest(value)
    return lib.cypher:decrypt(lib.mime.unb64(value), lib.key, lib.iv)
end
function lib.encryptRequest(value)
    return lib.mime.b64(lib.cypher:encrypt(lib.json.encode(value), lib.key, lib.iv))
end
function lib.servicos(tabelaDados,urlServico,funcaoRetorno,validoFalseFunc)
    
    local decoded
    local URL = lib.url..urlServico
    --local URL = lib.url
    
    tabelaDados["idFranqueador"] = lib.idFranqueador
    
    local params = {}
    --params.body  = "token="..lib.urlEncode(lib.encryptRequest({["cpf"]= cpf,["senha"]= senha}))
    params.body  = "token="..lib.urlEncode(lib.encryptRequest(tabelaDados))
    params.timeout = 15
    
    --print(URL, params.body)
    local function networkListener( event )
        lib.deletaCarregando()
        if ( event.isError ) then
            
            lib.criarPopUp(lib.textos.erroConexao)
            
        else
            
            print(event.status)
            print(lib.decryptRequest(event.response))
            --print(event.response)
            
            if event.status == 200 then
                decoded = lib.json.decode( lib.decryptRequest(event.response) )
                if decoded.valido == true then 
                    
                    if funcaoRetorno ~= nil then
                        funcaoRetorno(decoded)
                    end
                    
                    
                else
                    
                    if validoFalseFunc ~=nil then     
                        lib.criarPopUp(decoded.mensagem,validoFalseFunc)
                    else
                        lib.criarPopUp(decoded.mensagem)
                    end
                    
                    
                end
            else
                
                lib.criarPopUp(lib.mensagemErro)
            end             
            
        end
        
    end
    
    if funcaoRetorno ~= nil then
        lib.criaCarregando()    
    end
    network.request(URL, "POST", networkListener, params )
    
end
function lib.servicosSemResposta(tabelaDados,urlServico)
    
    local decoded
    local URL = lib.url..urlServico
    --local URL = lib.url
    
    tabelaDados["idFranqueador"] = lib.idFranqueador
    
    local params = {}
    --params.body  = "token="..lib.urlEncode(lib.encryptRequest({["cpf"]= cpf,["senha"]= senha}))
    params.body  = "token="..lib.urlEncode(lib.encryptRequest(tabelaDados))
    params.timeout = 15
    
    --print(URL, params.body)
    local function networkListener( event )
        
    end
    
    
    network.request(URL, "POST", networkListener, params )
    
end

function lib.criarPopUp(msg, func, sucesso)
    
    local grupoPop = display.newGroup() 
    local chamarDelete = true 
    local sucess = sucesso or false
    
    local function tocouFundo()
        
        
        if chamarDelete == true then   
            chamarDelete = false
            local function deletaTudo()
                if grupoPop ~= nil then
                    grupoPop:removeSelf()
                    grupoPop = nil
                end
                if func ~= nil then
                    func()
                end
                
            end
            
            timer.performWithDelay(100, deletaTudo)
        end  
        
        return true
    end
    
    
    local fundoRect = display.newRect( lib.leftX,lib.topY,lib.distanceX,lib.distanceY) 
    fundoRect:setFillColor(0,0,0)
    fundoRect.alpha = 0.7
    fundoRect.anchorX  = 0
    fundoRect.anchorY = 0
    fundoRect:addEventListener("tap",tocouFundo)
    fundoRect:addEventListener("touch",tocouFundo)
    grupoPop:insert(fundoRect)
    
    local caixaPop
    if sucess == true then
        caixaPop = display.newImage("images/alertas/caixaPopUpSucesso.png", lib.centerX, lib.centerY+40)  
    else
        caixaPop = display.newImage("images/alertas/caixaPopUp.png", lib.centerX, lib.centerY+40)  
    end
    grupoPop:insert(caixaPop)
    
    
    local options = 
    {
        --parent = textGroup,
        text = msg,   
        x = lib.centerX,
        y = lib.centerY+80,
        width = 480,     --required for multi-line and alignment
        font = lib.textFont, 
        fontSize = 32,
        align = "center"  --new alignment parameter
    }
    
    local textoPop = display.newText( options )
    if sucess == true then
        textoPop:setFillColor(lib.successTextColor[1],lib.successTextColor[2],lib.successTextColor[3]) 
    else
        textoPop:setFillColor(lib.errorTextColor[1],lib.errorTextColor[2],lib.errorTextColor[3]) 
    end
    
    grupoPop:insert(textoPop)    
    
end

function lib.dinheiroMask(numero)
    
    return string.format("%4.2f",numero)
    
end

function lib.mostrarLojas(funcRetorno)
    
    function ANDROID_RETURN_ACTION()
        lib.composer.gotoScene("main_mais")
    end
    
    local grupoLojas = display.newGroup()
    local scrollView
    local tabCidades = {}
    local buttons = {}
    
    local usuarioLatitude,usuarioLongitude
    
    local tocouFundo,botaoFecharTapped,lojaSelecionada,lojasProximasTapped,locationHandler
    
    function tocouFundo()
        return true
    end
    function botaoFecharTapped()
        if grupoLojas ~= nil then
            grupoLojas:removeSelf()
            grupoLojas = nil
        end
        Runtime:removeEventListener( "location", locationHandler )
    end
    function lojaSelecionada(event)
        lib.cidadeSelecionada  = event.target.num
        lib.tabCidades = tabCidades
        botaoFecharTapped()
        funcRetorno()
    end
    function lojasProximasTapped()
        
        local function funcaoRetornoLojasProximas(decoded)
            
            tabCidades = {}
            tabCidades[1] = {}
            tabCidades[1].titulo = lib.textos.nomeLojasProximas
            tabCidades[1].latitudeInicial = usuarioLatitude
            tabCidades[1].longitudeInicial = usuarioLongitude
            tabCidades[1].lojas = {}
            print(#decoded.franquias)
            for j=1 , #decoded.franquias do
                tabCidades[1].lojas[j] = {}
                tabCidades[1].lojas[j].id = decoded.franquias[j].idFranquia
                tabCidades[1].lojas[j].nome = decoded.franquias[j].noFranquia
                tabCidades[1].lojas[j].titulo = decoded.franquias[j].noTituloFranquia
                tabCidades[1].lojas[j].latitude = decoded.franquias[j].noLatitude
                tabCidades[1].lojas[j].longitude = decoded.franquias[j].noLongitude
                tabCidades[1].lojas[j].endereco = decoded.franquias[j].noEnderecoAmigavel or "endereco "..j
                print(tabCidades[1].lojas[j].nome)
            end
            
            lib.cidadeSelecionada  = 1
            lib.tabCidades = tabCidades
            botaoFecharTapped()
            funcRetorno()
            
            
        end
        print(usuarioLatitude,usuarioLongitude)
        if usuarioLatitude ~= nil and usuarioLongitude ~= nil then
            --lib.servicos({["noLatitude"] = usuarioLatitude, ["noLongitude"] = usuarioLongitude },"mobile/franqueador/listar/lojas/distancia",funcaoRetornoLojasProximas)
            lib.servicos({["noLatitude"] = 15.722038712233, ["noLongitude"] = 47.881459584968 },"mobile/franqueador/listar/lojas/distancia",funcaoRetornoLojasProximas)
            
        else
            lib.criarPopUp(lib.textos.erroGPS)  
        end
        
        
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
    
    
    local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
    backGround:scale(lib.scale,lib.scale)
    backGround:addEventListener("tap",tocouFundo)
    backGround:addEventListener("touch",tocouFundo)
    grupoLojas:insert(backGround)
    
    local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
    backGroundSecondLayer.anchorY = 0
    backGroundSecondLayer:scale(lib.scale,lib.scale)
    grupoLojas:insert(backGroundSecondLayer)
    
    local textoLogo = display.newText(grupoLojas, lib.textos.selecionarCidade, lib.centerX, lib.topY+60, lib.textFont, 60)
    textoLogo = lib.maxWidth(textoLogo,400, 72)
    textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
    
    local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
    botaoVoltar:addEventListener("tap",botaoFecharTapped)
    grupoLojas:insert(botaoVoltar)
    
    
    local botaoLojasProximas = display.newImage("images/alertas/botaoLojasProximas.png", lib.centerX, lib.topY+210)
    botaoLojasProximas:addEventListener("tap",lojasProximasTapped)
    grupoLojas:insert(botaoLojasProximas)
    
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
    grupoLojas:insert(scrollView)
    
    local barrinhaVermalhaCima = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.topY+297)
    barrinhaVermalhaCima:scale(lib.scale,1)
    grupoLojas:insert(barrinhaVermalhaCima)
    
    local barrinhaVermalhaBaixo = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.bottomY-6)
    barrinhaVermalhaBaixo:scale(lib.scale,1)
    grupoLojas:insert(barrinhaVermalhaBaixo)
    
    local function funcaoRetornoServico(decoded)
        
        for i = 1 , #decoded.franquias do
            tabCidades[i] = {}
            tabCidades[i].id = decoded.franquias[i].idMunicipio
            tabCidades[i].nome = decoded.franquias[i].noMunicipio
            tabCidades[i].titulo = decoded.franquias[i].noTituloMunicipio
            print(tabCidades[i].titulo)
            tabCidades[i].lojas = {}
            for j=1 , #decoded.franquias[i].arrFranquias do
                tabCidades[i].lojas[j] = {}
                tabCidades[i].lojas[j].id = decoded.franquias[i].arrFranquias[j].idFranquia
                tabCidades[i].lojas[j].nome = decoded.franquias[i].arrFranquias[j].noFranquia
                tabCidades[i].lojas[j].titulo = decoded.franquias[i].arrFranquias[j].noTituloFranquia
                tabCidades[i].lojas[j].latitude = decoded.franquias[i].arrFranquias[j].noLatitude
                tabCidades[i].lojas[j].longitude = decoded.franquias[i].arrFranquias[j].noLongitude
                tabCidades[i].lojas[j].endereco = decoded.franquias[i].arrFranquias[j].noEnderecoAmigavel or "endereco "..i..j
                
            end
            tabCidades[i].latitudeInicial = tabCidades[i].lojas[1].latitude
            tabCidades[i].longitudeInicial = tabCidades[i].lojas[1].longitude
            
            buttons[i] = {}
            
            buttons[i].button = display.newImage("images/alertas/botaoListarLojas.png", lib.centerX-lib.leftX, 120*i-50)
            buttons[i].button.num = i
            buttons[i].button:addEventListener("tap",lojaSelecionada)
            scrollView:insert(buttons[i].button)
            
            buttons[i].text = lib.maxWidth(display.newText( tabCidades[i].nome, lib.centerX-lib.leftX, 120*i-50, lib.textFont, 48),350, 60)
            scrollView:insert(buttons[i].text)
            
            print(tabCidades[i].nome)
            
        end
        
        
        
    end
    
    
    lib.servicos({},"mobile/franqueador/listar/lojas",funcaoRetornoServico)
    
    
end

function lib.criarMapa(markerTouched)
    
    local grupoMapa = display.newGroup() 
    local tocouFundo   , botaoTapped , xTapped , markerTapped , markerTapped, myMap, locationTable
    
    function tocouFundo()
        return true
    end
    function botaoFecharTapped()
        
        grupoMapa:removeSelf()
        grupoMapa = nil
        
        myMap:removeSelf()
        myMap = nil
        
    end
    
    local qtTapped = {}
    local function markerTapped(event)
        
        for i = 1, #qtTapped do
            if i ~= event.markerId then
                qtTapped[i] = 0
            end
        end
        
        qtTapped[event.markerId] = qtTapped[event.markerId] + 1
        
        
        if qtTapped[event.markerId]>1 then
            botaoFecharTapped()
            markerTouched(event.markerId)
        end
        
        
        return true
    end
    
    
    local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
    backGround:scale(lib.scale,lib.scale)
    backGround:addEventListener("tap",tocouFundo)
    backGround:addEventListener("touch",tocouFundo)
    grupoMapa:insert(backGround) 
    
    local textoLogo = display.newText(grupoMapa, lib.textos.textMapa, lib.centerX, lib.topY+60, lib.textFont, 60)
    textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])   
    
    local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
    botaoVoltar:addEventListener("tap",botaoFecharTapped)
    grupoMapa:insert(botaoVoltar)
    
    local barrinhaVermalhaCima = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.topY+117)
    barrinhaVermalhaCima:scale(lib.scale,1)
    grupoMapa:insert(barrinhaVermalhaCima)
    
    local barrinhaVermalhaBaixo = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.bottomY-6)
    barrinhaVermalhaBaixo:scale(lib.scale,1)
    grupoMapa:insert(barrinhaVermalhaBaixo)
    
    local rect = display.newRect( 0, 0, lib.distanceX, lib.distanceY-135)
    rect.x = lib.centerX
    rect.y = lib.centerY+55
    grupoMapa:insert(rect)
    
    local function createMarkers()
        
        
        --        if  myMap then
        --            myMap.x = lib.centerX
        --            myMap.y = lib.centerY+(lib.topBarSize-lib.bottomBarSize)/2
        --        else
        --            myMap = native.newMapView( lib.centerX, lib.centerY+55, lib.distanceX, lib.distanceY-135 )
        --        end
        --        
        --        local locationTable = myMap:getUserLocation()
        --        
        --        if locationTable.latitude ~= nil and locationTable.longitude~= nil then
        --            myMap:setRegion (lib.tabCidades[lib.cidadeSelecionada].latitudeInicial , lib.tabCidades[lib.cidadeSelecionada].longitudeInicial ,1 ,1)
        --        end
        --        
        --        for i = 1 , #lib.tabCidades[lib.cidadeSelecionada].lojas do
        --            local lat = lib.tabCidades[lib.cidadeSelecionada].lojas[i].latitude
        --            local lon = lib.tabCidades[lib.cidadeSelecionada].lojas[i].longitude
        --            
        --            if lat ~= nil and lon ~= nil then
        --                myMap:addMarker(
        --                tonumber(37.331692), 
        --                tonumber(-122.030456),
        --                {
        --                    title = tostring(lib.tabCidades[lib.cidadeSelecionada].lojas[i].nome),
        --                    imageFile = "images/lojas/marcadorMapa.png", 
        --                    subtitle = tostring(lib.tabCidades[lib.cidadeSelecionada].lojas[i].endereco),
        --                    listener = markerTapped 
        --                })
        --                
        --                qtTapped[i] = 0
        --            end
        --        end
    end
    
    -- Map marker listener function
    local function markerListener(event)
        print( "type: ", event.type )  -- event type
        print( "markerId: ", event.markerId )  -- ID of the marker that was touched
        print( "lat: ", event.latitude )  -- latitude of the marker
        print( "long: ", event.longitude )  -- longitude of the marker
    end
    
    
    --    if system.getInfo( "platformName" ) == "Android" then
    --        createMarkers()
    ----        timer.performWithDelay(4000, createMarkers)
    --    else
    --        createMarkers()
    --    end
    
    local function getVersion()
        
        local function lojas()
            for i = 1 , #lib.tabCidades[lib.cidadeSelecionada].lojas do
                local lat = lib.tabCidades[lib.cidadeSelecionada].lojas[i].latitude
                local lon = lib.tabCidades[lib.cidadeSelecionada].lojas[i].longitude
                
                if lat ~= nil and lon ~= nil then
                    myMap:addMarker(
                    tonumber(lat), 
                    tonumber(lon),
                    {
                        title = tostring(lib.tabCidades[lib.cidadeSelecionada].lojas[i].nome),
                        imageFile = "images/lojas/marcadorMapa.png", 
                        subtitle = tostring(lib.tabCidades[lib.cidadeSelecionada].lojas[i].endereco),
                        listener = markerTapped 
                    })
                    
                    qtTapped[i] = 0
                end
            end
        end
        
        lib.servicos({},"mobile/franqueador/listar/lojas", lojas)
    end
    
    local function funcaoDelay()
        locationTable = myMap:getUserLocation()
        
        if locationTable.latitude ~= nil and locationTable.longitude~= nil then
            myMap:setRegion (locationTable.latitude , locationTable.longitude ,1 ,1)
        end
        
        timer.performWithDelay(5000, getVersion)
    end
    
    local function funcaoMudarMapa ()
        if  myMap then
            myMap.x = lib.centerX
            myMap.y = lib.centerY+(lib.topBarSize-lib.bottomBarSize)/2
        else
            myMap = native.newMapView( lib.centerX, lib.centerY+55, lib.distanceX, lib.distanceY-135 )
            locationTable = myMap:getUserLocation()
            
            if locationTable.latitude ~= nil and locationTable.longitude~= nil then
                myMap:setRegion (locationTable.latitude , locationTable.longitude ,1 ,1)
            end
            
            getVersion()
        end
    end
    
    timer.performWithDelay(150, funcaoMudarMapa)
end

function lib.detalhesFaq(pergunta,resposta)
    
    local grupoFaq = display.newGroup()
    
    local tocouFundo,botaoFecharTapped
    
    function tocouFundo()
        return true
    end
    function botaoFecharTapped()
        if grupoFaq ~= nil then
            grupoFaq:removeSelf()
            grupoFaq = nil
        end
    end
    
    
    local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
    backGround:scale(lib.scale,lib.scale)
    backGround:addEventListener("tap",tocouFundo)
    backGround:addEventListener("touch",tocouFundo)
    grupoFaq:insert(backGround)
    
    local textoLogo = display.newText(grupoFaq, lib.textos.titulofaq, lib.centerX, lib.topY+60, lib.textFont, 60)
    textoLogo = lib.maxWidth(textoLogo,380, 72)
    textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
    
    local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
    botaoVoltar:addEventListener("tap",botaoFecharTapped)
    grupoFaq:insert(botaoVoltar)
    
    
    local opts = {
        top = lib.topY+132,
        left = lib.leftX,
        width = lib.distanceX,
        height = lib.distanceY-143,
        --bottomPadding = 90,
        horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
        hideBackground = false,
        hideScrollBar  = true ,
        backgroundColor = {lib.scrollViewBackColor[1],lib.scrollViewBackColor[2],lib.scrollViewBackColor[3] },
    }   
    scrollView = lib.widget.newScrollView(opts)  
    grupoFaq:insert(scrollView)
    
    local barrinhaVermalhaCima = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.topY+126)
    barrinhaVermalhaCima:scale(lib.scale,1)
    grupoFaq:insert(barrinhaVermalhaCima)
    
    local barrinhaVermalhaBaixo = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.bottomY-6)
    barrinhaVermalhaBaixo:scale(lib.scale,1)
    grupoFaq:insert(barrinhaVermalhaBaixo)
    
    
    
    
    local posY
    
    
    local optTextPergunta= 
    {
        --parent = textGroup,
        text = pergunta,     
        x = lib.centerX-lib.leftX,
        y = 25,
        width = lib.distanceX-60,     --required for multi-line and alignment
        font = lib.textFont,   
        fontSize = 36,
        align = "center"  --new alignment parameter
    }
    
    
    local textoPergunta = display.newText(optTextPergunta)
    --textoPergunta = lib.maxWidth(textoPergunta,lib.distanceX - 40,56)
    textoPergunta.anchorY = 0
    textoPergunta:setFillColor(lib.tituloCardapioColor[1],lib.tituloCardapioColor[2],lib.tituloCardapioColor[3])
    scrollView:insert(textoPergunta)
    
    posY = scrollView._view.height
    
    local rect = display.newRect( 0, 0, lib.distanceX, posY+40)
    rect.x = lib.centerX - lib.leftX
    rect.y = posY*0.5+20
    rect:setFillColor(lib.barraCardapioColor[1],lib.barraCardapioColor[2],lib.barraCardapioColor[3])
    scrollView:insert(rect)
    rect:toBack()
    
    posY = scrollView._view.height
    
    local optTextResposta= 
    {
        --parent = textGroup,
        text = resposta,     
        x = lib.centerX-lib.leftX,
        y = posY +30,
        width = lib.distanceX-60,     --required for multi-line and alignment
        font = lib.textFont,   
        fontSize = 36,
        align = "center"  --new alignment parameter
    }
    
    
    
    local textoResposta = display.newText(optTextResposta)
    textoResposta.anchorY = 0
    textoResposta:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
    scrollView:insert(textoResposta)
    
end

function lib.mostrarCidadesOpiniao(funcRetorno,textBoxVoltaNaTela)
    
    local grupoLojas = display.newGroup()
    local scrollView
    local tabCidades = {}
    local buttons = {}
    
    local usuarioLatitude,usuarioLongitude
    
    local tocouFundo,botaoFecharTapped,lojaSelecionada,lojasProximasTapped,locationHandler
    
    
    
    function tocouFundo()
        return true
    end
    function botaoFecharTapped(sim)
        if grupoLojas ~= nil then
            grupoLojas:removeSelf()
            grupoLojas = nil
            if sim ~= 1 then
                textBoxVoltaNaTela()
            end
        end
    end
    function lojaSelecionada(event)
        botaoFecharTapped(1)
        lib.mostrarLojasOpiniao(funcRetorno,textBoxVoltaNaTela,tabCidades[event.target.num].lojas)
    end
    
    
    
    local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
    backGround:scale(lib.scale,lib.scale)
    backGround:addEventListener("tap",tocouFundo)
    backGround:addEventListener("touch",tocouFundo)
    grupoLojas:insert(backGround)
    
    local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
    backGroundSecondLayer.anchorY = 0
    backGroundSecondLayer:scale(lib.scale,lib.scale)
    grupoLojas:insert(backGroundSecondLayer)
    
    local textoLogo = display.newText(grupoLojas, lib.textos.selecionarCidade, lib.centerX, lib.topY+60, lib.textFont, 60)
    textoLogo = lib.maxWidth(textoLogo,460, 72)
    textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
    
    local botaoFechar = display.newImage("images/alertas/botaoFechar.png", lib.rightX-60, lib.topY+60)
    botaoFechar:addEventListener("tap",botaoFecharTapped)
    grupoLojas:insert(botaoFechar)
    
    
    local opts = {
        top = lib.topY+123,
        left = lib.leftX,
        width = lib.distanceX,
        height = lib.distanceY-134,
        --bottomPadding = 90,
        horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
        hideBackground = false,
        hideScrollBar  = true ,
        backgroundColor = {lib.scrollViewBackColor[1],lib.scrollViewBackColor[2],lib.scrollViewBackColor[3] },
    }   
    scrollView = lib.widget.newScrollView(opts)  
    grupoLojas:insert(scrollView)
    
    local barrinhaVermalhaCima = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.topY+117)
    barrinhaVermalhaCima:scale(lib.scale,1)
    grupoLojas:insert(barrinhaVermalhaCima)
    
    local barrinhaVermalhaBaixo = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.bottomY-6)
    barrinhaVermalhaBaixo:scale(lib.scale,1)
    grupoLojas:insert(barrinhaVermalhaBaixo)
    
    local function funcaoRetornoServico(decoded)
        
        for i = 1 , #decoded.franquias do
            tabCidades[i] = {}
            tabCidades[i].id = decoded.franquias[i].idMunicipio
            tabCidades[i].nome = decoded.franquias[i].noMunicipio
            tabCidades[i].lojas = {}
            for j=1 , #decoded.franquias[i].arrFranquias do
                tabCidades[i].lojas[j] = {}
                tabCidades[i].lojas[j].id = decoded.franquias[i].arrFranquias[j].idFranquia
                tabCidades[i].lojas[j].nome = decoded.franquias[i].arrFranquias[j].noFranquia
                tabCidades[i].lojas[j].latitude = decoded.franquias[i].arrFranquias[j].noLatitude
                tabCidades[i].lojas[j].longitude = decoded.franquias[i].arrFranquias[j].noLongitude
                tabCidades[i].lojas[j].endereco = decoded.franquias[i].arrFranquias[j].noEnderecoAmigavel or "endereco "..i..j
            end
            
            
            buttons[i] = {}
            
            buttons[i].button = display.newImage("images/alertas/botaoListarLojas.png", lib.centerX-lib.leftX, 120*i-50)
            buttons[i].button.num = i
            buttons[i].button:addEventListener("tap",lojaSelecionada)
            scrollView:insert(buttons[i].button)
            
            buttons[i].text = lib.maxWidth(display.newText( tabCidades[i].nome, lib.centerX-lib.leftX, 120*i-50, lib.textFont, 48),350, 60)
            scrollView:insert(buttons[i].text)
            
            print(tabCidades[i].nome)
            
        end
        
        
        
    end
    
    
    lib.servicos({},"mobile/franqueador/listar/lojas",funcaoRetornoServico)
    
    
end

function lib.mostrarLojasOpiniao(funcRetorno,textBoxVoltaNaTela,tabLojas)
    
    local grupoLojas = display.newGroup()
    local scrollView
    local buttons = {}
    
    local usuarioLatitude,usuarioLongitude
    
    local tocouFundo,botaoFecharTapped,lojaSelecionada,lojasProximasTapped,locationHandler
    
    
    
    function tocouFundo()
        return true
    end
    function botaoFecharTapped()
        if grupoLojas ~= nil then
            grupoLojas:removeSelf()
            grupoLojas = nil
            textBoxVoltaNaTela()
        end
    end
    function lojaSelecionada(event)
        botaoFecharTapped()
        funcRetorno(tabLojas[event.target.num])
        
    end
    
    
    
    local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
    backGround:scale(lib.scale,lib.scale)
    backGround:addEventListener("tap",tocouFundo)
    backGround:addEventListener("touch",tocouFundo)
    grupoLojas:insert(backGround)
    
    local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
    backGroundSecondLayer.anchorY = 0
    backGroundSecondLayer:scale(lib.scale,lib.scale)
    grupoLojas:insert(backGroundSecondLayer)
    
    local textoLogo = display.newText(grupoLojas, lib.textos.selecionarLoja, lib.centerX, lib.topY+60, lib.textFont, 60)
    textoLogo = lib.maxWidth(textoLogo,460, 72)
    textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
    
    local botaoFechar = display.newImage("images/alertas/botaoFechar.png", lib.rightX-60, lib.topY+60)
    botaoFechar:addEventListener("tap",botaoFecharTapped)
    grupoLojas:insert(botaoFechar)
    
    
    local opts = {
        top = lib.topY+123,
        left = lib.leftX,
        width = lib.distanceX,
        height = lib.distanceY-134,
        --bottomPadding = 90,
        horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
        hideBackground = false,
        hideScrollBar  = true ,
        backgroundColor = {lib.scrollViewBackColor[1],lib.scrollViewBackColor[2],lib.scrollViewBackColor[3] },
    }   
    scrollView = lib.widget.newScrollView(opts)  
    grupoLojas:insert(scrollView)
    
    local barrinhaVermalhaCima = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.topY+117)
    barrinhaVermalhaCima:scale(lib.scale,1)
    grupoLojas:insert(barrinhaVermalhaCima)
    
    local barrinhaVermalhaBaixo = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.bottomY-6)
    barrinhaVermalhaBaixo:scale(lib.scale,1)
    grupoLojas:insert(barrinhaVermalhaBaixo)
    
    
    for i = 1 , #tabLojas do
        
        buttons[i] = {}
        
        buttons[i].button = display.newImage("images/alertas/botaoListarLojas.png", lib.centerX-lib.leftX, 120*i-50)
        buttons[i].button.num = i
        buttons[i].button:addEventListener("tap",lojaSelecionada)
        scrollView:insert(buttons[i].button)
        
        buttons[i].text = lib.maxWidth(display.newText( tabLojas[i].nome, lib.centerX-lib.leftX, 120*i-50, lib.textFont, 48),350, 60)
        scrollView:insert(buttons[i].text)   
        
        
    end
    
end

function lib.confirmaSimNao(msg,func)
    
    local grupoPop = display.newGroup() 
    local chamarDelete = true 
    
    
    local tocouFundo,deleta ,botaoTapped
    
    function tocouFundo()
        return true
    end
    function deleta()
        if chamarDelete == true then   
            chamarDelete = false
            local function deletaTudo()
                if grupoPop ~= nil then
                    grupoPop:removeSelf()
                    grupoPop = nil
                end
            end
            
            timer.performWithDelay(100, deletaTudo)
        end  
    end
    function botaoTapped(event)
        deleta()
        func(event.target.sim)
    end
    
    local fundoRect = display.newRect( lib.leftX,lib.topY,lib.distanceX,lib.distanceY) 
    fundoRect:setFillColor(0,0,0)
    fundoRect.alpha = 0.7
    fundoRect.anchorX  = 0
    fundoRect.anchorY = 0
    fundoRect:addEventListener("tap",tocouFundo)
    fundoRect:addEventListener("touch",tocouFundo)
    grupoPop:insert(fundoRect)
    
    local caixaPop = display.newImage("images/alertas/popUp.png", lib.centerX, lib.centerY-20)  
    grupoPop:insert(caixaPop)
    
    local rect = display.newRect( 0, 0, 120, 120)
    rect.x = lib.centerX+210
    rect.y = lib.centerY-230
    rect.alpha = 0.01
    rect:addEventListener("tap",deleta)
    grupoPop:insert(rect) 
    
    
    local options = 
    {
        --parent = textGroup,
        text = msg,     
        x = lib.centerX,
        y = lib.centerY-70,
        width = 480,     --required for multi-line and alignment
        font = lib.textFont,   
        fontSize = 32,
        align = "center"  --new alignment parameter
    }
    
    local textoPop = display.newText( options )
    textoPop:setFillColor(lib.errorTextColor[1],lib.errorTextColor[2],lib.errorTextColor[3])
    grupoPop:insert(textoPop) 
    
    local botaoSim = display.newImage("images/alertas/botaoSim.png", lib.centerX, lib.centerY+60)
    botaoSim.sim = 1
    botaoSim:addEventListener("tap",botaoTapped)
    grupoPop:insert(botaoSim)
    
    local botaoNao = display.newImage("images/alertas/botaoNao.png", lib.centerX, lib.centerY+180)
    botaoNao.sim = 0
    botaoNao:addEventListener("tap",botaoTapped)
    grupoPop:insert(botaoNao)
    
    
end

function lib.mostraSexo(sexo)
    
    local stg
    if  sexo == "M" then
        stg = "Masculino"
    elseif sexo == "F" then
        stg = "Feminino"
    else
        stg = "Unisex"
    end
    
    return stg
    
end

function lib.esqueciMinhaSenha()
    
    local grupoUsarSaldo = display.newGroup() 
    
    local textoSaldo ,  textField
    
    local tocouFundo , focusTextField , textos , botaoOkTapped , xTapped
    
    function tocouFundo()
        return true
    end
    function focusTextField()  
        native.setKeyboardFocus(textField)
    end
    function textos(textEvent)
        
        if ( textEvent.phase == "began" ) then
            
            
            textField.text = textoSaldo.text 
            
        elseif (  textEvent.phase == "submitted" ) then
            
            botaoOkTapped()
            
        elseif ( textEvent.phase == "editing" ) then
            
            
            if string.len(textField.text) <= 50 then
                
                
                
                
                textoSaldo.text = textField.text
                lib.maxWidth(textoSaldo,460, 72)
                
                
            else
                
                textField.text =  string.sub(textField.text,1,50)  
                
                
            end
            
        end
        
    end 
    function xTapped()
        
        textField:removeSelf()
        textField = nil
        
        native.setKeyboardFocus(nil)
        
        grupoUsarSaldo:removeSelf()
        grupoUsarSaldo = nil
        
    end
    function botaoOkTapped ()
        
        
        local function funcaoRetorno(decoded)
            lib.criarPopUp(decoded.mensagem)
        end
        
        print(textoSaldo.text)
        if textoSaldo.text == "" then 
            -- lib.criarPopUp("Digite seu email")
        else
            xTapped()     
            lib.servicos({["noEmail"] = textoSaldo.text },"mobile/usuario/recuperar-senha",funcaoRetorno)
        end
        
    end
    
    local fundoRect = display.newRect( lib.leftX,lib.topY,lib.distanceX,lib.distanceY) 
    fundoRect:setFillColor(0,0,0)
    fundoRect.alpha = 0.7
    fundoRect.anchorX  = 0
    fundoRect.anchorY = 0
    fundoRect:addEventListener("tap",tocouFundo)
    fundoRect:addEventListener("touch",tocouFundo)
    grupoUsarSaldo:insert(fundoRect)   
    
    local caixaPop = display.newImage("images/alertas/popUpEsqueciMinhaSenha.png", lib.centerX, lib.centerY-190)  
    grupoUsarSaldo:insert(caixaPop)
    
    local botaoOk = display.newImage("images/alertas/botaoEnviar.png", lib.centerX, lib.centerY+20) 
    botaoOk:addEventListener("tap", botaoOkTapped)
    grupoUsarSaldo:insert(botaoOk) 
    
    local xButton = display.newCircle( 0, 0, 90)
    xButton.x = lib.centerX +210
    xButton.y = lib.centerY-360
    xButton.alpha = 0.01
    xButton:addEventListener("tap",xTapped )
    grupoUsarSaldo:insert(xButton) 
    
    
    textoSaldo = display.newText( "" , lib.centerX , lib.centerY-120, lib.textFont, 48)
    textoSaldo:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
    grupoUsarSaldo:insert(textoSaldo) 
    
    textField = native.newTextField( 0,-1000, 447, 50 )
    textField.x = -1000
    textField.y = -1000
    textField.inputType = "email"
    textField:addEventListener( "userInput", textos )
    
    
    transition.to(textField,{time = 300, onComplete = focusTextField })
    
    
end

function lib.enquete(idEnquete,perguntaText,resp1Text,resp2Text,resp3Text,id1,id2,id3)
    
    local grupoEnquete = display.newGroup() 
    
    local tocouFundo   , botaoTapped , xTapped
    
    function tocouFundo()
        return true
    end
    function xTapped()
        
        grupoEnquete:removeSelf()
        grupoEnquete = nil
        
    end
    function botaoOkTapped (event)
        
        local function funcaoRetornoResposta(decoded)
            
            xTapped()
            
        end
        
        
        
        lib.servicos({["idUsuario"] = lib.dadosUsuario.id ,["idResposta"] = event.target.id , ["idEnquete"] = idEnquete  },"mobile/enquete/responder",funcaoRetornoResposta)
        
    end
    
    local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
    backGround:scale(lib.scale,lib.scale)
    backGround:addEventListener("tap",tocouFundo)
    backGround:addEventListener("touch",tocouFundo)
    grupoEnquete:insert(backGround) 
    
    local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
    backGroundSecondLayer.anchorY = 0
    backGroundSecondLayer:scale(lib.scale,lib.scale)
    grupoEnquete:insert(backGroundSecondLayer)
    
    local textoLogo = display.newText(grupoEnquete, lib.textos.textLogoEnquete, lib.centerX, lib.topY+60, lib.textFont, 60)
    textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
    
    local botaoFechar = display.newImage("images/alertas/botaoFechar.png", lib.rightX-60, lib.topY+60)
    botaoFechar.id = 0
    grupoEnquete:insert(botaoFechar)
    botaoFechar:addEventListener("tap",botaoOkTapped)
    
    local retanguloBack = display.newRect(0,0,lib.distanceX,610)
    retanguloBack.x = lib.centerX
    retanguloBack.y = lib.centerY+130
    grupoEnquete:insert(retanguloBack)
    
    local barrinhaVermalhaCima = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.centerY-180)
    barrinhaVermalhaCima:scale(lib.scale,1)
    grupoEnquete:insert(barrinhaVermalhaCima)
    
    local barrinhaVermalhaBaixo = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.centerY+430)
    barrinhaVermalhaBaixo:scale(lib.scale,1)
    grupoEnquete:insert(barrinhaVermalhaBaixo)
    
    
    local optsPergunta = 
    {
        --parent = textGroup,
        text = perguntaText,   
        parent = grupoEnquete,
        x = lib.centerX,
        y = lib.topY+200,
        width = lib.distanceX-20,     --required for multi-line and alignment
        font = lib.textFont,   
        fontSize = 40,
        align = "center"  --new alignment parameter
    }
    local pergunta = display.newText(optsPergunta)
    pergunta = lib.maxWidth(pergunta,lib.distanceX-20, 210)
    
    
    
    
    local botaoResp1 = display.newImage("images/alertas/botao.png", lib.centerX, lib.centerY-70)
    botaoResp1.id = id1
    botaoResp1:addEventListener("tap",botaoOkTapped)
    grupoEnquete:insert(botaoResp1)
    
    local textResp1 = display.newText(grupoEnquete, resp1Text, lib.centerX, botaoResp1.y,  lib.textFont, 48)
    textResp1:setFillColor(lib.textEnqueteColor[1],lib.textEnqueteColor[2],lib.textEnqueteColor[3])
    textResp1 = lib.maxWidth(textResp1,550, 72)
    
    local botaoResp2 = display.newImage("images/alertas/botao.png", lib.centerX, lib.centerY+120)
    botaoResp2.id = id2
    botaoResp2:addEventListener("tap",botaoOkTapped)
    grupoEnquete:insert(botaoResp2)
    
    local textResp2 = display.newText(grupoEnquete, resp2Text, lib.centerX, botaoResp2.y,  lib.textFont, 48)
    textResp2:setFillColor(lib.textEnqueteColor[1],lib.textEnqueteColor[2],lib.textEnqueteColor[3])
    textResp2 = lib.maxWidth(textResp2,550, 72)
    
    if resp3Text ~= nil and resp3Text ~= "" then
        
        local botaoResp3 = display.newImage("images/alertas/botao.png", lib.centerX, lib.centerY+310)
        botaoResp3.id = id3
        botaoResp3:addEventListener("tap",botaoOkTapped)
        grupoEnquete:insert(botaoResp3)
        
        local textResp3 = display.newText(grupoEnquete, resp3Text, lib.centerX, botaoResp3.y,  lib.textFont, 48)
        textResp3:setFillColor(lib.textEnqueteColor[1],lib.textEnqueteColor[2],lib.textEnqueteColor[3])
        textResp3 = lib.maxWidth(textResp3,550, 72)
        
    else
        
        botaoResp1.y = lib.centerY+20
        textResp1.y = botaoResp1.y  
        
        botaoResp2.y =   lib.centerY+220
        textResp2.y = botaoResp2.y
        
    end
    
    
end

function lib.feedBack(tabLoja,tabItem1,tabItem2,tabItem3,idRequisicao,feedBackPergunta)
    
    local textBox, createTextBox, deleteTextBox
    local textboxText = ""
    local feedBackGroup = display.newGroup()
    
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
        textBox.text = textboxText
        textBox.isEditable = true
        textBox.isFontSizeScaled = true  
        textBox.size = 40
        textBox.hasBackground = false
        textBox.placeholder = lib.textos.digiteOpiniao
        textBox:addEventListener( "userInput", textBoxListener )
        
    end    
    
    local item1Text,item2Text,item3Text
    local item1,item2,item3  = 0,0,0
    local estrelasItem1,estrelasItem2,estrelasItem3 = {},{},{}
    local estrelasItem1Amarela,estrelasItem2Amarela,estrelasItem3Amarela = {},{},{}
    
    
    local function textBoxSaiDaTela()
        textBox.x = -1000
        textBox.y = -1000
    end
    local function textBoxVoltaNaTela()
        textBox.x = lib.centerX
        textBox.y = lib.centerY-80
    end
    
    local function deletaGrupos()
        deleteTextBox()
        feedBackGroup:removeSelf()
        feedBackGroup = nil
    end
    local function botaoSairTapped()
        deletaGrupos()
        
        local tabResposta = {
            {idResposta = tabItem1.id,nuResposta = "" },
            {idResposta = tabItem2.id,nuResposta = "" },
            {idResposta = tabItem3.id,nuResposta = "" },
        }
        
        lib.servicos({["tipo"]= 1,["idRequisicao"] = idRequisicao ,["idUsuario"] = lib.dadosUsuario.id ,["idFranquia"]=tabLoja.id, ["dsResposta"] = "",["arrResposta"] = tabResposta },"mobile/feedback/responder")
        
        
        
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
            lib.criarPopUp(decoded.mensagem,deletaGrupos,true)
        end
        
        if item1 == 0 or item2 == 0 or item3 == 0 then
            
            textBoxSaiDaTela()
            lib.criarPopUp(lib.textos.coloqueEstrela,textBoxVoltaNaTela) 
            
        else
            
            textBoxSaiDaTela()
            
            local tabResposta = {
                {idResposta = tabItem1.id,nuResposta = item1 },
                {idResposta = tabItem2.id,nuResposta = item2 },
                {idResposta = tabItem3.id,nuResposta = item3 },
            }
            
            lib.servicos({["tipo"]= 1,["idRequisicao"] = idRequisicao ,["idUsuario"] = lib.dadosUsuario.id ,["idFranquia"]=tabLoja.id, ["dsResposta"] = textBox.text,["arrResposta"] = tabResposta },"mobile/feedback/responder",funcaoRetornoOpiniao)
            
        end
        
    end
    local function backgroundTapped()
        native.setKeyboardFocus( nil )
        return true
    end
    
    local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
    backGround:addEventListener("tap",backgroundTapped)
    backGround:scale(lib.scale,lib.scale)
    feedBackGroup:insert(backGround)
    
    local backGroundSecondLayer = display.newImage("images/login/secondBackground.png", lib.centerX, lib.topY+120)
    backGroundSecondLayer.anchorY = 0
    backGroundSecondLayer:scale(lib.scale,lib.scale)
    feedBackGroup:insert(backGroundSecondLayer)
    
    local textoLogo = display.newText(feedBackGroup, lib.textos.feedBack, lib.centerX+20, lib.topY+60, lib.textFont, 60)
    textoLogo = lib.maxWidth(textoLogo,380, 72)
    textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
    
    
    local botaoFechar = display.newImage("images/alertas/botaoFechar.png", lib.rightX-60, lib.topY+60)
    botaoFechar.id = 0
    feedBackGroup:insert(botaoFechar)
    botaoFechar:addEventListener("tap",botaoSairTapped)
    
    lojaSelecionada = display.newText(feedBackGroup, tabLoja.nome, lib.centerX, lib.centerY-320, lib.textFont, 36)
    lojaSelecionada:setFillColor(lib.textEnqueteColor[1],lib.textEnqueteColor[2],lib.textEnqueteColor[3])
    
    local pergunta = display.newText(feedBackGroup, feedBackPergunta, lib.centerX, lib.centerY-250, lib.textFont, 36)
    pergunta = lib.maxWidth(pergunta,600, 44)
    pergunta:setFillColor(lib.textEnqueteColor[1],lib.textEnqueteColor[2],lib.textEnqueteColor[3])
    
    
    local campoOpiniao = display.newImage("images/opiniao/caixa.png", lib.centerX, lib.centerY-80)
    campoOpiniao:addEventListener("tap",textBoxVoltaNaTela)
    feedBackGroup:insert(campoOpiniao)
    
    
    item1Text = display.newText(feedBackGroup, tabItem1.nome, lib.centerX - 295, lib.centerY+80, lib.textFont, 36)
    item1Text.anchorX = 0
    item1Text = lib.maxWidth(item1Text,180, 44)
    item1Text:setFillColor(lib.textEnqueteColor[1],lib.textEnqueteColor[2],lib.textEnqueteColor[3])
    
    for i = 1,4 do
        estrelasItem1[i] = display.newImage("images/opiniao/botaoEstrela.png", lib.centerX - 180+(i*110), lib.centerY+70)
        estrelasItem1[i].item = i
        estrelasItem1[i]:addEventListener("tap",mudaItem1)
        feedBackGroup:insert( estrelasItem1[i])
    end
    for i = 1,4 do
        estrelasItem1Amarela[i] = display.newImage("images/opiniao/botaoEstrelaClicado.png", lib.centerX - 180+(i*110), lib.centerY+70)
        estrelasItem1Amarela[i].alpha = 0
        feedBackGroup:insert( estrelasItem1Amarela[i])
    end
    
    
    item2Text = display.newText(feedBackGroup, tabItem2.nome, lib.centerX - 295, lib.centerY+170, lib.textFont, 36)
    item2Text = lib.maxWidth(item2Text,180, 44)
    item2Text.anchorX = 0
    item2Text:setFillColor(lib.textEnqueteColor[1],lib.textEnqueteColor[2],lib.textEnqueteColor[3])
    
    for i = 1,4 do
        estrelasItem2[i] = display.newImage("images/opiniao/botaoEstrela.png", lib.centerX - 180+(i*110), lib.centerY+160)
        estrelasItem2[i].item = i
        estrelasItem2[i]:addEventListener("tap",mudaItem2)
        feedBackGroup:insert( estrelasItem2[i])
    end
    for i = 1,4 do
        estrelasItem2Amarela[i] = display.newImage("images/opiniao/botaoEstrelaClicado.png", lib.centerX - 180+(i*110), lib.centerY+160)
        estrelasItem2Amarela[i].alpha = 0
        feedBackGroup:insert( estrelasItem2Amarela[i])
    end
    
    item3Text = display.newText(feedBackGroup, tabItem3.nome, lib.centerX - 295, lib.centerY+260, lib.textFont, 36)
    item3Text = lib.maxWidth(item3Text,180, 44)
    item3Text.anchorX = 0
    item3Text:setFillColor(lib.textEnqueteColor[1],lib.textEnqueteColor[2],lib.textEnqueteColor[3])
    
    for i = 1,4 do
        estrelasItem3[i] = display.newImage("images/opiniao/botaoEstrela.png", lib.centerX - 180+(i*110), lib.centerY+250)
        estrelasItem3[i].item = i
        estrelasItem3[i]:addEventListener("tap",mudaItem3)
        feedBackGroup:insert( estrelasItem3[i])
    end
    for i = 1,4 do
        estrelasItem3Amarela[i] = display.newImage("images/opiniao/botaoEstrelaClicado.png", lib.centerX - 180+(i*110), lib.centerY+250)
        estrelasItem3Amarela[i].alpha = 0
        feedBackGroup:insert( estrelasItem3Amarela[i])
    end
    
    
    local botaoConcluido = display.newImage("images/opiniao/botaoConcluido.png", lib.centerX, lib.bottomY - 100)
    botaoConcluido:addEventListener("tap",botaoConcluidoTapped)
    feedBackGroup:insert(botaoConcluido)    
    
    
    
    createTextBox()    
    
end

function lib.mostrarExtrato()
    
    local grupoExtrato = display.newGroup()
    local scrollView  
    local conteudo = {}
    
    local tocouFundo , botaoFecharTapped , funcaoRetornoServicoExtrato
    
    function tocouFundo()
        return true
    end
    function botaoFecharTapped()
        grupoExtrato:removeSelf()
        grupoExtrato = nil
    end
    function funcaoRetornoServicoExtrato(decoded)
        
        local posY
        for i = 1 , #decoded.arrExtrato do
            
            posY = scrollView._view.height
            
            
            if i ~= 1 then
                posY = posY +30  
            end
            
            conteudo[i] = {}
            
            conteudo[i].rectCinza = display.newRect( 0, 0, lib.distanceX, 4)
            conteudo[i].rectCinza:setFillColor(lib.barraCardapioColor[1],lib.barraCardapioColor[2],lib.barraCardapioColor[3])
            conteudo[i].rectCinza.x = lib.centerX-lib.leftX
            conteudo[i].rectCinza.y = posY
            scrollView:insert(conteudo[i].rectCinza)
            
            conteudo[i].textoDataNumero = display.newText( decoded.arrExtrato[i].dtDia, 20, posY+50,  lib.textFont, 36)
            conteudo[i].textoDataNumero:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
            conteudo[i].textoDataNumero.anchorX = 0
            scrollView:insert(conteudo[i].textoDataNumero)
            
            
            conteudo[i].textoHoraNumero = display.newText( decoded.arrExtrato[i].dtHora, lib.centerX-lib.leftX, posY+50,  lib.textFont, 36)
            conteudo[i].textoHoraNumero:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
            scrollView:insert(conteudo[i].textoHoraNumero)
            
            
            if decoded.arrExtrato[i].idTipoTransacao == 1 then
                
                conteudo[i].textoValorNumero = display.newText( lib.textos.mais..decoded.arrExtrato[i].nuValor, lib.distanceX-20, posY+50,  lib.textFont, 36)
                conteudo[i].textoValorNumero:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
                
            else
                
                conteudo[i].textoValorNumero = display.newText( lib.textos.traco..decoded.arrExtrato[i].nuValor, lib.distanceX-20, posY+50,  lib.textFont, 36)
                conteudo[i].textoValorNumero:setFillColor(lib.tituloCardapioColor[1],lib.tituloCardapioColor[2],lib.tituloCardapioColor[3])
                
            end
            conteudo[i].textoValorNumero.anchorX = 1
            scrollView:insert(conteudo[i].textoValorNumero)
            
            
            
            conteudo[i].textoDescricao = display.newText( decoded.arrExtrato[i].noFranquia, lib.distanceX-20, posY+130,lib.distanceX-40,0,  lib.textFont, 36)
            conteudo[i].textoDescricao:setFillColor(lib.textLightColor[1],lib.textLightColor[2],lib.textLightColor[3])
            conteudo[i].textoDescricao.anchorX = 1
            scrollView:insert(conteudo[i].textoDescricao)
            
            
        end
        
    end
    
    local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
    backGround:scale(lib.scale,lib.scale)
    backGround:addEventListener("tap",tocouFundo)
    backGround:addEventListener("touch",tocouFundo)
    grupoExtrato:insert(backGround)
    
    local textoLogo = display.newText(grupoExtrato, lib.textos.extrato, lib.centerX, lib.topY+60, lib.textFont, 60)
    textoLogo = lib.maxWidth(textoLogo,460, 72)
    textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
    
    local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
    botaoVoltar:addEventListener("tap",botaoFecharTapped)
    grupoExtrato:insert(botaoVoltar)
    
    local opts = {
        top = lib.topY+123,
        left = lib.leftX,
        width = lib.distanceX,
        height = lib.distanceY-134,
        bottomPadding = 80,
        horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
        hideBackground = false,
        hideScrollBar  = true ,
        backgroundColor = {lib.scrollViewBackColor[1],lib.scrollViewBackColor[2],lib.scrollViewBackColor[3] },
    }   
    scrollView = lib.widget.newScrollView(opts)  
    grupoExtrato:insert(scrollView)
    
    local barrinhaVermalhaCima = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.topY+117)
    barrinhaVermalhaCima:scale(lib.scale,1)
    grupoExtrato:insert(barrinhaVermalhaCima)
    
    local barrinhaVermalhaBaixo = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.bottomY-6)
    barrinhaVermalhaBaixo:scale(lib.scale,1)
    grupoExtrato:insert(barrinhaVermalhaBaixo)
    
    local rectCinza = display.newRect( 0, 0, lib.distanceX, 100)
    rectCinza:setFillColor(lib.barraCardapioColor[1],lib.barraCardapioColor[2],lib.barraCardapioColor[3])
    rectCinza.x = lib.centerX-lib.leftX
    rectCinza.y =50
    scrollView:insert(rectCinza)
    
    local textoData = display.newText( lib.textos.data, 20, 50,  lib.textFont, 48)
    textoData:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
    textoData.anchorX = 0
    scrollView:insert(textoData)
    
    local textoHora = display.newText( lib.textos.hora, lib.centerX-lib.leftX, 50,  lib.textFont, 48)
    textoHora:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
    scrollView:insert(textoHora)
    
    local textoValor = display.newText( lib.textos.valor, lib.distanceX-20, 50,  lib.textFont, 48)
    textoValor:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
    textoValor.anchorX = 1
    scrollView:insert(textoValor)
    
    
    print(lib.dadosUsuario.id)
    lib.servicos({["idUsuario"] = lib.dadosUsuario.id},"mobile/usuario/extrato",funcaoRetornoServicoExtrato)
    
    
end

function lib.detalhesCardapio(nome,valor,descricao,urlImg)
    
    local detalhesCardapioGroup = display.newGroup()
    
    local scrollView
    local posY
    local transitionImage  = true
    local imgPosY , imgPosX
    
    local function backgroundTapped()
        return true
    end
    local function botaoFecharTapped()
        
        transitionImage = false
        detalhesCardapioGroup:removeSelf()
        detalhesCardapioGroup = nil
        
    end
    
    local function imageCardapioLoader(event)
        
        if ( event.isError ) then
            print ( "Network error - download failed" )
        else
            
            if transitionImage == true then
                event.target.width = 640
                event.target.height = 238
                event.target:scale(lib.scale,lib.scale)
                event.target.x = imgPosX
                event.target.y = imgPosY
                scrollView:insert(event.target)
                --event.target:toBack()
            else
                event.target:removeSelf()
                event.target = nil
            end
            
        end
        
    end
    
    
    local backGround = display.newImage("images/login/background.png", lib.centerX, lib.centerY)
    backGround:addEventListener("tap",backgroundTapped)
    backGround:scale(lib.scale,lib.scale)
    detalhesCardapioGroup:insert(backGround)
    
    local botaoVoltar = display.newImage("images/menu/botaoVoltar.png", lib.leftX +60, lib.topY+60)
    botaoVoltar:addEventListener("tap",botaoFecharTapped)
    detalhesCardapioGroup:insert(botaoVoltar)
    
    local textoLogo = lib.maxWidth(display.newText(detalhesCardapioGroup, nome, lib.centerX, lib.topY+60, lib.textFont, 60),380,72) 
    textoLogo:setFillColor(lib.textLogoColor[1],lib.textLogoColor[2],lib.textLogoColor[3])
    
    
    
    local opts = {
        top = lib.topY+123,
        left = lib.leftX,
        width = lib.distanceX,
        height = lib.distanceY-134,
        --bottomPadding = 90,
        horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
        hideBackground = false,
        hideScrollBar  = true ,
        backgroundColor = {lib.scrollViewBackColor[1],lib.scrollViewBackColor[2],lib.scrollViewBackColor[3] },
    }   
    scrollView = lib.widget.newScrollView(opts)  
    detalhesCardapioGroup:insert(scrollView)
    
    local barrinhaVermalhaCima = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.topY+117)
    barrinhaVermalhaCima:scale(lib.scale,1)
    detalhesCardapioGroup:insert(barrinhaVermalhaCima)
    
    local barrinhaVermalhaBaixo = display.newImage("images/cadastro/barrinhaVermelha.png", lib.centerX, lib.bottomY-6)
    barrinhaVermalhaBaixo:scale(lib.scale,1)
    detalhesCardapioGroup:insert(barrinhaVermalhaBaixo)
    
    
    local rect = display.newRect( 0, 0, 640, 238)
    rect:scale(lib.scale,lib.scale)
    rect.y = 119*lib.scale
    rect.x = lib.centerX - lib.leftX
    imgPosY , imgPosX = rect.y , rect.x
    rect:setFillColor(lib.imagemBackColor[1],lib.imagemBackColor[2],lib.imagemBackColor[2])
    scrollView:insert(rect)
    
    local carregando  = display.newImage("images/lojas/iconeCamera.png")
    carregando.x = rect.x
    carregando.y = rect.y
    scrollView:insert(carregando)
    
    posY = scrollView._view.height
    
    local rectSeparador = display.newRect( 0, 0, lib.distanceX, 100)
    rectSeparador.y = posY + 50
    rectSeparador.x = lib.centerX - lib.leftX
    rectSeparador:setFillColor(lib.barraCardapioColor[1],lib.barraCardapioColor[2],lib.barraCardapioColor[2])
    scrollView:insert(rectSeparador)
    
    local textoValor = display.newText( valor, lib.centerX-lib.leftX, posY + 50,lib.textFont, 48)
    textoValor:setFillColor(lib.saldoColor[1],lib.saldoColor[2],lib.saldoColor[2])
    scrollView:insert(textoValor)
    
    posY = scrollView._view.height
    
    local textoDesc = display.newText( lib.textos.descricao, 20, posY + 40, lib.distanceX-40,0,lib.textFont, 48)
    textoDesc.anchorX = 0
    textoDesc:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[2])
    scrollView:insert(textoDesc)
    
    
    local textoDescricao = display.newText( descricao, 20, posY + 80, lib.distanceX-40,0,lib.textFont, 36)
    textoDescricao.anchorX = 0
    textoDescricao.anchorY = 0
    textoDescricao:setFillColor(lib.textDarkColor[1],lib.textDarkColor[2],lib.textDarkColor[2])
    scrollView:insert(textoDescricao)
    
    
    local img = display.loadRemoteImage( urlImg, "GET", imageCardapioLoader, "imagemCardapio",system.TemporaryDirectory)
    
    
end

function lib.confirmarSenha(msg,funcaoRetorno)
    
    local grupoSenha = display.newGroup() 
    
    local textoSenha ,  textField
    
    local tocouFundo , focusTextField , textos , botaoOkTapped , xTapped
    
    function tocouFundo()
        return true
    end
    function focusTextField()  
        native.setKeyboardFocus(textField)
    end
    function textos(textEvent)
        
        if ( textEvent.phase == "began" ) then
            
            
            textField.text = textoSenha.text 
            
            
            
        elseif (  textEvent.phase == "submitted" ) then
            
            botaoOkTapped()
            
        elseif ( textEvent.phase == "editing" ) then
            
            
            if string.len(textField.text) <= 55 then
                
                
                textoSenha.text = textField.text
                textoSenha = lib.maxWidth(textoSenha,480, 56)
                
            else
                
                textField.text =  string.sub(textField.text,1,55)  
                
                
            end
            
            
            
        end
        
    end 
    function xTapped()
        
        textField:removeSelf()
        textField = nil
        
        native.setKeyboardFocus(nil)
        
        grupoSenha:removeSelf()
        grupoSenha = nil
        
        
        
    end
    function botaoOkTapped ()
        
        if textoSenha.text == "" then 
            -- lib.criarPopUp("Digite seu email")
        else
            xTapped()
            funcaoRetorno(textoSenha.text)
        end      
        
        
    end
    
    local fundoRect = display.newRect( lib.leftX,lib.topY,lib.distanceX,lib.distanceY) 
    fundoRect:setFillColor(0,0,0)
    fundoRect.alpha = 0.7
    fundoRect.anchorX  = 0
    fundoRect.anchorY = 0
    fundoRect:addEventListener("tap",tocouFundo)
    fundoRect:addEventListener("touch",tocouFundo)
    grupoSenha:insert(fundoRect)   
    
    local caixaPop = display.newImage("images/alertas/popUpSenha.png", lib.centerX, lib.centerY-190)  
    grupoSenha:insert(caixaPop)
    
    local botaoOk = display.newImage("images/saldo/botaoConfirmar.png", lib.centerX, lib.centerY+5) 
    botaoOk:addEventListener("tap", botaoOkTapped)
    grupoSenha:insert(botaoOk) 
    
    local xButton = display.newCircle( 0, 0, 90)
    xButton.x = lib.centerX +210
    xButton.y = lib.centerY-360
    xButton.alpha = 0.01
    xButton:addEventListener("tap",xTapped )
    grupoSenha:insert(xButton) 
    
    local options = 
    {
        --parent = textGroup,
        text = msg,   
        x = lib.centerX,
        y = lib.centerY-195,
        width = 480,     --required for multi-line and alignment
        font = lib.textFont,   
        fontSize = 32,
        align = "center"  --new alignment parameter
    }
    
    local textoPop = display.newText( options )
    textoPop:setFillColor(lib.errorTextColor[1],lib.errorTextColor[2],lib.errorTextColor[3]) 
    grupoSenha:insert(textoPop) 
    
    textoSenha = display.newText( "" , lib.centerX , lib.centerY-95, lib.passFont, 48)
    textoSenha:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
    grupoSenha:insert(textoSenha) 
    
    textField = native.newTextField( 0,-1000, 447, 50 )
    textField.x = -1000
    textField.y = -1000
    textField.isSecure = true
    textField.inputType = "default"
    textField:addEventListener( "userInput", textos )
    
    transition.to(textField,{time = 300, onComplete = focusTextField })
    
    
end

function lib.confirmarValor(funcaoRetorno)
    
    local grupoSaldo = display.newGroup() 
    
    local textoSenha ,  textField
    
    local tocouFundo , focusTextField , textos , botaoOkTapped , xTapped
    
    function tocouFundo()
        return true
    end
    function focusTextField()  
        native.setKeyboardFocus(textField)
    end
    function textos(textEvent)
        
        if ( textEvent.phase == "began" ) then
            
            
            textField.text = textoSaldoPop.text 
            
        elseif (  textEvent.phase == "submitted" ) then
            
            botaoOkTapped()
            
        elseif ( textEvent.phase == "editing" ) then
            
            
            if string.len(textField.text) <= 15 then
                
                if textField.text == "" then
                    textField.text = 0
                end   
                
                
                textoSaldoPop.text = lib.dinheiroMask(textField.text/100)
                
                
            else
                
                textField.text =  string.sub(textField.text,1,15)  
                
                
            end
            
        end
        
    end 
    function xTapped()
        
        textField:removeSelf()
        textField = nil
        
        native.setKeyboardFocus(nil)
        
        grupoSaldo:removeSelf()
        grupoSaldo = nil
        
        
        
    end
    function botaoOkTapped ()
        
        if textoSaldoPop.text == "0.00" then 
            -- lib.criarPopUp("Digite seu email")
        else
            xTapped()
            funcaoRetorno(textoSaldoPop.text)
        end      
        
        
    end
    
    local fundoRect = display.newRect( lib.leftX,lib.topY,lib.distanceX,lib.distanceY) 
    fundoRect:setFillColor(0,0,0)
    fundoRect.alpha = 0.7
    fundoRect.anchorX  = 0
    fundoRect.anchorY = 0
    fundoRect:addEventListener("tap",tocouFundo)
    fundoRect:addEventListener("touch",tocouFundo)
    grupoSaldo:insert(fundoRect)   
    
    local caixaPop = display.newImage("images/saldo/popUp.png", lib.centerX, lib.centerY-190)  
    grupoSaldo:insert(caixaPop)
    
    local botaoOk = display.newImage("images/saldo/botaoConfirmar.png", lib.centerX, lib.centerY) 
    botaoOk:addEventListener("tap", botaoOkTapped)
    grupoSaldo:insert(botaoOk) 
    
    local xButton = display.newCircle( 0, 0, 90)
    xButton.x = lib.centerX +210
    xButton.y = lib.centerY-360
    xButton.alpha = 0.01
    xButton:addEventListener("tap",xTapped )
    grupoSaldo:insert(xButton) 
    
    
    textoSaldoPop = display.newText( "0.00" , lib.centerX , lib.centerY-135, lib.textFont, 48)
    textoSaldoPop:setFillColor(lib.textConteudoColor[1],lib.textConteudoColor[2],lib.textConteudoColor[3])
    grupoSaldo:insert(textoSaldoPop) 
    
    textField = native.newTextField( 0,-1000, 447, 50 )
    textField.x = -1000
    textField.y = -1000
    textField.isSecure = true
    textField.inputType = "number"
    textField:addEventListener( "userInput", textos )
    
    transition.to(textField,{time = 300, onComplete = focusTextField })
    
    
end   

function lib.removerCenas()
    local tabCenas = {
        "main_login","main_lojas","main_mais","main_menu","main_meuCadastro","main_saldo","main_opiniao",
    }
    
    for i =1,#tabCenas do
        lib.composer.removeScene(tabCenas[i]) 
    end
    
end

function lib.validarCpf(cpf)
    
   --[[
   Explicação do Calculo: 
                http://ghiorzi.org/DVnew.htm
                https://br.answers.yahoo.com/question/index?qid=20061003164401AAoczt5
                A melhor explicação: http://gurudoexcel.com/blog/como-e-feito-o-calculo-de-validacao-cpf/

   DV = Digito de Verificação
   RF = Região Fiscal

   - Os primeiros 8 digitos são o número base.
   - O nono digito é a Região Fiscal (RF). 
   - O décimo digito (penultimo) é o DV MOD 11 dos 9 digitos anteriores.
   - O ultimo digito é o DV MOD 11 dos 10 digitos anteriores.

    ]]
    
    
    local c = cpf:sub(1,9)
    local dv = 0
    
    for i, d in c:gmatch"()(.)" do
        dv = dv + tonumber(d)*(11-i)
    end
    
    if dv == 0 then
        return false
    end
    
    dv = 11 - math.fmod(dv, 11)
    
    if dv > 9 then
        dv = 0
    end
    
    if dv ~= tonumber(cpf:sub(10,10)) then
        return false
    end
    
    dv = dv * 2
    for i, d in c:gmatch"()(.)" do
        dv = dv + tonumber(d)*(12-i)
    end
    dv = 11 - math.fmod(dv, 11)
    if dv > 9 then
        dv = 0
    end
    
    
    return dv == tonumber(cpf:sub(11))
    
end



function lib.cursorSome()
    lib.cursor.transition =  transition.to(lib.cursor,{time = 1000,alpha = 0,onComplete = lib.cursorAparece })
end
function lib.cursorAparece(opt)
    local cursorColor = opt.cursorColor or false
    if cursorColor ~= false then
        lib.cursor:setFillColor(lib[cursorColor][1],lib[cursorColor][2],lib[cursorColor][3])
    end
    lib.cursor.alpha = 1
    lib.cursor.transition =  transition.to(lib.cursor,{time = 700,alpha = 1,onComplete = lib.cursorSome })
end
function lib.cursorPara()
    transition.cancel(lib.cursor.transition)
end

lib.scrollView,lib.tableDefaultText, lib.tableText = {},{},{}

function lib.campTapped(event)
    
    --obrigatorio // textEdit , cena
    --opicional // align,maxChar,mask,inputType,isSexure,cusorColor , usaScroll , maxWidth , maxHeight , scrollY
    
    local cena = event.target.cena
    
    
    local usaScroll = event.target.usaScroll or true
    local align = event.target.align or "left"
    local maxChar =  event.target.maxChar or 35
    local mask = event.target.mask or "noMask"
    local inputType = event.target.inputType or "default"
    local isSecure = event.target.isSecure or false
    local cursorColor = event.target.cursorColor or "textConteudoColor"
    local textColor = event.target.textColor or "textConteudoColor"
    local maxWidth = event.target.maxWidth or 540
    local maxHeight = event.target.maxHeight or 88
    local scrollY = event.target.scrollY or 100
    
    lib.tableDefaultText[cena][event.target.textEdit].alpha = 0
    
    
    
    local function focusTextField()
        
        native.setKeyboardFocus(textField)
        
    end
    
    local function deleteTextField(ob)
        
        if  textField.text == "" then
            lib.tableDefaultText[cena][event.target.textEdit].alpha = 1
            lib.tableText[cena][event.target.textEdit].text = ""
        end
        
        
        
        textField:removeSelf()
        textField = nil
        native.setKeyboardFocus( nil )
        
        ob.target:removeSelf()
        ob.target = nil
        
        
        lib.cursorPara()
        lib.cursor:removeSelf()
        lib.cursor = nil
        
        
        
        
        local opts = {
            y = 0,
            time = 300,
        }
        lib.scrollView[cena]:scrollToPosition( opts ) 
        
        
        
        
    end
    
    local function textos(textEvent)
        
        if ( textEvent.phase == "began" ) then
            
            
            lib.tableText[cena][event.target.textEdit].text = lib[mask].apply(textField.text)
            
            lib.cursor.x = lib.tableText[cena][event.target.textEdit].x + lib.tableText[cena][event.target.textEdit].contentWidth+1
            lib.cursor.y = lib.tableText[cena][event.target.textEdit].y
            lib.cursorAparece({["cursorColor"] = cursorColor})
            
        elseif ( textEvent.phase == "ended" or textEvent.phase == "submitted" ) then
            
            
        elseif ( textEvent.phase == "editing" ) then
            
            
            if string.len(textField.text) <= maxChar then
                
                lib.tableText[cena][event.target.textEdit].text = lib[mask].apply(textField.text)
                lib.tableText[cena][event.target.textEdit] = lib.maxWidth(lib.tableText[cena][event.target.textEdit],maxWidth, maxHeight)
                
            else
                
                textField.text =  string.sub(textField.text,1,maxChar)  
                
            end
            
            lib.cursor.x = lib.tableText[cena][event.target.textEdit].x + lib.tableText[cena][event.target.textEdit].contentWidth+1
            lib.cursorPara()
            lib.cursorAparece({["cursorColor"] = cursorColor})
            
        end
        
    end 
    
    
    textField = native.newTextField( lib.centerX,-1000, event.target.contentWidth-100, event.target.height)
    textField.text = lib[mask].getRealText(lib.tableText[cena][event.target.textEdit].text)
    textField.placeholder = lib.tableDefaultText[cena][event.target.textEdit].text
    textField.align = align
    textField.hasBackground = false
    textField.inputType = inputType
    textField.isSecure = isSecure
    textField.isFontSizeScaled = true  -- make the field use the same font units as the text object
    textField.size = lib.tableText[cena][event.target.textEdit].size + 10
    textField:setTextColor( lib[textColor][1], lib[textColor][2], lib[textColor][3] )
    textField:resizeHeightToFitFont()
    textField:addEventListener( "userInput", textos )
    
    textField:setSelection( 10000,10000 )
    
    
    deleteRect = display.newRect( lib.leftX, lib.topY, lib.distanceX, lib.distanceY)
    deleteRect:setFillColor(1,0,0)
    deleteRect.alpha = 0.01
    deleteRect.anchorX = 0
    deleteRect.anchorY = 0
    deleteRect:addEventListener("touch",deleteTextField)
    
    
    lib.cursor = display.newRect(0,0,6,60 )
    lib.cursor.x = -150
    lib.cursor.y = -150
    lib.cursor:setFillColor(lib[cursorColor][1],lib[cursorColor][2],lib[cursorColor][3])
    lib.scrollView[cena]:insert(lib.cursor)
    
    
    
    
    local options = {
        y = -event.target.y+scrollY,
        time = 400,
        onComplete = focusTextField,
    }
    lib.scrollView[cena]:scrollToPosition( options ) 
    
    
    
end

function lib.maxWidth(obj,maxWidth, maxHeight)
    print("tamanho",obj.contentHeight)
    if obj.contentWidth > maxWidth then
        
        obj:scale(maxWidth/obj.contentWidth,maxWidth/obj.contentWidth  ) 
        
    else
        
        local scaleWidth = maxWidth/obj.contentWidth
        local scaleHeight = maxHeight/obj.contentHeight
        
        if scaleWidth > scaleHeight then
            obj:scale(scaleHeight,scaleHeight)
        else
            obj:scale(scaleWidth,scaleWidth)
        end
        
        
    end
    
    return obj    
    
end

function lib.maxHeight(obj,maxWidth, maxHeight)
    if obj.contentHeight > maxHeight then
        
        obj:scale(maxHeight/obj.contentHeight,maxHeight/obj.contentHeight  ) 
        
    else
        
        local scaleWidth = maxWidth/obj.contentWidth
        local scaleHeight = maxHeight/obj.contentHeight
        
        if scaleHeight > scaleWidth then
            obj:scale(scaleWidth,scaleWidth)
        else
            obj:scale(scaleHeight,scaleHeight)
        end
        
        
    end
    
    return obj    
    
end

function lib.newMask(mask)
    local obj = {}
    obj.MASKTEXT = mask 
    obj.REALTEXT = ""
    obj.MASKEDTEXT = mask
    
    obj.REALTEXTCHARS = {}
    obj.MASKCHARS = {}
    obj.MASKEDTEXTCHARS = {}
    obj.VALIDSPACESIDS = {}
    obj.MASKUNIQUESPECIALCHARS = {}
    
    function obj.separateChars(s)
        local t = {}
        for i=1,string.len( s ) do
            t[#t+1] = string.sub(s,i,i )
        end
        return t
    end
    
    function obj.enumerateValidChars()
        for i=1,#obj.MASKCHARS do
            if (obj.MASKCHARS[i] == "_") then
                obj.VALIDSPACESIDS[#obj.VALIDSPACESIDS + 1] = i
            end
        end
    end
    
    function obj.concatChars(t)
        local text = ""
        for i=1,#t do
            text = text..t[i]
        end
        return text
    end
    
    function obj.contains(t,s)
        for i=1,#t do
            if (t[i] == s) then
                return true	
            end
        end
        return false	
    end
    
    function obj.getUniqueMaskChars()
        for i=1,#obj.MASKCHARS do
            local char = obj.MASKCHARS[i]
            if (obj.contains(obj.MASKUNIQUESPECIALCHARS,char)) then
            else
                obj.MASKUNIQUESPECIALCHARS[#obj.MASKUNIQUESPECIALCHARS+1] = char 
                
            end
        end
    end
    
    function obj.removeMaskFromString(s)
        local cleanChars = {}
        local chars = obj.separateChars(s)
        for i=1,#chars do
            if (obj.contains(obj.MASKUNIQUESPECIALCHARS,chars[i])) then
            else 	
                cleanChars[#cleanChars+1] = chars[i]
            end
        end
        return obj.concatChars(cleanChars)
    end
    
    function obj.apply(s,tf)
        obj.MASKEDTEXTCHARS = obj.separateChars(obj.MASKTEXT)
        obj.REALTEXT = obj.removeMaskFromString(s)
        obj.REALTEXTCHARS = obj.separateChars(obj.REALTEXT)
        local aux = 0
        
        for i=1,#obj.REALTEXTCHARS do
            if (obj.MASKEDTEXTCHARS[i] ~= nil and obj.VALIDSPACESIDS[i] ~= nil) then
                obj.MASKEDTEXTCHARS[obj.VALIDSPACESIDS[i]] = string.sub(obj.REALTEXT,i,i )
                aux = aux + 1
            end	
        end
        
        obj.MASKEDTEXT =  obj.concatChars(obj.MASKEDTEXTCHARS)
        return obj.MASKEDTEXT
        
    end
    
    function obj.getRealText()
        return obj.REALTEXT
    end
    
    function obj.getMaskedText()
        return obj.MASKEDTEXT
    end
    
    function obj.getMaskText()
        return obj.MASKTEXT
    end
    
    function obj.setMask(s)
        obj.MASKTEXT = s
        obj.MASKEDTEXTCHARS = obj.separateChars(obj.MASKTEXT)
        obj.MASKCHARS = obj.separateChars(obj.MASKTEXT)
        obj.getUniqueMaskChars()
        
    end
    
    obj.MASKEDTEXTCHARS = obj.separateChars(obj.MASKTEXT)
    obj.MASKCHARS = obj.separateChars(obj.MASKTEXT)
    obj.getUniqueMaskChars()
    obj.enumerateValidChars()
    
    return obj
end
lib.noMask = {}
function  lib.noMask.apply (stg)
    return stg
end
function  lib.noMask.getRealText (stg)
    return stg
end

lib.cpfMask =  lib.newMask("___.___.___ - __")
lib.vipCodeMask = lib.newMask("_____ - _____")
lib.dataMask = lib.newMask("__ / __ / ____")
lib.phoneMask = lib.newMask("( __ ) ____ - _____")
lib.numberCard = lib.newMask("____ - ____ - ____ - ____")
lib.validadeMask = lib.newMask("__ / __")
lib.cepMask = lib.newMask("__ . ___ - ___")
lib.retrieveCardMask =  lib.newMask("_____ - _____")
lib.validadeMask =  lib.newMask("__ / __")

return lib

