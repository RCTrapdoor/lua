---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "1x1")
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

indicator = "220"
function onTick()
    brightness = input.getNumber(31)^4
end

function onDraw()
    w, h = screen.getWidth(), screen.getHeight()
    -- nfpa indicator
    screen.setColor(255 * brightness, 255 * brightness, 255 * brightness)
    screen.drawClear()
    screen.setColor(255 * brightness, 0, 0)
    screen.drawTriangleF(w/2, 0, w/4, h/4, w*3/4, h/4)
    screen.drawTriangleF(w/2, h/2, w/4, h/4, w*3/4, h/4)
    screen.setColor(0, 0, 255 * brightness)
    screen.drawTriangleF(0, h/2, w/4, h/4, w/4, h*3/4)
    screen.drawTriangleF(w/2, h/2, w/4, h/4, w/4, h*3/4)
    screen.setColor(255 * brightness, 255 * brightness, 0)
    screen.drawTriangleF(w/2, h/2, w*3/4, h/4, w*3/4, h*3/4)
    screen.drawTriangleF(w, h/2, w*3/4, h/4, w*3/4, h*3/4)

    screen.setColor(0, 0, 0)
    screen.drawLine(0, h/2, w/2, 0)
    screen.drawLine(w/2, 0, w, h/2)
    screen.drawLine(w, h/2, w/2, h)
    screen.drawLine(w/2, h, 0, h/2)
    screen.drawLine(w/4, h/4, 3*w/4, 3*h/4)
    screen.drawLine(3*w/4, h/4, w/4, 3*h/4)
    
    screen.drawTextBox(0, h/4, w/2, h/2, indicator:sub(1, 1), 0, 0)
    screen.drawTextBox(w/4, 0, w/2, h/2, indicator:sub(2, 2), 0, 0)
    screen.drawTextBox(w/2, h/4, w/2, h/2, indicator:sub(3, 3), 0, 0)

end
