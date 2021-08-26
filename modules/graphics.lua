animation = require "./modules/animation"
local graphics = {}

function graphics.love()
    local alpha = math.sin(math.rad(loveScreenTimer * 36))
    lg.setColor(1, 1, 1, alpha)
    lg.draw(loveCanvas, WINDOW.WIDTH / 2 - loveCanvas:getWidth() / 2, WINDOW.HEIGHT / 2 - loveCanvas:getHeight() / 2)
    lg.setColor(1, 1, 1, 1)
end

function graphics.load()

end

function graphics.background()

    if not tableContains(SCREEN_STATE, "menu") and not tableContains(SCREEN_STATE, "loadFile") then return end

    local scale = 0.5

    lg.push()
    lg.scale(scale, scale)
    
    local bgW, bgH = bg:getWidth(), bg:getHeight()
    
    for y = 0, WINDOW.HEIGHT * (1 / scale) + bgH, bgH do
        for x = 0, WINDOW.WIDTH * (1 / scale) + bgW, bgW do
            lg.draw(bg, x, y)
        end
    end

    lg.pop()
end

function graphics.menu()
    for i, button in ipairs(menuButtons.buttons) do
        local verticesScaled = {}

        local animationMove = 0
        if animation.isRunning then
            if animation.id == 1 then
                animationMove = WINDOW.HEIGHT * animation.timer / animation.timeLimit
                print(max, animationMove)
            end
        end

        for i, vertex in ipairs(button.vertices) do
            if i % 2 == 1 then
                table.insert(verticesScaled, vertex * WINDOW.HORIZONTAL_SCALE)
            else
                table.insert(verticesScaled, vertex * WINDOW.VERTICAL_SCALE)
            end
        end

        verticesScaled = applyAnimation(verticesScaled, animationMove)

        local collides = vector.collision(verticesScaled, {x = love.mouse.getX( ), y = love.mouse.getY( )})

        if love.mouse.isDown( 1 ) and collides and not animation.isRunning then
            button.func()
        end

        if collides then
            lg.setColor(menuButtons.borderColor)
        else
            lg.setColor(menuButtons.color)
        end

        lg.polygon("fill", verticesScaled)
        lg.setColor(menuButtons.borderColor)
        lg.setLineWidth(3)
        lg.polygon("line", verticesScaled)

        local text = lg.newText(fonts.Itim[menuButtons.fontSize], button.text)

        local origo = vector.origo(verticesScaled)
        local _, _, iconWidth, iconHeight = button.icon:getViewport( )
        local w, h = vector.getAvgDimensions(verticesScaled)
        h = h - text:getHeight()

        local smaller = 40
        w, h = w - smaller, h - smaller

        local scaleWidth, scaleHeight = w / iconWidth, h / iconHeight
        local scale = scaleWidth < scaleHeight and scaleWidth or scaleHeight
        local scaleCap = 0.95
        if scale > scaleCap then scale = scaleCap end

        lg.setColor(61/255, 83/255, 97/255)
        lg.draw(text, math.floor(origo.x - text:getWidth() / 2), math.floor(origo.y - (iconHeight * scale + text:getHeight() + 10) / 2))
        
        local fontSizeCap = .5
        if text:getWidth() > w or text:getHeight() > h * fontSizeCap then
            menuButtons.fontSize = menuButtons.fontSize - 5
            if menuButtons.fontSize < 15 then menuButtons.fontSize = 15 end
        end

        lg.setColor(1, 1, 1, 1)
        lg.draw(menuButtons.icons, button.icon, origo.x - iconWidth * scale / 2, origo.y - (iconHeight * scale + text:getHeight() + 10) / 2 + text:getHeight() + 10, 0, scale, scale)
    end
end

function graphics.loadFile()
    --lg.ellipse(loadTitle, 0, 0, 0, WINDOW.WIDTH / loadTitle:getWidth(), WINDOW.WIDTH / loadTitle:getWidth())
    local scale = WINDOW.WIDTH / loadTitle:getWidth()
    lg.draw(loadCanvas, 0, loadTitle:getHeight() * scale / -2, 0, scale, scale)
end

function applyAnimation(t, anim)
    for i, v in ipairs(t) do
        if i % 2 == 0 then
            t[i] = v + anim
        end
    end
    return t
end

return graphics