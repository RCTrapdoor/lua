---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "9x5")
    simulator:setProperty("ExampleNumberProperty", 123)

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)

        -- touchscreen defaults
        local screenConnection = simulator:getTouchScreen(1)
        simulator:setInputBool(1, screenConnection.isTouched)
        -- simulator:setInputNumber(1, screenConnection.width)
        -- simulator:setInputNumber(2, screenConnection.height)
        simulator:setInputNumber(3, screenConnection.touchX)
        simulator:setInputNumber(4, screenConnection.touchY)

        -- NEW! button/slider options from the UI
        simulator:setInputBool(31, simulator:getIsClicked(1))       -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(1, simulator:getSlider(1))        -- set input 31 to the value of slider 1
        simulator:setInputNumber(2, simulator:getSlider(2))        -- set input 32 to the value of slider 2
        -- simulator:setInputNumber(3, simulator:getSlider(3))        -- set input 33 to the value of slider 3
        -- simulator:setInputNumber(4, simulator:getSlider(4))        -- set input 34 to the value of slider 4

        simulator:setInputBool(32, simulator:getIsToggled(2))       -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50)   -- set input 32 to the value from slider 2 * 50
    end;
end
---@endsection

w = 288
h = 160

player = {x = w/2, y = 0, width = 4, height = 8, yvel = 0, xvel = 0, color = {128, 90, 0}, status = "ground"}

ground = {x = w/2 - 50, y = 120, width = 100, height = 20, color = {40, 100, 10}}
touch = {x = 0, y = 0, press = false, click = false}
touch2 = {x = 0, y = 0, press = false, click = false}

ticks = 0

function onTick()
    if player.y + player.height >= ground.y then
        player.status = "ground"
    else
        player.status = "air"
    end
    ticks = ticks + 1

    touch = {x = input.getNumber(3), y = input.getNumber(4), press = input.getBool(1), click = input.getBool(1) and not touch.press}
    touch2 = {x = input.getNumber(3), y = input.getNumber(4), press = input.getBool(2), click = input.getBool(2) and not touch2.press}
    if touch.press then
        player.xvel = math.max(-2, math.min(2, (touch.x - player.x) / 200 + player.xvel))
    end

    player.x = player.x + player.xvel
    player.y = player.y + player.yvel

    player.xvel = player.xvel * 0.9
    -- if player.xvel < 0.1 and player.xvel > -0.1 then
    --     player.xvel = 0
    -- end

    if player.status == "ground" and touch2.click then
        player.yvel = -2
        player.status = "air"
    end

    player.yvel = math.min(2, player.yvel + 0.1)

    -- check if player collided with ground
    -- for i = 1, 4 do
        if player.x + player.width > ground.x and player.x < ground.x + ground.width then
            if player.y + player.height+player.yvel > ground.y and player.y - player.height+player.yvel < ground.y + ground.height then
                player.y = ground.y - player.height+player.yvel
                player.yvel = 0
            end
        end
    -- end

end

function onDraw()
    screen.setColor(table.unpack(player.color))
    screen.drawRectF(player.x, player.y, player.width, player.height)

    screen.setColor(table.unpack(ground.color))
    screen.drawRectF(ground.x, ground.y, ground.width, ground.height)

    screen.setColor(255, 255, 255)
    screen.drawText(0, 0, ("x: %+6.1f, y: %+6.1f, xvel: %+4.1f, yvel: %+4.1f, status: %s"):format(player.x, player.y, player.xvel, player.yvel, player.status))
end



