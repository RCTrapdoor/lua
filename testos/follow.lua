agent = {pos = {x = 20, y = 20}, vel = {x = 0.5, y = 0.25}, acc = {x = 0, y = 0.01}, r = 5}

maxspeed = 1.5
maxforce = 0.75
look_ahead = 0.25
circle = 40

function normalize(vec)
    local mag = (vec.x^2 + vec.y^2)^0.5
    return {x = vec.x / mag, y = vec.y / mag}
end

function add(vec1, vec2)
    return {x = vec1.x + vec2.x, y = vec1.y + vec2.y}
end

function limit(vec, limit)
    local mag = math.min((vec.x^2 + vec.y^2)^0.5, limit)
    return mult(normalize(vec), mag)
end

function sub(vec1, vec2)
    return {x = vec1.x - vec2.x, y = vec1.y - vec2.y}
end

function mult(vec, mul)
    return {x = vec.x * mul, y = vec.y * mul}
end

proj = {x = 1, y = 1}
target = {x = 100, y = 100}

function onTick()
    if input.getBool(1) then
        target = {x = input.getNumber(3), y = input.getNumber(4)}
    end
    
    force = {x = 0, y = 0}
    desired = mult(normalize(sub(proj, agent.pos)), maxspeed)
    steer = limit(sub(desired, agent.vel), maxforce)
    agent.acc = add(agent.acc, steer)
    agent.vel = add(agent.vel, agent.acc)
    agent.vel = limit(agent.vel, maxspeed)
    agent.pos = add(agent.pos, agent.vel)
    agent.acc = mult(agent.acc, 0)
    
    theta = math.atan(agent.pos.y - target.y, agent.pos.x - target.x) + look_ahead
    proj = {x = target.x + circle * math.cos(theta), y = target.y + circle * math.sin(theta)}
end

function onDraw()
    heading = math.atan(agent.vel.y, agent.vel.x)
    screen.drawTriangle(agent.pos.x + agent.r * math.cos(heading) * 2, agent.pos.y + agent.r * math.sin(heading) * 2, 
        agent.pos.x + agent.r * math.cos(heading+2.5), agent.pos.y + agent.r * math.sin(heading+2.5),
        agent.pos.x + agent.r * math.cos(heading-2.5), agent.pos.y + agent.r * math.sin(heading-2.5))
    screen.setColor(0, 0, 100)

    screen.drawCircleF(proj.x, proj.y, 3)
    screen.setColor(150, 150, 150)
    screen.drawCircle(target.x, target.y, circle)
end