local animation = {}

animation.isRunning = false
animation.id = 0
animation.timer = 0
animation.timeLimit = 0

function animation.init(...)
    local t = {...}
    animation.id = t[1]
    animation.isRunning = t[2]
    animation.timer = 0
    animation.timeLimit = t[3]
end

function animation.finish()
    local _ = SCREEN_STATE[2]
    animation.isRunning = false
    animation.timer = 0
    animation.timeLimit = 0
    SCREEN_STATE = {_}
end

function animation.update(dt, animId)
    if animation.isRunning then
        animation.timer = animation.timer + dt
        if animation.timer >= animation.timeLimit then
            animation.finish()
        end
    end
end

function animation.menu_loadFile()
    animation.init(1, true, 0.2)
end

return animation