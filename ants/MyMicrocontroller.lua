require("_build._simulator_config") -- default simulator config, CTRL+CLICK it or F12 to goto this file and edit it. Its in a separate file just for convenience.
require("LifeBoatAPI")              -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library

obstacles = {}

-- random seed
-- math.randomseed(os.time())

-- add 20 rectangular obstacles
for i = 1, 20 do
    set_coord = math.random()
    obstacles[i] = {
        x = math.random(0, 288),
        y = math.random(0, 160),
        w = (math.random(10, 100)*set_coord)//1,
        h = (math.random(10, 100)*(1-set_coord))//1
    }
end

home = {x = 250, y = 20, r = 10}

ants = {}
maxspeed = 1
-- add 20 ants centered around x = 250, y = 20, maxspeed = 1
for i = 1, 100 do
    ants[i] = {
        x = math.random(250, 288),
        y = math.random(0, 20),
        speed = maxspeed,
        direction = math.random() * math.pi * 2,
        r = 1
    }
end

-- collision detection between circle and rectangle, return angle of reflection
function circleRectangleCollision(circle, rectangle)
    local circleDistanceX = math.abs(circle.x - rectangle.x - rectangle.w/2)
    local circleDistanceY = math.abs(circle.y - rectangle.y - rectangle.h/2)

    if circleDistanceX > (rectangle.w/2 + circle.r) then return false end
    if circleDistanceY > (rectangle.h/2 + circle.r) then return false end

    if circleDistanceX <= (rectangle.w/2) then return 0 end
    if circleDistanceY <= (rectangle.h/2) then return 0 end

    local cornerDistance_sq = (circleDistanceX - rectangle.w/2)^2 + (circleDistanceY - rectangle.h/2)^2

    return math.atan(circleDistanceY - rectangle.h/2, circleDistanceX - rectangle.w/2)
end



food = {}
-- add 20 food
for i = 1, 1 do
    food[i] = {
        x = math.random(0, 288),
        y = math.random(0, 160),
        hasfood = 10 -- radius of 10
    }
end

function nearbyPheromones(ant, distance, lookForFood)
    local pheromones = {}
    for i = 1, #pheromones do
        local p = pheromones[i]
        if (lookForFood and p.hasfood) or (not lookForFood and not p.hasfood) then
            local dx = p.x - ant.x
            local dy = p.y - ant.y
            local d = math.sqrt(dx * dx + dy * dy)
            if d < distance then
                table.insert(pheromones, p)
            end
        end
    end
    return pheromones
end
ticks = 0
pheromones = {}

function update(ant)
    -- leave a pheromone trail every 30 ticks
    if ticks % 30 == 0 then
        table.insert(pheromones, {
            x = ant.x,
            y = ant.y,
            age = ticks,
            hasfood = ant.hasfood
        })
    end

    -- check for food
    for i = 1, #food do
        if math.sqrt((ant.x - food[i].x)^2 + (ant.y - food[i].y)^2) < food[i].hasfood and not ant.hasfood then
            ant.hasfood = true
            food[i].hasfood = food[i].hasfood - 1
        end
    end

    -- move
    ant.x = ant.x + ant.speed * math.cos(ant.direction)
    ant.y = ant.y + ant.speed * math.sin(ant.direction)

    -- turn
    ant.direction = ant.direction + math.random()/5 - 0.1

    -- check for collisions
    for i = 1, #obstacles do
        local ang = circleRectangleCollision(ant, obstacles[i])
        if ang then
            ant.direction = ant.direction - ang
        end
    end

    -- check if ant is outside of the screen
    if ant.x < 0 or ant.x > 288 or ant.y < 0 or ant.y > 160 then
        ant.direction = ant.direction + math.pi
    end

    -- if ant is home
    if math.sqrt((ant.x - home.x)^2 + (ant.y - home.y)^2) < home.r then
        ant.hasfood = false
    end

    -- look for pheromones
    local pheromones = nearbyPheromones(ant, 30, not ant.hasfood)
    if #pheromones > 0 then
        -- weigh pheromones by distance and age, calculate the average direction
        local sum = 0
        local sumAge = 0
        for i = 1, #pheromones do
            local p = pheromones[i]
            local dx = p.x - ant.x
            local dy = p.y - ant.y
            local d = math.sqrt(dx * dx + dy * dy)
            local age = ticks - p.age
            sum = sum + (1 / d) * (1 / age)
            sumAge = sumAge + (1 / age)
        end
        ant.direction = ant.direction + sum / sumAge
    end



end

function onTick()
    ticks = ticks + 1
    for i = 1, #ants do
        update(ants[i])
    end

    -- remove old pheromones
    for i = #pheromones, 1, -1 do
        if ticks - pheromones[i].age > 200 then
            table.remove(pheromones, i)
        end
    end
end

function onDraw()

    -- draw home
    screen.setColor(90, 0, 90)
    screen.drawCircle(home.x, home.y, home.r)
    -- draw the obstacles
    for i = 1, #obstacles do
        local o = obstacles[i]
        screen.setColor(100, 100, 100)
        screen.drawRectF(o.x, o.y, o.w, o.h)
    end

    -- draw the ants
    for i = 1, #ants do
        local a = ants[i]
        screen.setColor(0, 0, 100)
        if a.hasfood then -- orange
            screen.setColor(0, 100, 50)
        end
        screen.drawCircleF(a.x, a.y, 2)
    end

    -- draw the food
    for i = 1, #food do
        local f = food[i]
        screen.setColor(100, 100, 0)
        screen.drawCircleF(f.x, f.y, f.hasfood)
    end

    -- draw the pheromones
    for i = 1, #pheromones do
        local p = pheromones[i]
        screen.setColor(0, 0, 50, (p.age - ticks) * 255 / 600)
        if p.hasfood then -- orange
            screen.setColor(0, 100, 50, (p.age - ticks) * 255 / 600)
        end
        screen.drawCircleF(p.x, p.y, 1)
    end
end