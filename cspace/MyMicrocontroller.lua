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

function lineCircleIntersect(a, b, c, r) -- a: line start, b: line end, c: circle center, r: circle radius
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

function isCircleIntersectingTriangle(circleX, circleY, radius, ax, ay, bx, by, cx, cy)
    local function isPointInsideCircle(x, y)
        return (x - circleX) ^ 2 + (y - circleY) ^ 2 <= radius ^ 2
    end

    local function lineCircleIntersection(x1, y1, x2, y2)
        local dx = x2 - x1
        local dy = y2 - y1
        local t = ((circleX - x1) * dx + (circleY - y1) * dy) / (dx * dx + dy * dy)
        t = math.max(0, math.min(1, t))
        local closestX = x1 + t * dx
        local closestY = y1 + t * dy
        return isPointInsideCircle(closestX, closestY)
    end

    if isPointInsideCircle(ax, ay) and isPointInsideCircle(bx, by) and isPointInsideCircle(cx, cy) then
        return true
    end

    if lineCircleIntersection(ax, ay, bx, by) or lineCircleIntersection(bx, by, cx, cy) or lineCircleIntersection(cx, cy, ax, ay) then
        return true
    end

    local function isPointInTriangle(x, y, x1, y1, x2, y2, x3, y3)
        local denominator = ((y2 - y3) * (x1 - x3) + (x3 - x2) * (y1 - y3))
        local a = ((y2 - y3) * (x - x3) + (x3 - x2) * (y - y3)) / denominator
        local b = ((y3 - y1) * (x - x3) + (x1 - x3) * (y - y3)) / denominator
        local c = 1 - a - b

        return a >= 0 and b >= 0 and c >= 0
    end

    if isPointInTriangle(circleX, circleY, ax, ay, bx, by, cx, cy) then
        return true
    end

    return false
end


function rot2d(x, y, angle)
    return x * math.cos(angle) - y * math.sin(angle), x * math.sin(angle) + y * math.cos(angle)
end

tau = math.pi * 2
pi = tau / 2

width, height = 288, 160

base = { x = width / 2, y = height }

arm = { { length = 50, angle = 0, min = -pi / 2, max = pi / 2, type = "revolute" },
    { length = 50, angle = 0, type = "length", min = -pi, max = pi} }

cspace = { width = 50, height = 50, points = {} }

fps = 0
ltime = os.clock()

for i = 1, cspace.width * cspace.height do
    cspace.points[i] = {
        obstacle = false,
        visited = false,
        parent = nil,
        neighbors = {},
        x = (i - 1) % cspace.width,
        y = math.floor((i - 1) / cspace.width),
        localGoal = 0,  -- distance from start
        globalGoal = 0, -- distance from end
    }
end

obstacles = {}
n = 6
for i = 0, n - 1 do
    table.insert(obstacles, { x = math.cos (i * tau / n) * 45 + width / 2, y = math.sin (i * tau / n) * 45 + height / 1.5, r = 2 })
end

package = {
    {x = 0, y = -10},
    {x = 30, y = -10},
    {x = 30, y = 10},
    {x = 0, y = 10}
}

for i = 0, cspace.width - 1 do
    for j = 0, cspace.height - 1 do
        if i > 0 then
            table.insert(cspace.points[j * cspace.width + i + 1].neighbors, cspace.points[j * cspace.width + i])
        end
        if i < cspace.width - 1 then
            table.insert(cspace.points[j * cspace.width + i + 1].neighbors, cspace.points[j * cspace.width + i + 2])
        end
        if j > 0 then
            table.insert(cspace.points[j * cspace.width + i + 1].neighbors, cspace.points
            [(j - 1) * cspace.width + i + 1])
        end
        if j < cspace.height - 1 then
            table.insert(cspace.points[j * cspace.width + i + 1].neighbors, cspace.points
            [(j + 1) * cspace.width + i + 1])
        end

        arm[1].angle = arm[1].min + i * (arm[1].max - arm[1].min) / (cspace.width - 1)
        arm[2].angle = arm[2].min + j * (arm[2].max - arm[2].min) / (cspace.height - 1)

        angle = pi / 2
        x, y = base.x, base.y
        for k = 1, #arm do
            angle = angle + arm[k].angle
            x_ = x + math.cos(angle) * arm[k].length
            y_ = y - math.sin(angle) * arm[k].length
            for _, obstacle in ipairs(obstacles) do
                if lineCircleIntersect({ x = x, y = y }, { x = x_, y = y_ }, obstacle, obstacle.r + 1.2) or (x_ < 0 or x_ > width or y_ < 0 or y_ > height) then
                    cspace.points[j * cspace.width + i + 1].obstacle = true
                    break
                end
            end
            x, y = x_, y_
        end
        -- check if package intersects an obstacle
        local x1, y1 = rot2d(package[1].x, package[1].y, -angle)
        local x2, y2 = rot2d(package[2].x, package[2].y, -angle)
        local x3, y3 = rot2d(package[3].x, package[3].y, -angle)
        local x4, y4 = rot2d(package[4].x, package[4].y, -angle)
        for _, obstacle in ipairs(obstacles) do
            if isCircleIntersectingTriangle(obstacle.x, obstacle.y, obstacle.r + 0.5, x + x1, y + y1, x + x2, y + y2, x + x3, y + y3) or
                isCircleIntersectingTriangle(obstacle.x, obstacle.y, obstacle.r + 0.5, x + x1, y + y1, x + x3, y + y3, x + x4, y + y4) or
                (x + x1 < 0 or x + x1 > width or y + y1 < 0 or y + y1 > height) or
                (x + x2 < 0 or x + x2 > width or y + y2 < 0 or y + y2 > height) or
                (x + x3 < 0 or x + x3 > width or y + y3 < 0 or y + y3 > height) or
                (x + x4 < 0 or x + x4 > width or y + y4 < 0 or y + y4 > height) then
                cspace.points[j * cspace.width + i + 1].obstacle = true
                break
            end
        end
    end
end

nodeStart = cspace.points[math.floor(cspace.width / 2) * cspace.width + cspace.height / 2]
nodeEnd = cspace.points[math.floor(cspace.width / 2) * cspace.width + cspace.height / 2]

arm[1].angle = arm[1].min + nodeStart.x * (arm[1].max - arm[1].min) / (cspace.width - 1)
arm[2].angle = arm[2].min + nodeStart.y * (arm[2].max - arm[2].min) / (cspace.height - 1)


function lerp(a, b, t)
    return a + (b - a) * t
end

ticks = 0
current = 1

-- path = {{0, 0, x = 43, y = 45}}
-- old_angle = {0, 0}

function dist(a, b)
    return math.sqrt((a.x - b.x) ^ 2) + math.sqrt((a.y - b.y) ^ 2)
end

function heuristic(a, b)
    return dist(a, b)
end

function Solve_AStar()
    for i = 1, cspace.width * cspace.height do
        cspace.points[i].visited = false
        cspace.points[i].parent = nil
        cspace.points[i].localGoal = math.huge
        cspace.points[i].globalGoal = math.huge
    end

    nodeCurrent = nodeStart
    nodeStart.localGoal = 0
    nodeStart.globalGoal = heuristic(nodeStart, nodeEnd)

    listNotTestedNodes = { nodeStart }

    while #listNotTestedNodes > 0 do
        table.sort(listNotTestedNodes, function(a, b) return a.globalGoal < b.globalGoal end)

        while #listNotTestedNodes > 0 and listNotTestedNodes[1].visited do
            table.remove(listNotTestedNodes, 1)
        end

        if #listNotTestedNodes == 0 then
            break
        end

        nodeCurrent = listNotTestedNodes[1]
        nodeCurrent.visited = true

        for _, nodeNeighbor in ipairs(nodeCurrent.neighbors) do
            if not nodeNeighbor.visited and not nodeNeighbor.obstacle then
                table.insert(listNotTestedNodes, nodeNeighbor)
            end

            local possiblyLowerGoal = nodeCurrent.localGoal + dist(nodeCurrent, nodeNeighbor)

            if possiblyLowerGoal < nodeNeighbor.localGoal then
                nodeNeighbor.parent = nodeCurrent
                nodeNeighbor.localGoal = possiblyLowerGoal
                nodeNeighbor.globalGoal = nodeNeighbor.localGoal + heuristic(nodeNeighbor, nodeEnd)
            end
        end
    end
end

steps = 2

function onTick()
    isClick = input.getBool(1) and not isPressed
    isPressed = input.getBool(1)

    touch = { x = input.getNumber(3), y = input.getNumber(4) }

    if isClick and touch.x < cspace.width and touch.y < cspace.height then
        if path then
            nodeStart = path[current]
        end
        old_angle = { arm[1].angle, arm[2].angle }
        path = nil
        nodeEnd = cspace.points[math.floor(touch.y) * cspace.width + math.floor(touch.x) + 1]

        path = Solve_AStar()

        if nodeEnd.parent then
            path = {}
            nodeCurrent = nodeEnd
            while nodeCurrent.parent do
                table.insert(path, nodeCurrent)
                nodeCurrent = nodeCurrent.parent
            end
            table.insert(path, nodeCurrent)
            current = #path
        end
    end

    if path then
        if ticks % steps == 0 then
            current = current - 1
            if current == 0 then
                current = #path
            end
            old_angle = { arm[1].angle, arm[2].angle }
        end
        x, y = path[current].x, path[current].y

        arm[1].angle = lerp(old_angle[1], arm[1].min + x * (arm[1].max - arm[1].min) / (cspace.width - 1),
            ticks % steps / steps)
        arm[2].angle = lerp(old_angle[2], arm[2].min + y * (arm[2].max - arm[2].min) / (cspace.height - 1),
            ticks % steps / steps)

        if path[current] == nodeEnd then
            nodeEnd.parent = nil
            nodeStart = nodeEnd
            path = nil
        end
    end

    ticks = ticks + 1
end

function onDraw()
    fps = 0.1 * (1 / (os.clock() - ltime)) + 0.9 * fps
    ltime = os.clock()
    screen.setColor(255, 0, 0)
    x, y = base.x, base.y
    screen.drawCircleF(x, y, 4)
    angle = pi / 2

    if nodeEnd.parent then
        screen.setColor(20, 20, 0)
        node = nodeEnd
        while node.parent do
            screen.drawLine(node.x, node.y, node.parent.x, node.parent.y)
            node = node.parent
        end
    end

    for k = 1, #arm do
        if k % 2 == 0 then
            screen.setColor(30, 30, 30)
        else
            screen.setColor(90, 90, 90)
        end
        angle = angle + arm[k].angle
        x_ = x + math.cos(angle) * arm[k].length
        y_ = y - math.sin(angle) * arm[k].length

        screen.drawLine(x, y, x_, y_)
        screen.drawCircleF(x_, y_, 1)
        x, y = x_, y_
    end

    screen.setColor(0, 255, 0)
    for i = 1, #obstacles do
        screen.drawCircleF(obstacles[i].x, obstacles[i].y, obstacles[i].r)
    end

    screen.setColor(255, 0, 0)
    for i = 1, #cspace.points do
        if cspace.points[i].obstacle then
            screen.drawLine(cspace.points[i].x, cspace.points[i].y, cspace.points[i].x, cspace.points[i].y + 1)
        elseif nodeStart == cspace.points[i] then
            screen.setColor(0, 0, 255)
            screen.drawLine(cspace.points[i].x, cspace.points[i].y, cspace.points[i].x, cspace.points[i].y + 1)
            screen.setColor(255, 0, 0)
        elseif nodeEnd == cspace.points[i] then
            screen.setColor(0, 255, 0)
            screen.drawLine(cspace.points[i].x, cspace.points[i].y, cspace.points[i].x, cspace.points[i].y + 1)
            screen.setColor(255, 0, 0)
        elseif path and path[current] == cspace.points[i] then
            screen.setColor(255, 255, 255)
            screen.drawLine(cspace.points[i].x, cspace.points[i].y, cspace.points[i].x, cspace.points[i].y + 1)
            screen.setColor(255, 0, 0)
        end
    end

    screen.setColor(255, 255, 255)
    screen.drawRect(0, 0, cspace.width, cspace.height)

    -- screen.setColor(255, 255, 255)
    -- for i = 1, #path do
    --     screen.drawCircle(path[i].x, path[i].y, 2)
    -- end
    screen.drawText(width - 60, 2, string.format("FPS: %.2f", fps))

    screen.setColor(128, 128, 0)
    x1, y1 = rot2d(package[1].x, package[1].y, -angle)
    x2, y2 = rot2d(package[2].x, package[2].y, -angle)
    x3, y3 = rot2d(package[3].x, package[3].y, -angle)
    x4, y4 = rot2d(package[4].x, package[4].y, -angle)
    
    screen.drawText(x + x1, y + y1, "1")
    screen.drawText(x + x2, y + y2, "2")
    screen.drawText(x + x3, y + y3, "3")
    screen.drawText(x + x4, y + y4, "4")
    screen.drawTriangle(x + x1, y + y1, x + x2, y + y2, x + x3, y + y3)
    screen.drawTriangle(x + x1, y + y1, x + x3, y + y3, x + x4, y + y4)
end
