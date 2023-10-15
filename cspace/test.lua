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
        simulator:setInputBool(31, simulator:getIsClicked(1))                              -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(26, simulator:getSlider(1) + simulator:getSlider(2) * -1) -- set input 31 to the value of slider 1
        simulator:setInputNumber(7, math.sin(ticks))

        simulator:setInputBool(32, simulator:getIsToggled(2))     -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(3) * 50) -- set input 32 to the value from slider 2 * 50
    end

    ;
end
---@endsection


-- Function to check if a line intersects with a circle
function lineCircleIntersect(a, b, c, r)
    local dx, dy, A, B, C, det, t, x, y
    dx = b.x - a.x
    dy = b.y - a.y
    A = dx * dx + dy * dy
    B = 2 * (dx * (a.x - c.x) + dy * (a.y - c.y))
    C = (a.x - c.x) * (a.x - c.x) + (a.y - c.y) * (a.y - c.y) - r * r
    det = B * B - 4 * A * C
    if det < 0 then
        return false
    end
    t = (-B - math.sqrt(det)) / (2 * A)
    if t < 0 or t > 1 then
        return false
    end
    x = a.x + t * dx
    y = a.y + t * dy
    return { x = x, y = y }
end

-- Define the cspace dimensions
width, height = 90, 90

-- Define the base and arm lengths
base = { x = 144, y = 160 }
arm = { { length = 40, angle = 0 }, { length = 40, angle = 0 } }

-- Initialize the cspace points
cspace = { width = 91, height = 91, points = {} }
for i = 1, width do
    cspace.points[i] = cspace.points[i] or {}
    for j = 1, height do
        cspace.points[i][j] = cspace.points[i][j] or 0
    end
end

-- Define the obstacles
obstacles = {
    { x = 164, y = 80, r = 10 },
    { x = 120, y = 95, r = 5 },
}

-- Calculate the cspace points
for i = -90, 90, 2 do
    for j = -90, 90, 2 do
        arm[1].angle = i * math.pi / 180
        arm[2].angle = j * math.pi / 180

        angle = math.pi / 2
        x, y = base.x, base.y
        for k = 1, #arm do
            angle = angle + arm[k].angle
            x_ = x + math.cos(angle) * arm[k].length
            y_ = y - math.sin(angle) * arm[k].length
            for _, obstacle in ipairs(obstacles) do
                if lineCircleIntersect({ x = x, y = y }, { x = x_, y = y_ }, obstacle, obstacle.r) then
                    cspace.points[(i + 90) / 2 + 1][(j + 90) / 2 + 1] = 1
                    break
                end
            end
            x, y = x_, y_
        end
    end
end

-- Function to check if a table contains a value
function contains(table, value)
    for _, v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Function to remove a value from a table
function removeByValue(table, value)
    for i, v in ipairs(table) do
        if v == value then
            table[i] = nil
            break
        end
    end
end

-- Function to find a path in the cspace using A* algorithm
function findPath(start, goal, cspace)
    local openSet = { start }
    local cameFrom = {}
    local gScore = {}
    local fScore = {}

    gScore[start] = 0
    fScore[start] = heuristicCostEstimate(start, goal)

    while #openSet > 0 do
        local current = openSet[1]
        if current.x == goal.x and current.y == goal.y then
            return reconstructPath(cameFrom, current)
        end

        removeByValue(openSet, current)

        local neighbors = getNeighbors(current, cspace)
        for _, neighbor in ipairs(neighbors) do
            local tentativeGScore = gScore[current] + 1

            if not gScore[neighbor] or tentativeGScore < gScore[neighbor] then
                cameFrom[neighbor] = current
                gScore[neighbor] = tentativeGScore
                fScore[neighbor] = tentativeGScore + heuristicCostEstimate(neighbor, goal)

                if not contains(openSet, neighbor) then
                    table.insert(openSet, neighbor)
                end
            end
        end
    end

    return nil
end

-- Helper function to calculate the heuristic cost estimate (Manhattan distance)
function heuristicCostEstimate(a, b)
    return math.abs(b.x - a.x) + math.abs(b.y - a.y)
end

-- Helper function to get the lowest fScore node from the open set
function getLowestFScore(set, scores)
    local lowest = math.huge
    local lowestNode = nil
    for _, node in ipairs(set) do
        local score = scores[node]
        if score and score < lowest then
            lowest = score
            lowestNode = node
        end
    end
    return lowestNode
end

-- Helper function to get the valid neighbor nodes in the cspace
function getNeighbors(node, cspace_)
    local neighbors = {}
    local x, y = node.x, node.y
    if x > 1 and cspace_.points[x - 1][y] == 0 then
        table.insert(neighbors, { x = x - 1, y = y })
    end
    if x < width and cspace_.points[x + 1][y] == 0 then
        table.insert(neighbors, { x = x + 1, y = y })
    end
    if y > 1 and cspace_.points[x][y - 1] == 0 then
        table.insert(neighbors, { x = x, y = y - 1 })
    end
    if y < height and cspace_.points[x][y + 1] == 0 then
        table.insert(neighbors, { x = x, y = y + 1 })
    end
    return neighbors
end

-- Helper function to reconstruct the path from start to goal
function reconstructPath(cameFrom, current)
    local totalPath = { current }
    while cameFrom[current.x] and cameFrom[current.x][current.y] do
        current = cameFrom[current.x][current.y]
        table.insert(totalPath, 1, current)
    end
    return totalPath
end

-- Variables for path playback
path = nil
pathIndex = 1

-- Function to initialize the path playback
function initializePlayback(start, goal)
    path = findPath(start, goal, cspace)
    pathIndex = 1
end

-- Function to play back the path with the robotic arm
function playbackPath()
    if path then
        if pathIndex <= #path then
            local node = path[pathIndex]
            arm[1].angle = (node.x - 45) * 2 * math.pi / 180
            arm[2].angle = (node.y - 45) * 2 * math.pi / 180
            pathIndex = pathIndex + 1
        else
            path = nil -- Path playback finished
        end
    end
end

-- Callback function for each frame
function onTick()
    -- Get input values
    isPressed = input.getBool(1)
    touchX = input.getNumber(3)
    touchY = input.getNumber(4)

    -- Check if start and stop vectors are valid
    if isPressed and touchX < 91 and touchY < 91 then
        start = { x = touchX, y = touchY }
        goal = { x = 10, y = 10 } -- Stop vector in the center of the cspace
        initializePlayback(start, goal)
    end

    -- Playback the path
    playbackPath()
end

-- Callback function for drawing
function onDraw()
    -- Draw the robotic arm
    screen.setColor(255, 0, 0)
    local x, y = base.x, base.y
    screen.drawCircleF(x, y, 4)
    local angle = math.pi / 2
    for k = 1, #arm do
        if k % 2 == 0 then
            screen.setColor(30, 30, 30)
        else
            screen.setColor(90, 90, 90)
        end
        angle = angle + arm[k].angle
        local x_ = x + math.cos(angle) * arm[k].length
        local y_ = y - math.sin(angle) * arm[k].length

        screen.drawLine(x, y, x_, y_)
        screen.drawCircleF(x_, y_, 2)
        x, y = x_, y_
    end

    -- Draw the obstacles
    screen.setColor(0, 255, 0)
    for i = 1, #obstacles do
        screen.drawCircleF(obstacles[i].x, obstacles[i].y, obstacles[i].r)
    end

    -- Draw the cspace points
    for x = 1, width do
        for y = 1, height do
            if cspace.points[x][y] == 1 then
                screen.setColor(255, 0, 0)
                screen.drawLine(x, y, x + 1, y)
            end
        end
    end
    screen.drawRect(0, 0, 91, 91)

    -- Draw the touch point if available
    if isPressed then
        screen.setColor(255, 255, 255)
        screen.drawCircle(touchX, touchY, 2)
    end
end
