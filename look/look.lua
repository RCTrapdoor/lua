require("_build._simulator_config") -- default simulator config, CTRL+CLICK it or F12 to goto this file and edit it. Its in a separate file just for convenience.
require("LifeBoatAPI")              -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library

function drawTable(tab, depth)
    if i == 25 then
        screen.setColor(0, 0, 0)
        screen.drawRectF(144, 0, 144, 160)
    end
    depth = depth or 0
    screen.setColor(255, 255, 255)

    for k,v in pairs(tab) do
        if type(v) == "number" or type(v) == "boolean" then
            screen.drawText((i//25)*144+2+depth*6*2, i%25*6, k..": "..tostring(v))
            i = i + 1
        elseif type(v) == "table" and depth <= 1 then
            screen.drawText((i//25)*144+2+depth*6*2, i%25*6, "[" .. k .. "]")
            i = i + 1
            drawTable(v, depth + 1)
        end
    end
end

nums, bools = {}, {}

pi2 = math.pi*2

look_lim_x = {min = -0.072*pi2, max = 0.072*pi2}
look_lim_y = {min = -0.0455*pi2, max = 0.0351*pi2}
function onTick()
    w,h = 288, 160
    look = {x = input.getNumber(9)*pi2, y = input.getNumber(10)*pi2}
    trigger = input.getBool(31)
    control = input.getBool(32)

    -- x = w/2 + (look.x / look_lim_x.max) * w/2
    -- y = (1-((look.y - look_lim_y.min) / (look_lim_y.max - look_lim_y.min))) * h

    x = w/2 + 2.05/math.cos(look.y)*math.tan(look.x)*(w/2)
    y = h/2 - 1.9/math.cos(look.x)*math.tan(look.y + 0.035)*h

    trigger_look = not trigger and look or trigger_look
    trigger_x = w/2 + (trigger_look.x / look_lim_x.max) * w/2 - x 
    trigger_y = (1-((trigger_look.y - look_lim_y.min) / (look_lim_y.max - look_lim_y.min))) * h - y

    
end

function onDraw()
    if control then
        screen.setColor(255, 255, 255)
    else
        screen.setColor(100, 100, 100)
    end
    if trigger then
        screen.setColor(255, 0, 0)
    end

    screen.drawCircle(x, y, 2)
    screen.drawText(10, 10, ("%.4f %.4f"):format(look.x, look.y))
    screen.drawText(10, 20, ("%.4f %.4f"):format(x, y))

    if trigger then
        screen.drawRect(x, y, trigger_x, trigger_y)
    end
end