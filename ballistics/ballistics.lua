---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "9x5")
end
---@endsection

local muzzle_velocity = 600
local drag_coefficient = 0.0005
local gravity = 30
local ticks_per_second = 60

local max_iterations = 1000

function perp_dot(a, b)
    return a[2] * b[1] - a[1] * b[2]
end

function dist(a, b)
    return math.sqrt((a[1] - b[1]) ^ 2 + (a[2] - b[2]) ^ 2)
end

function findFiringSolution(initialVelocity, dragCoefficient, gravity, ticksPerSecond, horizontalDistance, verticalDistance)
    local function simulateProjectile(angle)
        local velocity = {initialVelocity * math.cos(angle), initialVelocity * math.sin(angle)} -- Initial velocity components
        local tickDuration = 1 / ticksPerSecond -- Duration of each tick
        local dragFactor = 1 - dragCoefficient -- Drag factor applied each tick

        local position = {0, 0} -- Initial position

        local max_iterations = 3600 -- Maximum number of iterations
        simul_iterations = 0 -- Current iteration

        while position[1] + velocity[1] / 60 < horizontalDistance and simul_iterations < max_iterations do -- Projectile is not past the target horizontally
            position[1] = position[1] + velocity[1] * tickDuration
            position[2] = position[2] + velocity[2] * tickDuration

            velocity[1] = velocity[1] * dragFactor -- Apply drag to x-axis velocity
            velocity[2] = velocity[2] * dragFactor -- Apply drag to y-axis velocity
            velocity[2] = velocity[2] - gravity * tickDuration -- Apply gravity to y-axis velocity

            simul_iterations = simul_iterations + 1 -- Increment iteration counter
        end

        return position[1], position[2], velocity[1], velocity[2] -- Final vertical position
    end

    local lowerAngle = -math.pi / 2 -- Initial lower angle
    local upperAngle = math.pi / 2 -- Initial upper angle

    local max_iterations = 100 -- Maximum number of iterations
    firing_iterations = 0 -- Current iteration

    while firing_iterations < max_iterations do
        local midAngle = (lowerAngle + upperAngle) / 2 -- Calculate mid angle

        local horizontalPos, verticalPos, horizontalSpeed, verticalSpeed = simulateProjectile(midAngle) -- Simulate projectile with mid angle

        local a = {horizontalDistance - horizontalPos, verticalDistance - verticalPos} -- Vector from projectile to target
        local b = {horizontalSpeed, verticalSpeed} -- Projectile velocity vector

        if math.abs(perp_dot(a, b) / dist({0, 0}, b)) < 5 then -- Projectile is past the target
            return midAngle, horizontalPos, verticalPos -- Found firing solution
        elseif verticalPos < verticalDistance then
            lowerAngle = midAngle -- Adjust lower angle
        else
            upperAngle = midAngle -- Adjust upper angle
        end

        firing_iterations = firing_iterations + 1 -- Increment iteration counter
    end
end

w, h, zoom = 288, 160, 20

cannon_pos = {0, 0, 0}
target_pos = {5000, 0, 0}
function onTick()
    cannon_pos = {input.getNumber(1), input.getNumber(2), input.getNumber(3)}
    target_pos = {input.getNumber(4), input.getNumber(5), input.getNumber(6)}

    isClick = input.getBool(1) and not isPress
    isPress = input.getBool(1)

    if isClick then
        tx, ty = map.screenToMap(cannon_pos[1], cannon_pos[2], zoom, w, h, input.getNumber(3), input.getNumber(4))
        target_pos = {tx, ty, 0}
    end

    horizontal_distance = ((target_pos[1] - cannon_pos[1])^2 + (target_pos[2] - cannon_pos[2])^2)^0.5
    vertical_distance = target_pos[3] - cannon_pos[3]

    if horizontal_distance < 7500 then
        required_angle, horizontalPos, verticalPos = findFiringSolution(muzzle_velocity, drag_coefficient, gravity, ticks_per_second, horizontal_distance, vertical_distance)
        if required_angle then
            angle = math.atan(target_pos[2] - cannon_pos[2], target_pos[1] - cannon_pos[1])
            x, y = math.cos(angle) * (horizontalPos), math.sin(angle) * (horizontalPos)
        end
    end
    output.setNumber(1, required_angle or 0)
end

function onDraw()
    screen.setColor(255, 255, 255)
    screen.drawMap(cannon_pos[1], cannon_pos[2], zoom)

    px, py = map.mapToScreen(cannon_pos[1], cannon_pos[2], zoom, w, h, cannon_pos[1], cannon_pos[2])
    screen.drawCircle(px, py, 2)

    px, py = map.mapToScreen(cannon_pos[1], cannon_pos[2], zoom, w, h, target_pos[1], target_pos[2])
    screen.drawCircle(px, py, 2)

    if not required_angle then
        screen.drawText(2, 2, "Target is out of range")
    else
        screen.drawText(2, 2, ("Required launch angle: %.2f radians"):format(required_angle))

        screen.drawText(2, 50, string.format("Horizontal position: %.2f", horizontalPos))
        screen.drawText(2, 60, string.format("Vertical position: %.2f", verticalPos))

        screen.drawText(2, 70, string.format("Horizontal error: %.2f", horizontalPos - horizontal_distance))
        screen.drawText(2, 80, string.format("Vertical error: %.2f", verticalPos - vertical_distance))

        screen.drawText(2, 110, string.format("Angle : %.2f", angle))

        screen.setColor(255, 0, 0)
        px, py = map.mapToScreen(cannon_pos[1], cannon_pos[2], zoom, w, h, cannon_pos[1] + x, cannon_pos[2] + y)
        screen.drawCircle(px, py, 2)

    end

    screen.setColor(255, 255, 255)

    screen.drawText(2, 90, string.format("Iterations: %d", simul_iterations))
    screen.drawText(2, 100, string.format("Firing iterations: %d", firing_iterations))

    screen.drawText(2, 10, string.format("   GPS: %6.f  x  %6.f  x  %6.f", cannon_pos[1], cannon_pos[2], cannon_pos[3]))
    screen.drawText(2, 20, string.format("Target: %6.f  x  %6.f  x  %6.f", target_pos[1], target_pos[2], target_pos[3]))

    screen.drawText(2, 30, string.format("Horizontal distance: %.2f", ((target_pos[1] - cannon_pos[1])^2 + (target_pos[2] - cannon_pos[2])^2)^0.5))
    screen.drawText(2, 40, string.format("Vertical distance: %.2f", target_pos[3] - cannon_pos[3]))

    screen.setColor(255, 0, 0)
    screen.drawLine(2, 1, 7, 2.5)
end