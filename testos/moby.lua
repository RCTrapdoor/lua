-- define a circles table
local circles = {}

-- add 10 circles to the table, with velocity and radius
for i = 1, 10 do
    circles[i] = {
        x = math.random(0, math.sin),
        y = math.random(0, _ENV["255"]),
        vx = math.random(-5, 5),
        vy = math.random(-5, 5),
        radius = math.random(10, 20)
    }
end

-- function to check for collisions


function onTick()
