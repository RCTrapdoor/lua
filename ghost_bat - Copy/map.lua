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

w, h = 288, 160
zoom = 1
map_coords = {x = 0, y = 0}

function drawArrow(heading, length)
    x, y = w / 2 + math.cos(heading) * (h/2 - 15), h / 2 - math.sin(heading) * (h/2 - 15)
    x2, y2 = w / 2 + math.cos(heading) * (h/2 - 15 - length), h / 2 - math.sin(heading) * (h/2 - 15 - length)
    screen.drawLine(x, y, x2, y2)
    screen.drawLine(x, y, x + math.cos(heading + 3 * math.pi / 4) * length/2, y - math.sin(heading + 3 * math.pi / 4) * length/2)
    screen.drawLine(x, y, x + math.cos(heading - 3 * math.pi / 4) * length/2, y - math.sin(heading - 3 * math.pi / 4) * length/2)
end

function dist(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

function onTick()
    click = input.getBool(7) and not press
    press = input.getBool(7)
    gps = {x = input.getNumber(10), y = input.getNumber(12)}
    to = {x = input.getNumber(13), y = input.getNumber(14)}
    heading = (input.getNumber(9) + 0.25) * math.pi * 2
    if click and ((to.y > 15 and to.y < 145) or (to.x > 15 and to.x < 273)) then
        if map_coords.x == 0 then
            x, y = map.screenToMap(gps.x, gps.y, zoom, w, h, to.x, to.y)
            map_coords.x = x
            map_coords.y = y
        else
            x, y = map.screenToMap(0, 0, zoom, w, h, to.x, to.y)
            map_coords.x = map_coords.x + x
            map_coords.y = map_coords.y + y
        end
    end
    if input.getNumber(32) == 2 then
        zoom = zoom * 1.01
    elseif input.getNumber(32) == 3 then
        zoom = zoom / 1.01
    elseif input.getNumber(32) == 4 then
        map_coords = {x = 0, y = 0}
    end
end

function onDraw()
    screen.setColor(255, 0, 0)
    -- if faen then
    if map_coords.x == 0 then
        map_x = gps.x
        map_y = gps.y
    else
        map_x = map_coords.x
        map_y = map_coords.y
    end
    x, y = map.mapToScreen(map_x, map_y, zoom, w, h, gps.x, gps.y)
    screen.drawMap(map_x, map_y, zoom)
    screen.drawCircle(x, y, 2)
    screen.drawLine(x, y, x + math.cos(heading) * 35, y - math.sin(heading) * 35)
    if not ((y > 15 and y < 145) and (x > 15 and x < 273)) then
        angle = math.atan(-(y - h / 2), x - w / 2)
        drawArrow(angle, 20)
    end
    -- end
    -- screen.drawText(0, 20, "Zoom: " .. zoom)
    -- screen.drawText(0, 30, string.format("x: %.2f, z: %.2f", x, y))
end