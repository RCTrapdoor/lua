-- Author: Trapdoor
-- GitHub: https://github.com/RCTrapdoor
-- Workshop: https://steamcommunity.com/id/rctrapdoor/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
simulator:setScreen(1, "9x5")
require("LifeBoatAPI")
tau = 2 * math.pi
pi = tau / 2

screen = LifeBoatAPI.LBVec:new(0, 0)

touchX = LifeBoatAPI.LBVec:new(0, 3)

touchY = LifeBoatAPI.LBVec:new(4, 0)

print(touchX:lbvec_distance(touchY))

function drawCircle(x, y, segments, innerRadius, outerRadius, phase)
    phase = phase or 0
    for i = 0, segments do
        local x1,x2,x3,x4
        local y1,y2,y3,y4
        local angle = i * 2 * math.pi / segments + phase
        x1 = x + math.cos(angle) * innerRadius
        y1 = y + math.sin(angle) * innerRadius
        x2 = x + math.cos(angle) * outerRadius
        y2 = y + math.sin(angle) * outerRadius
        x3 = x + math.cos(angle + 2 * math.pi / segments) * innerRadius
        y3 = y + math.sin(angle + 2 * math.pi / segments) * innerRadius
        x4 = x + math.cos(angle + 2 * math.pi / segments) * outerRadius
        y4 = y + math.sin(angle + 2 * math.pi / segments) * outerRadius
        screen.drawTriangleF(x1, y1, x2, y2, x3, y3)
        screen.drawTriangleF(x2, y2, x3, y3, x4, y4)
    end
end

-- function drawGear(x, y, teeth, innerRadius, outerRadius, phase)
--     phase = phase or 0
--     for i = 1, teeth, 2 do
--         local x1, x2, x3, x4
--         local y1, y2, y3, y4
--         local angle = i * 2 * math.pi / teeth + phase
--         x1 = x + math.cos(angle) * innerRadius
--         y1 = y + math.sin(angle) * innerRadius
--         x2 = x + math.cos(angle) * outerRadius
--         y2 = y + math.sin(angle) * outerRadius
--         x3 = x + math.cos(angle + 2 * math.pi / teeth) * innerRadius
--         y3 = y + math.sin(angle + 2 * math.pi / teeth) * innerRadius
--         x4 = x + math.cos(angle + 2 * math.pi / teeth) * outerRadius
--         y4 = y + math.sin(angle + 2 * math.pi / teeth) * outerRadius
--         screen.drawTriangleF(x1, y1, x2, y2, x3, y3)
--         screen.drawTriangleF(x2, y2, x3, y3, x4, y4)
--     end
-- end

function drawGear(x, y, teeth, innerRadius, outerRadius, phase)
    local angle = (teeth * 2) / tau
    square = {
        {x = x + math.cos(angle) * outerRadius, y = y + math.sin(angle) * outerRadius},
        {x = x + math.cos(angle + 2 * math.pi / teeth) * outerRadius, y = y + math.sin(angle + 2 * math.pi / teeth) * outerRadius},
    }
    square[3] = {x = square[1].x - (outerRadius - innerRadius), y = square[1].y}
    square[4] = {x = square[2].x, y = square[2].y - (outerRadius - innerRadius)}
    square = {
        {x = 1, y = 1},
        {x = 1, y = -1},
        {x = -1, y = -1},
        {x = -1, y = 1},
    }
    -- for i = 1, teeth * 2, 2 do
    --     angle = i * 2 * math.pi / teeth + phase
    --     local x1 = x + square[1].x * math.cos(angle) - square[1].y * math.sin(angle)
    --     local y1 = y + square[1].x * math.sin(angle) + square[1].y * math.cos(angle)
    --     local x2 = x + square[2].x * math.cos(angle) - square[2].y * math.sin(angle)
    --     local y2 = y + square[2].x * math.sin(angle) + square[2].y * math.cos(angle)
    --     local x3 = x + square[1].x * math.cos(angle + 2 * math.pi / teeth) - square[1].y * math.sin(angle + 2 * math.pi / teeth)
    --     local y3 = y + square[1].x * math.sin(angle + 2 * math.pi / teeth) + square[1].y * math.cos(angle + 2 * math.pi / teeth)
    screen.drawTriangle(x + 10*square[1].x, x + 10*square[1].y, x + 10*square[2].x, x + 10*square[2].y, x + 10*square[3].x, x + 10*square[3].y)
    screen.drawTriangle(x + 10*square[2].x, x + 10*square[2].y, x + 10*square[3].x, x + 10*square[3].y, x + 10*square[4].x, x + 10*square[4].y)
end

ticks = 0

function onTick()
    ticks = ticks + 1
end

function onDraw()
    drawCircle(50, 50, 5, 3, 5, ticks / 20)
    drawGear(50, 50, 12, 4, 6, ticks / 20)

    drawCircle(100, 50, 16, 15, 18, ticks / 20)
    drawGear(100, 50, 12, 17, 24, ticks / 20)
end