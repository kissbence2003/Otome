--object = require "./modules/classic"
json = require "./modules/json"
--require "./modules/textbox"
vector = require "./modules/vector"
graphics = require "./modules/graphics"
scene, convertToMoreDigits = require "./modules/scene"

lg = love.graphics

SCREEN_STATE = ""
WINDOW = {
    EXPECTED_WIDTH = 1920,
    EXPECTED_HEIGHT = 1080,
    VERTICAL_SCALE = 1,
    HORIZONTAL_SCALE = 1
}

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

expressionNumber = 2

function love.load()
    if love.system.getOS() == "Android" or love.system.getOS() == "iOS" then
        love.window.setMode(800, 600, {resizable=false})
    end

    loading(lovescreen, "love")
end

function love.update(dt)
    if SCREEN_STATE == "love" then
        loveScreenTimer = loveScreenTimer + dt
        if loveScreenTimer >= 5 then
            loading(menu, "menu")
        end
    end
end

function love.draw()
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
end

function press(x, y)
    if SCREEN_STATE == "love" then
        loading(menu, "menu")
    end
    if expressionNumber == 1 then expressionNumber = 2 else expressionNumber = 1 end
end

function love.keypressed( key, scancode, isrepeat )
    if key == "space" then
        press(-100, -100)
    end
end

function love.mousepressed( x, y, button, istouch, presses )
    press(x, y)
end

function love.touchpressed( id, x, y, dx, dy, pressure )
    press(x, y)
end

function love.resize( w, h )
    WINDOW.WIDTH, WINDOW.HEIGHT = w, h
    WINDOW.HORIZONTAL_SCALE, WINDOW.VERTICAL_SCALE = w / WINDOW.EXPECTED_WIDTH, h / WINDOW.EXPECTED_HEIGHT

    if SCREEN_STATE == "menu" then menuButtons.fontSize = 40 end
end

function loading(func, after)
    SCREEN_STATE = "load"
    func()
    SCREEN_STATE = after
end

function lovescreen()


    fonts = { Itim = {} }

    for i = 5, 60, 5 do
        fonts.Itim[i] = lg.newFont("/res/fonts/Itim-Regular.ttf", i)
    end

    love.window.maximize()
    _, _, WINDOW.WIDTH, WINDOW.HEIGHT = love.window.getSafeArea( )
    WINDOW.HORIZONTAL_SCALE, WINDOW.VERTICAL_SCALE = WINDOW.WIDTH / WINDOW.EXPECTED_WIDTH, WINDOW.HEIGHT / WINDOW.EXPECTED_HEIGHT

    local img = lg.newImage("/res/images/love.png")
    local text = lg.newText(fonts.Itim[40], "Made with LÖVE")

    loveCanvas = lg.newCanvas( text:getWidth() > img:getWidth() and text:getWidth() or img:getWidth(), img:getHeight() + text:getHeight() )
    
    
    lg.setCanvas(loveCanvas)
        lg.draw(img, (loveCanvas:getWidth() / 2) - (img:getWidth() / 2), 0)
        lg.draw(text, (loveCanvas:getWidth() / 2) - (text:getWidth() / 2), img:getHeight())
    lg.setCanvas()

    loveScreenTimer = 0
end

function menu() 
    bg = lg.newImage("/res/images/menubgminified.jpg")

    menuButtons = {
        color = {245/255, 240/255, 237/255, 1},
        borderColor = {212/255, 198/255, 189/255, 1},
        icons = lg.newImage("/res/images/optbuttonpics.png"),
        fontSize = 40,
        buttons = {}
    }
    table.insert(menuButtons.buttons, newMenuButton(
        {265, 436, 621, 436, 621, 734, 265, 695},
        "New game",
        lg.newQuad(0, 0, 136, 146, menuButtons.icons:getDimensions()),
        function() end
    ))
    table.insert(menuButtons.buttons, newMenuButton(
        {649, 436, 1051, 436, 992, 762, 649, 789},
        "Continue",
        lg.newQuad(138, 1, 110, 127, menuButtons.icons:getDimensions()),
        function() end    
    ))
    table.insert(menuButtons.buttons, newMenuButton(
        {1085, 436, 1389, 436, 1341, 734, 1031, 758.5},
        "Load",
        lg.newQuad(249, 0, 110, 142, menuButtons.icons:getDimensions()),
        function() end    
    ))
    table.insert(menuButtons.buttons, newMenuButton(
        {1419, 436, 1655, 436, 1655, 712, 1376, 734},
        "Quit",
        lg.newQuad(360, 0, 144, 147, menuButtons.icons:getDimensions()),
        function() 
            love.event.quit()
        end    
    ))
    table.insert(menuButtons.buttons, newMenuButton(
        {265, 723, 619, 763, 619, 1051, 265, 1051},
        "Settings",
        lg.newQuad(505, 0, 136, 138, menuButtons.icons:getDimensions()),
        function() end    
    ))
    table.insert(menuButtons.buttons, newMenuButton(
        {649, 817, 1106, 780, 1175, 1051, 649, 1051},
        "Gallery",
        lg.newQuad(642, 0, 121, 121, menuButtons.icons:getDimensions()),
        function() end    
    ))
    table.insert(menuButtons.buttons, newMenuButton(
        {1142, 780, 1655, 733, 1655, 1051, 1210, 1051},
        "Branches",
        lg.newQuad(764, 0, 277, 121, menuButtons.icons:getDimensions()),
        function() end    
    ))

    --check if save files exist, and create them if they don't
    saveDir = love.filesystem.getSaveDirectory()
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
end

function newMenuButton(v, t, i, f)
    return {vertices = v, text = t, icon = i, func = f}
end

--[[

lg.draw(textbox)
lg.setFont(font)
lg.setColor(1, 1, 1, 1)
lg.print("Retek Sanyi életem szerelme <3", 8, 60)
lg.print("Retek Sanyi életem szerelme <3", 12, 60)
lg.print("Retek Sanyi életem szerelme <3", 10, 58)
lg.print("Retek Sanyi életem szerelme <3", 10, 62)
lg.setColor(0, 0, 0, 1)
lg.print("Retek Sanyi életem szerelme <3", 10, 60)
lg.setColor(1, 1, 1, 1)

]]

--[[
    textbox = lg.newImage("/res/images/textbox.png")
    
    characters.example = {}
    local _ = lg.newImage("/res/images/examplechar.png")
    characters.example[1] = lg.newCanvas(_:getWidth(), _:getHeight())
    lg.setCanvas(characters.example[1])
        lg.clear()
        --lg.setColor(0, 0, 0)
        --lg.rectangle("fill", 0, 0, _:getWidth(), _:getHeight())
        --lg.setColor(1, 1, 1)
        lg.draw(_)
        lg.draw(lg.newImage("/res/images/exampleexpression1.png"), 611, 387)
    lg.setCanvas()
    characters.example[2] = lg.newCanvas(_:getWidth(), _:getHeight())
    lg.setCanvas(characters.example[2])
        lg.clear()
        lg.setColor(0, 0, 0)
        lg.rectangle("fill", 0, 0, _:getWidth(), _:getHeight())
        lg.setColor(1, 1, 1)
        lg.draw(_)
        lg.draw(lg.newImage("/res/images/exampleexpression2.png"), 612, 383)
    lg.setCanvas()
    ]]

    
        --[[
        lg.draw(bg)
        lg.setShader(shaders.blue)
        lg.draw(characters.example[expressionNumber], 0, 0, 0, WINDOW.HEIGHT / characters.example[expressionNumber]:getHeight(), WINDOW.HEIGHT / characters.example[expressionNumber]:getHeight())
        lg.setShader()
        --lg.clear()
        lg.print("It's unusual to see people here/nWhat's up?")
        ]]