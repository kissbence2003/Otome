-- Lib for vector operations as needed --

local vector = {}

function vector.collision(vertices, mousePos) --http://www.jeffreythompson.org/collision-detection/poly-point.php
    vertices = verticesConverter(vertices)

    collision = false

    -- go through each of the vertices, plus
    -- the next vertex in the list
    next = 1
    for current = 1, #vertices, 1 do 

        -- get next vertex in list
        -- if we've hit the end, wrap around to 0
        next = current + 1
        if (next > #vertices) then next = 1 end

        -- get the PVectors at our current position
        -- this makes our if statement a little cleaner
        vc = vertices[current]    -- c for "current"
        vn = vertices[next]       -- n for "next"

        -- compare position, flip 'collision' variable
        -- back and forth
        if (
            (
                (
                    vc.y >= mousePos.y and vn.y < mousePos.y
                ) or (
                    vc.y < mousePos.y and vn.y >= mousePos.y
                )
            ) and (
                mousePos.x < 
                (
                    vn.x-vc.x
                )*(
                    mousePos.y-vc.y
                ) / (
                    vn.y-vc.y
                )+vc.x
            )
        ) then
            collision = not collision
        end
    end
    return collision;
end

function verticesConverter(vertices)
    local t = {}
    for i = 1, #vertices / 2, 1 do
        table.insert(t, {x = vertices[i * 2 - 1], y = vertices[i * 2]})
    end
    return t
end

function vector.origo(vertices)
    vertices = verticesConverter(vertices)

    return {
        x = (vertices[1].x + vertices[2].x + vertices[3].x + vertices[4].x) / 4,
        y = (vertices[1].y + vertices[2].y + vertices[3].y + vertices[4].y) / 4
    }
end

function vector.getAvgDimensions(vertices)
    vertices = verticesConverter(vertices)

    local upperWidth = math.abs(vertices[1].x - vertices[2].x)
    local lowerWidth = math.abs(vertices[3].x - vertices[4].x)
    local avgWidth = (upperWidth + lowerWidth) / 2

    local rightHeight = math.abs(vertices[1].y - vertices[4].y)
    local leftHeight = math.abs(vertices[2].y - vertices[3].y)
    local avgHeight = (rightHeight + leftHeight) / 2

    return avgWidth, avgHeight
end

return vector