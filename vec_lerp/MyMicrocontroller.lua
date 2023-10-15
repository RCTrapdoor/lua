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
    simulator:setScreen(1, "5x3")
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

function vecScale(vec, scale)
    return {x = vec.x * scale, y = vec.y * scale}
end

function vecAdd(vec1, vec2)
    return {x = vec1.x + vec2.x, y = vec1.y + vec2.y}
end

current_vec = {x = 0, y = 0}
target_vec = {x = 4, y = 6}

ticks = 0
function onTick()
    ticks = ticks + 1
    alpha = 0.1
    if input.getBool(1) then
        target_vec = {x = input.getNumber(3), y = input.getNumber(4)}
    end
    current_vec = vecAdd(vecScale(current_vec, 1 - alpha), vecScale(target_vec, alpha))
end

function onDraw()
    screen.setColor(255, 255, 255)
    screen.drawText(2, 2, string.format("x: %f, y: %f", current_vec.x, current_vec.y), 0.5, 0.5, 0.5, 1)

    screen.setColor(255, 0, 0)
    screen.drawCircle(current_vec.x, current_vec.y, 1)

    screen.setColor(0, 255, 0)
    screen.drawCircle(target_vec.x, target_vec.y, 1)
end