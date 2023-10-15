require("LifeBoatAPI")

function onTick()
	compass = -input.getNumber(1) * math.pi * 2 -- math.pi/2
	gps = LifeBoatAPI.LBVec:new(input.getNumber(2), input.getNumber(3))
	gps_target = LifeBoatAPI.LBVec:new(input.getNumber(4), input.getNumber(5))
    hdg = input.getNumber(6)

    delta = gps_target:lbvec_sub(gps)

    angle = delta:lbvec_angle2D()

    target_speed = delta:lbvec_rotate2D(compass):lbvec_normalize():lbvec_scale(math.max(-10, math.min(10, delta:lbvec_length()/10)))

    output.setNumber(1,target_speed.x/10)
    output.setNumber(2,(target_speed.y*1.5)/10)

    output.setNumber(3,delta:lbvec_length()>20 and-angle/(math.pi*2)or hdg)
end

function printTable(tab, depth)
    depth = depth or 0
    screen.setColor(255, 255, 255)
    filter = {"input", "table", "property", "string", "map", "screen", "async", "output", "debug", "math", "m"}

    for k,v in pairs(tab) do
        if i == 25 then
            screen.setColor(0, 0, 0)
            screen.drawRectF(144, 0, 144, 160)
        end
        screen.setColor(255, 255, 255)
        if type(v) == "number" or type(v) == "string" then
            screen.drawText((i//25)*144+2+depth*6*2, i%25*6, k..": "..v)
            i = i + 1
        elseif type(v) == "table" and depth <= 3 then
            local found = false
            for i = 1, #filter do
                if k == filter[i] then
                    found = true
                    break
                end
            end
            if not found then
                screen.drawText((i//25)*144+2+depth*6*2, i%25*6, "[" .. k .. "]")
                i = i + 1
                printTable(v, depth + 1)
            end
        end
    end
end

function onDraw()
    i = 0
    printTable(_ENV)
end