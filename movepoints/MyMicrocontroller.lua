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
        simulator:setInputBool(31, simulator:getIsClicked(1))     -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(31, simulator:getSlider(1))      -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2))     -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50) -- set input 32 to the value from slider 2 * 50
    end

    ;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

function dist(a, b)
    return ((a[1] - b[1]) ^ 2 + (a[2] - b[2]) ^ 2) ^ 0.5
end

points = {
    { 10, 20 }, -- distance, altitude
    { 20, 10 },
    { 30, 30 },
    { 40, 30 }
}

selected = nil

ticks = 0

function onTick()
    ticks = ticks + 1
    isClick = input.getBool(1) and not isPress
    isPress = input.getBool(1)

    touch = { input.getNumber(3), input.getNumber(4) }

    if isClick then
        if selected then
            local point = points[selected]
            point[1] = touch[1] -- set the new X position
            point[2] = touch[2] -- set the new Y position
            selected = nil
        else
            for k = 1, #points do       -- loop over the waypoints
                local point = points[k]
                if dist(point, touch) < 10 then -- if you press within 10 pixels
                    selected = k
                    break               -- stop the loop since we found a point within 10 pixels
                end
            end
        end
    end
end

function onDraw()

    for k = 1, #points do
        screen.setColor(30, 30, 30)
        local point1 = points[k]
        local point2 = points[k + 1]

        if k < #points then
            screen.drawLine(point1[1], point1[2], point2[1], point2[2])
        end
        
        screen.setColor(255, 255, 255)
        screen.drawText(point1[1] - 6, point1[2] - 9, k)

        if selected == k and ticks % 20 < 10 then
            screen.setColor(255, 0, 0)
        else
            screen.setColor(30, 30, 30)
        end

        screen.drawCircle(point1[1], point1[2], 3)
    end

    if isPress then
        screen.setColor(50, 50, 50)
        screen.drawCircle(touch[1], touch[2], 10)
    end
end
