-- Author: Trapdoor
-- GitHub: Trapdoor
-- Workshop: Trapdoor

--Trapdoor--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("_build._simulator_config") -- LifeBoatAPI allows you to use lua's "require" keyword. see the /build/_simulator_config.lua file for how to configure the simulator
require("LifeBoatAPI") -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library

require("_build._simulator_config")

ticks = 0
history = {}
history2 = {}

width,height = 288,160

tau = math.pi * 2
pi = tau / 2
history = {}
for i = 1, 288 do
    --value = 0.5 + (math.cos((i/(60/5))*math.pi*2) + math.cos((i/freq_)*math.pi*2)) / 2
    value =0.5 + math.cos((i/120)*pi*2)
    --value = 0.5 + math.cos((i/15)*math.pi*2) / 2
    table.insert(history, value)
end

max_frequency = 2
-- for k = 1, #history do
--     print(string.format('%.0f: %.2f, %.2f', k, history[k], history2[k]))
-- end

function onTick()
    ticks = ticks + 1
    history2 = {}
    --[[for freq = 1, 288 do
        x_sum = 0
        for k,val in ipairs(history) do
            theta = pi * (k / width) * seconds
            x_sum = x_sum + val * math.cos(theta)
        end
        table.insert(history2, x_sum / width)
    end--]]

    --value = math.cos(ticks/6)+math.cos(ticks/12)


    --freq = 4

    --table.insert(history, value)

    if #history > 288 then
        table.remove(history, 1)
    end

    mi = -2
    ma = 2
    span = ma-mi
    factor = height/span


    -- for n, d in ipairs(history) do
    --     mi = math.min(mi or d, d)
    --     ma = math.max(ma or d, d)
    --     span = ma-mi
    -- end

end

cx, cy = width/2, height/2

function onDraw()
    --w,h = screen.getWidth(), screen.getHeight()
    screen.drawText(2, 2, #history)
    screen.drawText(2, 10, #history2)
    for i = 0, width, 288/max_frequency do
        screen.setColor(15, 5, 0, 150)
        screen.drawLine(i, 0, i, height)
        screen.setColor(35, 20, 0)
        screen.drawTextBox(i-30, 10, 15, 10, string.format('%.0f Hz', i / (288 / max_frequency)), 1, 0)
    end

    --for freq = 1, 288 do
        --x_sum = 0
        for k,val in ipairs(history) do
            theta = k * pi * ((ticks/240) * tau) * max_frequency
            x = val * math.cos(theta) * 20
            y = val * math.sin(theta) * 20
            screen.drawCircle(cx + x, cy + y, 1)
        end
    --end

    --[[screen.setColor(160, 160, 160)
    for n = 1, #history2-1 do
        screen.drawLine(n, height-factor*(history2[n]-mi), n+1, height-factor*(history2[n+1]-mi))
    end

    screen.setColor(60, 60, 60, 60)
    for n = 1, #history-1 do
        screen.drawLine(n, height-factor*(history[n]-mi), n+1, height-factor*(history[n+1]-mi))
    end

    screen.setColor(160, 160, 160, 150)
    for n = 1, #history-1 do
        --screen.drawLine(n, cy+height-factor*(history[n]-mi), n+1, cy+height-factor*(history[n+1]-mi))
    end--]]

    --for i = 0, width, math.max(1, 60/freq) do
    --    screen.drawLine(i, 0, i, height)
    --    screen.drawText(i+2, 10+(i%4)*12, ("%4.2f"):format(history[i+1]))
    --end

    -- screen.drawCircle(width/2, height/2, height/2)

    -- for k,val in ipairs(history) do
    --     theta = k * (freq/60) * tau
    --     x, y = val * math.cos(theta)*height/2, val * math.sin(theta)*height/2
    --     x_sum = x_sum + x
    --     y_sum = y_sum + y

    --     screen.drawLine(cx + x, cy + y, cx+x+1, cy+y)
    -- end

    -- screen.setColor(120, 70, 0)
    -- screen.drawCircleF(cx + x_sum / #history , cy + y_sum / #history , 2)
    screen.setColor(255, 0, 0)
    -- screen.drawTextBox(0, 0, width, height, ("%4f"):format(freq_), 0, -1)
end