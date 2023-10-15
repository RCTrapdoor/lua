simulator:setScreen(1, "9x5")

maxboxes = 20

function onLBSimulatorTick(simulator, t)
    simulator:setInputBool(31, simulator:getIsClicked(1))
end

width, height = 288, 160
segments = 10

tree = {id = 1, x = 144, y = 139, length = 40, angleLimit = math.pi / 2}

-- add 10 random boxes

tau = 2 * math.pi
pi = math.pi

function sgn(x)
    if x > 0 then
        return 1
    elseif x < 0 then
        return -1
    else
        return 0
    end
end
p1, p2 = {x = 0, y = 0}, {x = 0, y = 0}
function drawCircle(x, y, radius, fromAngle, toAngle)
    fromAngle = fromAngle or 0
    toAngle = toAngle or tau
    for i = fromAngle, toAngle, sgn(toAngle - fromAngle) * tau / 360 do
        local x1 = x + radius * math.cos(i)
        local y1 = y + radius * math.sin(i)
        local x2 = x + radius * math.cos(i + tau / 360)
        local y2 = y + radius * math.sin(i + tau / 360)
        screen.drawLine(x1, y1, x2, y2)
    end
end

function dist(a, b) return math.sqrt((a.x - b.x) ^ 2 + (a.y - b.y) ^ 2) end

function vecAdd(a, b) return {x = a.x + b.x, y = a.y + b.y} end

function dotProduct(a, b) return a.x * b.x + a.y * b.y end

function angleBetween(a, b, c)
    local A, B = vecSub(b, a), vecSub(c, a)
    return math.acos(dotProduct(A, B) / (dist(a, b) * dist(a, c)))
end

function vecMul(a, b) return {x = a.x * b, y = a.y * b} end

function vecSub(a, b) return {x = a.x - b.x, y = a.y - b.y} end

function norm(a)
    local len = math.sqrt(a.x ^ 2 + a.y ^ 2)
    return {x = a.x / len, y = a.y / len}
end

function scale(a, s)
    local n = norm(a)
    return {x = n.x * s, y = n.y * s}
end

function lerp(a, b, t)
    return {x = a.x + (b.x - a.x) * t, y = a.y + (b.y - a.y) * t}
end

function crossProduct(a, b) return a.x * b.y - a.y * b.x end

function angle(a, b)
    local c = crossProduct(a, b)
    local s = dotProduct(a, b)
    return math.atan(c, s)
end

-- rotate a point around a point by an angle
function rotateAround(point, center, angle)
    local x, y = point.x - center.x, point.y - center.y
    local c, s = math.cos(angle), math.sin(angle)
    return {x = x * c - y * s + center.x, y = x * s + y * c + center.y}
end

parent = tree
for i = 1, segments do
    node = {
        id = i + 1,
        x = parent.x,
        y = parent.y - parent.length,
        length = parent.length * 0.9,
        parent = parent,
        angleLimit = parent.angleLimit
    }
    parent.child = node
    parent = parent.child
end

maxLen = 0
node = tree

while node.child do
    maxLen = maxLen + node.length
    node = node.child
end

effector = node

-- print(maxLen)

function vecSub(a, b) return {x = a.x - b.x, y = a.y - b.y} end

function get_orientation(p, q, r)
    local val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)
    if val == 0 then
        return 0
    elseif val > 0 then
        return 1
    end
    return 2
end

function check_on_segment(p, q, r)
    return q.x <= math.max(p.x, r.x) and q.x >= math.min(p.x, r.x) and q.y <=
               math.max(p.y, r.y) and q.y >= math.min(p.y, r.y)
end

-- init_boxes()

target = {x = 0, y = 0}
touch = {x = 0, y = 0}

ticks = 0
iterations = 0

lerpTime = 60
startLerp = 0


-- wps = {
--     {x = 0, y = 0}
-- }
function onTick()
    ticks = ticks + 1
    isPressed = input.getBool(1)
    if input.getBool(31) then
        init_boxes()
    end
    if isPressed then
        startLerp = ticks
        touch = {x = input.getNumber(3), y = input.getNumber(4)}
    end
    target = lerp(target, touch, math.min(1, (ticks - startLerp) / lerpTime))
    -- target = {x = 144 + 30 * math.cos(ticks / 10), y = 80 + 30 * math.sin(ticks / 10)}
    -- print((ticks - startLerp) / lerpTime)
    iterations = 0
    -- end
    -- touch_dist = dist(target, touch)
    -- target = vecAdd(target, vecMul(vecSub(touch, target), math.min(0.1, touch_dist * 2)))
    -- iterations = 0
    -- target.y = 40 + 30 * math.sin(ticks / 15)
    -- target.x = 144 + 60 * math.cos(ticks / 60)

    -- if dist(target, tree) < maxLen then
    node = effector
    diff = dist(node, target)

    while diff > 0.01 and iterations < 10 do
        iterations = iterations + 1
        node.x = target.x
        node.y = target.y

        origin = {x = tree.x, y = tree.y}
        -- print("")
        while node.parent do
            -- print(string.format("%d, %f %f", node.id, node.x, node.y))
            -- node.y = math.min(160, node.y)
            local d = vecSub(node.parent, node)
            local n = norm(d)
            local s = scale(n, node.parent.length)
            node.parent.x = node.x + s.x
            node.parent.y = node.y + s.y
            pos = {x = node.parent.x, y = node.parent.y}
            intersect = true
            if node.id > 2 then
                local last_limb = vecSub(node.parent, node)
                local angle = math.atan(last_limb.y, last_limb.x)
                p1 = {
                    x = node.parent.x + node.parent.length *
                        math.cos(angle + node.angleLimit),
                    y = node.parent.y + node.parent.length *
                        math.sin(angle + node.angleLimit)
                }
                p2 = {
                    x = node.parent.x + node.parent.length *
                        math.cos(angle - node.angleLimit),
                    y = node.parent.y + node.parent.length *
                        math.sin(angle - node.angleLimit)
                }
                local angle2 = angleBetween(node.parent, node.parent.parent,
                                            node)
                -- print(angle, angle2)
                if angle2 < (pi - node.angleLimit) then
                    if dist(p1, node.parent.parent) <
                        dist(p2, node.parent.parent) then
                        node.parent.parent.x = p1.x
                        node.parent.parent.y = p1.y
                    else
                        node.parent.parent.x = p2.x
                        node.parent.parent.y = p2.y
                    end
                end
            end
            node = node.parent
        end

        tree.x = origin.x
        tree.y = origin.y

        while node.child do
            local d = vecSub(node.child, node)
            local n = norm(d)
            local s = scale(n, node.length)
            orig_pos = {x = node.x + s.x, y = node.y + s.y}
            pos = {x = node.x + s.x, y = node.y + s.y}
            node.child.x = pos.x
            node.child.y = pos.y
            node = node.child
        end
        diff = dist(node, target)
    end
    -- end
    node = tree
    while node.child do
        if node.id > 1 and node.parent then
            output.setNumber(node.id, angle(vecSub(node, node.parent),
                                            vecSub(node.child, node)) / tau)
        end
        node = node.child
    end
    output.setNumber(1, math.atan((tree.child.x - tree.x),
                                  -(tree.child.y - tree.y)) / tau)
end

function drawTree(node)
    if node.child then
        -- every other id is a different color
        if node.id % 2 == 0 then
            screen.setColor(30, 30, 30)
        else
            screen.setColor(10, 10, 10)
        end
        screen.drawLine(node.x, node.y, node.child.x, node.child.y)
        drawTree(node.child)
        -- if node.parent then
        --     print(angleBetween(node, node.parent, node.child))
        -- end
        -- if node.parent then
        -- screen.drawText(node.x + 7, node.y, string.format("%.2f", angle(vecSub(node, node.parent), vecSub(node.child, node))))
        screen.setColor(255, 255, 255)
        pos = vecMul(vecAdd(node, node.child), 0.5)
        -- screen.drawText(pos.x - 2, pos.y - 3, node.id)
        -- end
    end
    screen.setColor(50, 50, 200)
    -- screen.drawText(node.x - 7, node.y - 7, string.format("%d", node.id))
    -- screen.drawCircle(node.x, node.y, 2)
end

function onDraw()
    screen.setColor(255, 255, 255)
    drawTree(tree)
    -- print()
    -- print()
    screen.setColor(255, 0, 0)
    screen.drawCircle(target.x, target.y, 2)
    -- drawCircle(144, 80, 20, 0, pi)
    drawCircle(tree.x, tree.y, maxLen, 0, -pi)
    local node = effector
    while node.parent and node.id > 2 do
        local last_limb = vecSub(node.parent, node)
        local angle = math.atan(last_limb.y, last_limb.x)
        -- print(angle)
        screen.setColor(40, 150, 40)
        -- drawCircle(node.parent.x, node.parent.y, 30, angle - node.angleLimit, angle + node.angleLimit)
        screen.setColor(0, 200, 0)
        -- screen.drawCircle(node.parent.x + node.parent.length * math.cos(angle - node.angleLimit), node.parent.y + node.parent.length * math.sin(angle - node.angleLimit), 2)
        -- screen.drawCircle(node.parent.x + node.parent.length * math.cos(angle + node.angleLimit), node.parent.y + node.parent.length * math.sin(angle + node.angleLimit), 2)
        -- screen.setColor(255, 0, 128)
        -- screen.drawText(node.parent.x + node.parent.length * math.cos(angle - node.angleLimit), node.parent.y + node.parent.length * math.sin(angle - node.angleLimit), string.format("%d", node.id))
        node = node.parent
    end
    screen.drawText(2, 2, iterations)
end
