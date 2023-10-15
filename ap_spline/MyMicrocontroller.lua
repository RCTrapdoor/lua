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

width, height = 288, 160

tau = math.pi * 2
pi = math.pi

path = {}

for i = 0, 256 do
    table.insert(path, {x = width/2 + math.cos(i/255 * tau) * 80 + math.cos(i/255 * tau * 16) * 10, y = height/2 + math.sin(i/255 * tau) * 80 + math.sin(i/255 * tau * 16) * 10})
    print(string.format("table.insert(path, {x = %8.2f, y = %8.2f})", path[#path].x, path[#path].y))
end
function v(x, y)
    return {x = x or 0, y = y or 0}
end

function dist(a, b)
    b = b or v()
    return math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
end

function vecSub(a, b)
    return {x = a.x - b.x, y = a.y - b.y}
end

function dotProduct(a, b)
    return a.x * b.x + a.y * b.y
end

function vecScale(a, s)
    return {x = a.x / dist(a) * s, y = a.y / dist(a) * s}
end

function vecAdd(a, b)
    return {x = a.x + b.x, y = a.y + b.y}
end

ticks = 0

current_node = 1
next_node = 2

agent = {
    pos = {x = 0, y = 0},
    vel = {x = 0, y = 0},
    acc = {x = 0, y = 0},
    max_speed = 1,
    max_force = 0.25,
    radius = 5
}

lookahead = 5

function onTick()
    ticks = ticks + 1

    a = vecSub(agent.pos, path[current_node])
    b = vecSub(path[next_node], path[current_node])
    
    proj_dist = dotProduct(a, b) / dist(b) + lookahead
    
    --while proj_dist > dist(b) do
    while proj_dist > dist(agent.pos, path[next_node]) do
        print(string.format("proj_dist: %8.2f, dist(b): %8.2f", proj_dist, dist(b)))
        current_node = next_node
        next_node = (next_node % #path) + 1
        a = vecSub(agent.pos, path[current_node])
        b = vecSub(path[next_node], path[current_node])
        proj_dist = dotProduct(a, b) / dist(b) + lookahead
        -- proj_dist = dist(agent.pos, path[next_node]) + lookahead
    end

    -- a better control algorithm would be to use the distance to the next node as the lookahead
    -- this would allow the agent to slow down as it approaches the next node
    -- proj_dist = dist(agent.pos, path[next_node]) + lookahead


    proj_point = vecAdd(path[current_node], vecScale(b, proj_dist))

    desired = vecSub(proj_point, agent.pos)
    desired = vecScale(desired, agent.max_speed)

    steer = vecSub(desired, agent.vel)
    steer = vecScale(steer, agent.max_force)

    agent.acc = steer

    agent.vel = vecAdd(agent.vel, agent.acc)
    agent.pos = vecAdd(agent.pos, agent.vel)
end

function onDraw()
    screen.setColor(255, 255, 255)
    for i = 1, #path do
        local node = path[i]
        local next_node = path[(i % #path) + 1]
        screen.drawLine(node.x, node.y, next_node.x, next_node.y)
    end

    screen.drawCircle(agent.pos.x, agent.pos.y, agent.radius)
    
    screen.setColor(255, 0, 0)
    screen.drawCircle(proj_point.x, proj_point.y, 5)
end