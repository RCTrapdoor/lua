-- Author: <Authorname> (Please change this in user settings, Ctrl+Comma)
-- GitHub: <GithubLink>
-- Workshop: <WorkshopLink>
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


--[====[ HOTKEYS ]====]
-- Press F6 to simulate this file
-- Press F7 to build the project, copy the output from /_build/out/ into the game to use
-- Remember to set your Author name etc. in the settings: CTRL+COMMA


--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "3x3")
    simulator:setProperty("ExampleNumberProperty", 123)
        -- Runs every tick just before onTick; allows you to simulate the inputs changing
        ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
        ---@param ticks     number Number of ticks since simulator started
        function onLBSimulatorTick(simulator, ticks)
    
            -- touchscreen defaults
            local screenConnection = simulator:getTouchScreen(1)
            simulator:setInputBool(1, screenConnection.isTouched)
            simulator:setInputNumber(1, screenConnection.width)
            simulator:setInputNumber(2, screenConnection.height)
            simulator:setInputNumber(3, screenConnection.touchX)
            simulator:setInputNumber(4, screenConnection.touchY)
    
            -- NEW! button/slider options from the UI
            simulator:setInputBool(31, simulator:getIsClicked(1))       -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
            simulator:setInputNumber(31, simulator:getSlider(1))        -- set input 31 to the value of slider 1
    
            simulator:setInputBool(32, simulator:getIsToggled(2))       -- make button 2 a toggle, for input.getBool(32)
            simulator:setInputNumber(32, simulator:getSlider(2) * 50)   -- set input 32 to the value from slider 2 * 50
        end;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

function drawCurve(x, y, segments, radius, rads)
    for i = 0, segments-1 do
        local x2 = x - math.sin(rads * (i+0.5) / segments) * radius / segments
        local y2 = y - math.cos(rads * (i+0.5) / segments) * radius / segments
        screen.drawLine(x, y, x2, y2)
        x = x2
        y = y2
    end
    return x, y
end

function drawSegment(x, y, startAngle, rads, radius, segments)
    segments = segments or 8
    for i = 0, segments-1 do
        local x2, y2 = x + math.cos(startAngle + rads * i / segments) * radius, y - math.sin(startAngle + rads * i / segments) * radius
        local x3, y3 = x + math.cos(startAngle + rads * (i+1) / segments) * radius, y - math.sin(startAngle + rads * (i+1) / segments) * radius
        screen.drawTriangleF(x, y, x2, y2, x3, y3)
    end
end

function smoothstep(x)
    if x < 0 then return 0 end
    if x > 1 then return 1 end
    return x * x * (3 - 2 * x)
end

frames = {
    {
        duration = 60,
        run = function(mul)
            screen.setColor(255, 0, 0)
            screen.drawCircleF(w/2, h/2, 2)
            screen.drawLine(w/2, h/2, w/2+r*mul, h/2)
            screen.drawCircleF(w/2+r*mul, h/2, 2)
        end
    },
    {
        duration = 60,
        run = function(mul)
            screen.setColor(255, 0, 0)
            x, y = w/2+r, h/2
            -- x2, y2 = x + r*math.cos(2 * math.pi * mul), y - r*math.sin(2 * math.pi * mul)
    
            screen.setColor(0, 0, 200)
            -- for i = 1/32, mul, 1/32 do
                -- x3, y3 = x + r*math.cos(2 * math.pi * i), y - r*math.sin(2 * math.pi * i)
                -- x4, y4 = x + r*math.cos(2 * math.pi * (i-1/32)), y - r*math.sin(2 * math.pi * (i-1/32))
                x3, y3 = drawCurve(x, y, mul * 64, mul * r * math.pi * 2, 2 * math.pi * mul)
            --     screen.drawLine(x3, y3, x4, y4)
            -- end
            -- if x3 then
            --     screen.drawLine(x3, y3, x, y)
            -- end
    
            screen.setColor(255, 0, 0)
            screen.drawCircleF(x-r, y, 2)
            screen.drawCircleF(x3, y3, 2)
            screen.drawLine(x-r, y, x3, y3)
        end
    },
    {
        duration = 30,
        run = function(mul)
            x, y = w/2, h/2
            screen.setColor(255, 0, 0)
            screen.drawCircleF(x, y, 2)
            screen.drawCircleF(x+r, y, 2)
            screen.drawLine(x, y, x+r, y)
            screen.setColor(255, 0, 0, mul*255)
            screen.drawTextBox(x, y-7, r, 5, "r", 0, 0)
        end
    },
    {
        duration = 60,
        run = function(mul)
            x, y = w/2, h/2
            screen.setColor(255, 0, 0)
            screen.drawCircleF(x, y, 2)
            screen.drawCircleF(x+r, y, 2)
            screen.drawLine(x, y, x+r, y)
            screen.setColor(255, 0, 0, 255)
            screen.drawTextBox(x, y-7, r, 5, "r", 0, 0)
        end
    },
    {
        duration = 30,
        run = function(mul)
            x, y = w/2, h/2
            screen.setColor(255, 0, 0)
            screen.drawCircleF(x, y, 2)
            screen.drawCircleF(x+r, y, 2)
            screen.drawLine(x, y, x+r, y)
            screen.setColor(255, 0, 0, (1-mul)*255)
            screen.drawTextBox(x, y-7, r, 5, "r", 0, 0)
        end
    },
    {
        duration = 60,
        run = function(mul)
            screen.setColor(255, 0, 0)
            x, y = w/2+r, h/2
            x2, y2 = x - r*math.cos(-0.5 * math.pi * mul), y + r*math.sin(-0.5 * math.pi * mul)
            screen.drawCircleF(x, y, 2)
            screen.drawCircleF(x2, y2, 2)
            screen.drawLine(x, y, x2, y2)
        end
    },
    {
        duration = 60,
        run = function(mul)
            screen.setColor(255, 0, 0)
            lx, ly = w/2+r, h/2
            screen.drawCircleF(lx, ly, 2)
            x2, y2 = drawCurve(lx, ly, 64/(2*math.pi), r, mul)
            screen.drawCircleF(x2, y2, 2)
        end
    },
    {
        duration = 60,
        run = function(mul)
            lx, ly = w/2+r, h/2
            screen.setColor(50, 200, 50, math.min(255, mul * 255))
            drawSegment(w/2, h/2, 0, 1, 20)
            screen.setColor(10, 50, 10, math.min(255, mul * 255))
            screen.drawLine(w/2, h/2, lx, ly)
            screen.drawLine(w/2, h/2, x2, y2)
            drawCurve(w/2+20, h/2, 8, 20, 1)
        end
    },
    {
        duration = 30,
        run = function(mul)
            lx, ly = w/2+r, h/2
            screen.setColor(50, 200, 50)
            drawSegment(w/2, h/2, 0, 1, 20)
            screen.setColor(10, 50, 10)
            screen.drawLine(w/2, h/2, lx, ly)
            screen.drawLine(w/2, h/2, x2, y2)
            drawCurve(w/2+20, h/2, 8, 20, 1)
            screen.setColor(10, 50, 10, math.min(255, mul * 255))
            screen.drawTextBox(w/2-r, y+7, 2*r, 5, "1 rad", 0, 0)
        end
    },
    {
        duration = 60,
        run = function(mul)
            lx, ly = w/2+r, h/2
            screen.setColor(50, 200, 50)
            drawSegment(w/2, h/2, 0, 1, 20)
            screen.setColor(10, 50, 10)
            screen.drawLine(w/2, h/2, lx, ly)
            screen.drawLine(w/2, h/2, x2, y2)
            drawCurve(w/2+20, h/2, 8, 20, 1)
            screen.setColor(10, 50, 10)
            screen.drawTextBox(w/2-r, y+7, 2*r, 5, "1 rad", 0, 0)
        end
    },
    {
        duration = 30,
        run = function(mul)
            lx, ly = w/2+r, h/2
            screen.setColor(50, 200, 50)
            drawSegment(w/2, h/2, 0, 1, 20)
            screen.setColor(10, 50, 10)
            screen.drawLine(w/2, h/2, lx, ly)
            screen.drawLine(w/2, h/2, x2, y2)
            drawCurve(w/2+20, h/2, 8, 20, 1)
            screen.setColor(10, 50, 10, math.min(255, (1-mul) * 255))
            screen.drawTextBox(w/2-r, y+7, 2*r, 5, "1 rad", 0, 0)
        end
    },
}

frame = frames[1]

ticks = 0
framecounter = 1
timer = 0

function onTick()
    ticks = ticks + 1
    timer = timer + 1
    if timer > frame.duration and framecounter < #frames then
        timer = 0
        framecounter = framecounter + 1
        frame = frames[framecounter]
    end

    if input.getBool(1) then
        framecounter = 1
        frame = frames[framecounter]
        timer = 0
        ticks = 0
    end
end

r = 40

function onDraw()
    w,h = screen.getWidth(), screen.getHeight()

    r = h/2-8

    screen.setColor(255, 255, 255)
    screen.drawClear()

    screen.setColor(200, 200, 200)
    screen.drawLine(w/2, 2, w/2, h-2)
    screen.drawLine(2, h/2, w-2, h/2)
    
    if ticks >= 120 then
        x, y = w/2 + r, h/2
        screen.setColor(0, 0, 200)
        drawCurve(x, y, 64, r * math.pi * 2, 2 * math.pi)
    end
    screen.setColor(255, 0, 0)

    if ticks >= 360 then
        screen.setColor(255, 0, 0)
        lx, ly = w/2+r, h/2
        screen.drawCircleF(lx, ly, 2)
        x2, y2 = drawCurve(lx, ly, 64, r, 1)
        screen.drawCircleF(x2, y2, 2)
    end

    if ticks >= 60 then
        screen.setColor(0, 0, 0)
        screen.drawCircleF(w/2, h/2, 2)
    end

    local mul = smoothstep(timer / frame.duration)
    frame.run(mul)
    screen.drawText(2, 2, "Frame: " .. framecounter .. "/" .. #frames .. " (" .. ticks .. " ticks)", 0, 0)
end