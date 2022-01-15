--object = require "./modules/classic"
json = require "./modules/json"
--require "./modules/textbox"
vector = require "./modules/vector"
graphics = require "./modules/graphics"
animation = require "./modules/animation"
scene, convertToMoreDigits = require "./modules/scene"

lg = love.graphics

SCREEN_STATE = {}
WINDOW = {
    EXPECTED_WIDTH = 1920,
    EXPECTED_HEIGHT = 1080,
    VERTICAL_SCALE = 1,
    HORIZONTAL_SCALE = 1
}

globals = {}

characters = {}
shaders = {
    pink = lg.newShader([[

        vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
        
            vec4 pixel = Texel(image, uvs);
            
            if (pixel.x == 0.0 && pixel.y == 0.0 && pixel.z == 0.0) return vec4(0.0, 0.0, 0.0, 0.0);
        
            return vec4(255.0/255.0, 192.0/255.0, 203.0/255.0, 1.0);
        }
    ]]),
    blue = lg.newShader([[
        vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
        
            vec4 pixel = Texel(image, uvs);
            
            if (pixel.x == 0.0 && pixel.y == 0.0 && pixel.z == 0.0) return vec4(0.0, 0.0, 0.0, 0.0);
        
            return vec4(173.0/255.0, 216.0/255.0, 230.0/255.0, 1.0);
        }
    ]])
}

local _ = scene.new(1)

function love.load()
    if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
        love.window.setMode(800, 600, {resizable=false})
    end

    loading(lovescreen, "love")
end

function love.update(dt)
    if tableContains(SCREEN_STATE, "love") then
        globals.loveScreenTimer = globals.loveScreenTimer + dt
        if globals.loveScreenTimer >= 5 then
            loading(menu, "menu")
        end
    end
    animation.update(dt)
end

function love.draw()

    graphics.background()

    for i, v in pairs(SCREEN_STATE) do
        graphics[v]()
    end

    --[[

    if SCREEN_STATE == "love" then
        graphics.love()
    elseif SCREEN_STATE == "load" then
        graphics.load()
    elseif SCREEN_STATE == "menu" then
        graphics.menu()
        --lg.draw(button.canvas, math.floor(origo.x - canvasWidth * scale / 2), math.floor(origo.y - canvasHeight * scale / 2), 0, scale, scale)
    elseif SCREEN_STATE == "loadfile" then
        graphics.loadfile()
    end

    ]]
end

function press(x, y)
    if tableContains(SCREEN_STATE, "love") then
        loading(menu, "menu")
    end
    
end

function love.keypressed( key, scancode, isrepeat )
    if key == "space" then
        press(-100, -100)
    end
    if (love.system.getOS() == "Android" or love.system.getOS() == "iOS") and key == "escape" then
        if tableContains(SCREEN_STATE, "loadFile") then
            SCREEN_STATE = {"menu"}
        end
    end
end

--mobiles: escape -> back, home -> home

function love.mousepressed( x, y, button, istouch, presses )
    press(x, y)
end

function love.touchpressed( id, x, y, dx, dy, pressure )
    press(x, y)
end

function love.resize( w, h )
    WINDOW.WIDTH, WINDOW.HEIGHT = w, h
    WINDOW.HORIZONTAL_SCALE, WINDOW.VERTICAL_SCALE = w / WINDOW.EXPECTED_WIDTH, h / WINDOW.EXPECTED_HEIGHT

    if tableContains(SCREEN_STATE, "menu") then globals.menuButtons.fontSize = 40 end
end

function loading(func, after, add)
    if not add then
        SCREEN_STATE = {}
        table.insert(SCREEN_STATE, "load")
    end
    func()
    if not add then
        SCREEN_STATE = {}
    end
    table.insert(SCREEN_STATE, after)
end

function lovescreen()
    globals.fonts = { Itim = {} }

    for i = 5, 100, 5 do
        globals.fonts.Itim[i] = lg.newFont("/res/fonts/Itim-Regular.ttf", i)
    end

    love.window.maximize()
    _, _, WINDOW.WIDTH, WINDOW.HEIGHT = love.window.getSafeArea( )
    WINDOW.HORIZONTAL_SCALE, WINDOW.VERTICAL_SCALE = WINDOW.WIDTH / WINDOW.EXPECTED_WIDTH, WINDOW.HEIGHT / WINDOW.EXPECTED_HEIGHT

    local img = lg.newImage("/res/images/love.png")
    local text = lg.newText(globals.fonts.Itim[40], "Made with LÖVE")

    globals.loveCanvas = lg.newCanvas( text:getWidth() > img:getWidth() and text:getWidth() or img:getWidth(), img:getHeight() + text:getHeight() )
    
    
    lg.setCanvas(globals.loveCanvas)
        lg.draw(img, (globals.loveCanvas:getWidth() / 2) - (img:getWidth() / 2), 0)
        lg.draw(text, (globals.loveCanvas:getWidth() / 2) - (text:getWidth() / 2), img:getHeight())
    lg.setCanvas()

    globals.loveScreenTimer = 0
end

function menu() 
    globals.bg = lg.newImage("/res/images/menubgminified.jpg")

    globals.colours = {
        {
            0xF5 / 255,
            0XF0 / 255,
            0xED / 255,
            1
        },
        {
            0xD4 / 255,
            0XC6 / 255,
            0xDD / 255,
            1
        },
        {
            0xD6 / 255,
            0XB7 / 255,
            0xB5 / 255,
            1
        },
        {
            0x3D / 255,
            0X53 / 255,
            0x61 / 255,
            1
        },
    }

    globals.menuButtons = {
        color = {245/255, 240/255, 237/255, 1},
        borderColor = {212/255, 198/255, 189/255, 1},
        icons = lg.newImage("/res/images/optbuttonpics.png"),
        fontSize = 40,
        buttons = {}
    }
    table.insert(globals.menuButtons.buttons, newMenuButton(
        {265, 436, 621, 436, 621, 734, 265, 695},
        "New game",
        lg.newQuad(0, 0, 169, 165, globals.menuButtons.icons:getDimensions()),
        function()
            lg.captureScreenshot("/saves/screen.png")
        end
    ))
    table.insert(globals.menuButtons.buttons, newMenuButton(
        {649, 436, 1051, 436, 992, 762, 649, 789},
        "Continue",
        lg.newQuad(170, 1, 110, 127, globals.menuButtons.icons:getDimensions()),
        function() end    
    ))
    table.insert(globals.menuButtons.buttons, newMenuButton(
        {1085, 436, 1389, 436, 1341, 734, 1031, 758.5},
        "Load",
        lg.newQuad(281, 0, 110, 142, globals.menuButtons.icons:getDimensions()),
        function()
            loading(loadFile, "loadFile", true)
        end    
    ))
    table.insert(globals.menuButtons.buttons, newMenuButton(
        {1419, 436, 1655, 436, 1655, 712, 1376, 734},
        "Quit",
        lg.newQuad(392, 0, 144, 147, globals.menuButtons.icons:getDimensions()),
        function() 
            love.event.quit()
        end    
    ))
    table.insert(globals.menuButtons.buttons, newMenuButton(
        {265, 723, 619, 763, 619, 1051, 265, 1051},
        "Settings",
        lg.newQuad(537, 0, 136, 138, globals.menuButtons.icons:getDimensions()),
        function() end    
    ))
    table.insert(globals.menuButtons.buttons, newMenuButton(
        {649, 817, 1106, 780, 1175, 1051, 649, 1051},
        "Gallery",
        lg.newQuad(674, 0, 121, 121, globals.menuButtons.icons:getDimensions()),
        function() end    
    ))
    table.insert(globals.menuButtons.buttons, newMenuButton(
        {1142, 780, 1655, 733, 1655, 1051, 1210, 1051},
        "Branches",
        lg.newQuad(796, 0, 277, 121, globals.menuButtons.icons:getDimensions()),
        function() end    
    ))

    --[[check if save files exist, and create them if they don't
    local saveDir = love.filesystem.getSaveDirectory()
    local amountOfSaveFiles = 30

    local info = love.filesystem.getInfo(love.filesystem.getSaveDirectory() .. "/saves/")
    if not info then
        local success = love.filesystem.createDirectory( "saves" )
        assert(success, "unable to create save directory :c")
    end

    for i = 1, amountOfSaveFiles, 1 do
        local filename = scene.convertToMoreDigits(i, #(amountOfSaveFiles .. "")) .. ".sav"
        local info = love.filesystem.getInfo( love.filesystem.getSaveDirectory() .. "/saves/" .. filename )
        if not info then
            love.filesystem.write("/saves/" .. filename, "")
        end
    end
    --]]
end

function newMenuButton(v, t, i, f)
    return {vertices = v, text = t, icon = i, func = f}
end

function loadFile()
    globals.loadTitle = lg.newImage("/res/images/ovalis.png")
    globals.arrow = lg.newImage("/res/images/arrow.png")
    globals.loadCanvas = lg.newCanvas(globals.loadTitle:getWidth(), globals.loadTitle:getHeight())
    lg.setCanvas(globals.loadCanvas)
        lg.draw(globals.loadTitle)
        lg.setColor(61/255, 83/255, 97/255)
        lg.printf( "Load", globals.fonts.Itim[100], 0, globals.loadTitle:getHeight() * 3 / 5, globals.loadTitle:getWidth(), "center")
        lg.setColor(1, 1, 1, 1)
    lg.setCanvas()

    animation.menu_loadFile()
end

function tableContains(table, item)
    for i, v in ipairs(table) do
        if v == item then return true end
    end
    return false
end

function clearGlobals()
    local exceptions = {"fonts", "bg", "colours"}
    for k, v in pairs(globals) do
        local bool = false
        for _, exception in ipairs(exceptions) do
            if not bool then
                bool = k == exception
            end
        end
        if not bool then
            globals[k] = nil
        end
    end
end

