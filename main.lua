require "CiderDebugger";display.setStatusBar( display.HiddenStatusBar )

local lib = require("main_library")

-- push one signal
local function DidReceiveRemoteNotification(message, additionalData, isActive)
        lib.criarPopUp(message)
end
lib.OneSignal.Init("b7c91326-4b6d-11e5-a3d2-2bd3e27d53a6", "1067952099671", DidReceiveRemoteNotification)

--google analytcis
lib.ga.init({
    isLive = false, 
    testTrackingID = "gaNumber",  -- <-- Replace with your tracking code. If code is wrong it fails silently.
    debug = true,
})


local doc_path = system.pathForFile( "", system.TemporaryDirectory )
for file in lib.lfs.dir(doc_path) do
   --file is the current file or directory name
   print( "Found file: " .. file )
  os.remove( system.pathForFile( file, system.TemporaryDirectory  ) )
end


---- Called when a key event has been received
local platformName = system.getInfo( "platformName" )
local function onKeyEvent( event )
    -- Print which key was pressed down/up
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )
    
    -- If the "back" key was pressed on Android or Windows Phone, prevent it from backing out of the app
    if ( event.keyName == "back" ) then
        if ( platformName == "Android" ) or ( platformName == "WinPhone" ) then
            ANDROID_RETURN_ACTION()
            
            return true
        end
    end

    -- IMPORTANT! Return false to indicate that this app is NOT overriding the received key
    -- This lets the operating system execute its default handling of the key
    return false
end
-- Add the key event listener
Runtime:addEventListener( "key", onKeyEvent )




local logado = lib.loadsave.loadTable("logado.json") or 0
--logado = 1

local function checkLogado()
    if logado == 1 then
        lib.dadosUsuario = lib.loadsave.loadTable("dadosUsuario.json")
        lib.composer.gotoScene("main_menu")
    else
        lib.composer.gotoScene("main_login")
    end
end


checkLogado()






--[[

local lib = require("main_library")
local scene = lib.composer.newScene()

-- "scene:create()"
function scene:create( event )
  
    local sceneGroup = self.view

end

scene:addEventListener( "create", scene )

return scene

]]