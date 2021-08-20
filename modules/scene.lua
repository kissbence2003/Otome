--json = require "json.lua"

local scene = {}

scene.counter = 1
scene.convertToMoreDigits = function(n, digits)
    local l = #(n .. "")
    local string = ""
    for i = 1, digits - l, 1 do
        string = string .. "0"
    end
    return string .. n
end

function scene.new(sceneNumber)
    sceneNumber = scene.convertToMoreDigits(sceneNumber, 3)

    local contents, error = love.filesystem.read("/res/scenes/" .. sceneNumber .. ".json")
    assert(contents, error)

    scene.content = json.decode(contents)
    assert(scene.content, "something went wrong")

    scene.counter = 1
end

return scene