do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "30x30")
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
        simulator:setInputBool(31, simulator:getIsClicked(1)) -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(31, simulator:getSlider(1)) -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2)) -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50) -- set input 32 to the value from slider 2 * 50
    end
end
---@endsection

width, height = 30 * 32, 30 * 32 -- Set the screen size here
cx, cy = width / 2, height / 2

-- State space model
state = function()
    return {
        x = 0,
        y = cy,
        vx = 0,
        vy = 0,
        angle = 0,
        angularVelocity = 0,
        update = function(self)
            -- Update state
            self.x = self.x + math.cos(self.angle)
            self.y = self.y + math.sin(self.angle)
            self.angle = self.angle + self.angularVelocity
        end
    }
end

num_agents = 7

agents = {}
histories = {}
math.randomseed(3)
for i = 1, num_agents do
    table.insert(agents, state())
    table.insert(histories, {})
end
for k = 1, 10 do
    for i = 1, num_agents do
        local agent = agents[i]
        agent.angularVelocity = (math.random() - 0.5) / 20
        for j = 1, 60 do
            agent:update()
            table.insert(histories[i], {x = agent.x, y = agent.y})
        end
    end
end

ticks = 0
function onTick()
end

-- initialise 7 srgb colors
colors = {{255, 0, 0}, {0, 255, 0}, {0, 0, 255}, {255, 255, 0}, {255, 0, 255}, {0, 255, 255}, {255, 255, 255}}


function onDraw()
    for i = 1, #histories do
        local history = histories[i]
        for j = 1, #history - 1 do
            local point = history[j]
            screen.setColor(table.unpack(colors[i]))
            screen.drawLine(point.x, point.y, history[j + 1].x, history[j + 1].y)
            if j % 60 == 0 then
                screen.setColor(255, 0, 0)
                screen.drawCircle(point.x, point.y, 2)
            end
        end
    end
end
