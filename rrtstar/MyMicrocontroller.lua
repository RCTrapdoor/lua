simulator:setScreen(1, "32x20")

math.randomseed(5)

ticks = 0

start = {x = 10, y = 10}
finish = {x = 270, y = 150}

stepsize = 100
neighborhood = 150

pertick = 5

function init(full)
    done = false

    if full then
        obstacles = {}
        for i = 1, 30 do
            local x, y, w, h = math.random(0, 900), math.random(0, 600),
                               math.random(10, 50), math.random(10, 50)
            obstacles[i] = {
                x = x,
                y = y,
                w = w,
                h = h,
                {x = x, y = y},
                {x = x + w, y = y},
                {x = x + w, y = y + h},
                {x = x, y = y + h}
            }
        end
    end

    tree = {
        {
            id = 1,
            x = start.x,
            y = start.y,
            parent = nil,
            cost = 0,
            heuristic = 0,
            total = 0
        }
    }
end

function make_node(x, y, parent)
    local node = {
        id = #tree + 1,
        x = x,
        y = y,
        parent = parent,
        cost = 0,
        heuristic = 0,
        total = 0
    }

    node.cost = parent.cost + dist(node, parent)
    node.heuristic = dist(node, finish)
    node.total = node.cost + node.heuristic

    table.insert(tree, node)

    return node
end

function change_parent(node, parent)
    node.parent = parent
    node.cost = node.parent.cost + dist(node, node.parent)
    node.heuristic = math.sqrt((node.x - finish.x) ^ 2 + (node.y - finish.y) ^ 2)
    node.total = node.cost + node.heuristic
    -- update_children(node)
end

-- function update_children(node)
--     -- update children recursively
--     for i, child in ipairs(tree) do
--         if child.parent == node then
--             change_parent(child, node)
--             update_children(child)
--         end
--     end
-- end

function dist(a, b) return (a.x - b.x) ^ 2 + (a.y - b.y) ^ 2 end

function vec_sub(a, b) return {x = a.x - b.x, y = a.y - b.y} end

function vec_mul(a, b) return {x = a.x * b, y = a.y * b} end

function cross_product(a, b) return a.x * b.y - a.y * b.x end

function norm(a) return math.sqrt(a.x ^ 2 + a.y ^ 2) end
radius_time = 0
function nodes_in_radius(tree, pos, radius)
    local now = os.clock()
    local nodes = {}
    for i = 1, #tree do

        local node = tree[i]
        local dist = dist(node, pos)

        if dist <= radius then
            intersects = false

            for _, obstacle in pairs(obstacles) do
                if line_rect_intersection(pos, node, obstacle) then
                    intersects = true
                    break
                end
            end
            if not intersects then
                table.insert(nodes, {dist = dist, node = node})
            end
        end
    end

    table.sort(nodes, function(a, b) return a.dist < b.dist end)
    radius_time = radius_time * 0.9 + (os.clock() - now) * 0.1
    return nodes
end

function closest_node(tree, pos)
    local nodes = nodes_in_radius(tree, pos, 1000)
    if #nodes > 0 then return nodes[1].node end
end

function randpoint(x, y, w, h)
    return {x = math.random(x, x + w), y = math.random(y, y + h)}
end

function line_line_intersection(a, b, c, d)
    local r = vec_sub(b, a)
    local s = vec_sub(d, c)
    local q = vec_sub(c, a)

    local t = cross_product(q, r) / cross_product(r, s)
    local u = cross_product(q, s) / cross_product(r, s)

    if t >= 0 and t <= 1 and u >= 0 and u <= 1 then
        -- return {x = a.x + u * (b.x - a.x), y = a.y + u * (b.y - a.y)}
        return true
    end
end

function line_rect_intersection(a, b, rect)
    -- local points = {}

    for i = 1, 4 do
        local p = line_line_intersection(a, b, rect[i], rect[i % 4 + 1])
        if p then
            -- table.insert(points, p)
            return true
        end
    end

    -- return points
end

function set_distance(from, to, dist)
    local v = vec_sub(to, from)
    local n = norm(v)
    to.x = from.x + dist * v.x / n
    to.y = from.y + dist * v.y / n
end

last_clock = os.clock()

attempts = 0
touchTimer = 0

function onTick()
    last_clock = os.clock()
    -- isClick = input.getBool(1) and not isPressed
    -- isPressed = input.getBool(1)

    isClick = touchTimer < 30 and touchTimer > 0 and not input.getBool(1)
    isHold = touchTimer >= 30
    touchTimer = input.getBool(1) and touchTimer + 1 or 0

    output.setBool(1, isClick)
    output.setBool(2, isHold)

    touch = {x = input.getNumber(3), y = input.getNumber(4)}

    if simulator:getIsClicked(1) or ticks == 0 then init(true) end

    ticks = ticks + 1

    if isClick then
        isfinish = closest_node(tree, touch)
        -- if isfinish then
        if isfinish and dist(isfinish, touch) < 5 then
            finish = isfinish
            done = finish
        -- end
        else
            finish = {x = touch.x, y = touch.y}
            done = false
        end
    --     init()
    -- else
    end
    -- if not done then
        for i = 1, pertick do
            attempts = attempts + 1
            if attempts % 10 == 0 and not done then
                pos = {x = finish.x, y = finish.y}
            else
                pos = randpoint(0, 0, 288, 160)
            end

            local node = closest_node(tree, pos)
            if node then

                if dist(pos, node) > stepsize then
                    set_distance(node, pos, stepsize)
                end

                intersects = false
                for _, obstacle in ipairs(obstacles) do
                    if line_rect_intersection(node, pos, obstacle) then
                        intersects = true
                        break
                    end
                end
                if not intersects then
                    node = make_node(pos.x, pos.y, node)
                    if pos.x == finish.x and pos.y == finish.y then
                        done = node
                    end
                end

                intersects = false
                for _, other_node in ipairs(nodes_in_radius(tree, pos, stepsize)) do
                    if other_node.node.cost < node.parent.cost then
                        change_parent(node, other_node.node)
                    end
                end

                intersects = false
                for _, other_node in ipairs(nodes_in_radius(tree, pos, neighborhood)) do
                    if other_node.node.cost > (node.cost + dist(other_node.node, node)) then
                        change_parent(other_node.node, node)
                    end
                end
            end
        end
    -- end
end

function onDraw()
    screen.setColor(10, 10, 10)
    screen.drawClear()

    for _, obstacle in ipairs(obstacles) do
        screen.setColor(50, 50, 50)
        screen.drawRectF(obstacle.x, obstacle.y, obstacle.w, obstacle.h)

        -- intersect = line_rect_intersection(start, finish, obstacle)
        -- if #intersect > 0 then
        --     for _, point in ipairs(intersect) do
        --         screen.setColor(255, 0, 0)
        --         screen.drawCircle(point.x, point.y, 1)
        --     end
        -- end
    end

    -- screen.setColor(255, 255, 255, 30)
    -- for _, node in ipairs(tree) do
    --     screen.drawCircle(node.x, node.y, 1)
    --     if node.parent then
    --         -- screen.setColor(255, 0, 0)
    --         screen.drawLine(node.x, node.y, node.parent.x, node.parent.y)
    --     end
    -- end

    if done then
        done_ = done
        cost = 0
        while done_.parent do
            cost = cost + dist(done_.parent, done_)
            screen.setColor(0, 255, 0)
            screen.drawCircle(done_.x, done_.y, 1)
            screen.drawLine(done_.x, done_.y, done_.parent.x, done_.parent.y)
            done_ = done_.parent
        end
        screen.drawText(140, 150, string.format("%6.2f / %6.2f", cost, dist(start, finish)))
    end

    screen.setColor(50, 10, 10)
    screen.drawCircle(finish.x, finish.y, 2)

    screen.setColor(10, 50, 10)
    screen.drawCircle(start.x, start.y, 2)

    screen.setColor(0, 0, 0)
    screen.drawText(250, 2, string.format("%6.2f/s", pertick / (os.clock() - last_clock)))
    screen.drawText(250, 12, string.format("%6.4fs", radius_time))
    screen.drawText(250, 22, string.format("%5.0f", attempts))
    screen.drawText(250, 32, string.format("%5.0f", #tree))

    for i = 1, touchTimer do
        local angle = math.pi * 2 * i / 30
        local angle2 = math.pi * 2 * (i + 1) / 30
        local px1 = touch.x + math.cos(angle) * 5
        local py1 = touch.y + math.sin(angle) * 5
        local px2 = touch.x + math.cos(angle2) * 5
        local py2 = touch.y + math.sin(angle2) * 5
        screen.setColor(255, 255, 255)
        screen.drawLine(px1, py1, px2, py2)
    end

    if isClick then
        screen.setColor(255, 128, 0, 100)
        screen.drawCircleF(touch.x, touch.y, 5)
    end
    if isHold then
        screen.setColor(0, 255, 0, 100)
        screen.drawCircleF(touch.x, touch.y, 5)
    end
    
    -- screen.setColor(10, 10, 10, 10)
    -- screen.drawLine(start.x, start.y, finish.x, finish.y)
end
