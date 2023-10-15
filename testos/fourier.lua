---@section simulator
simulator:setScreen(1, "9x5")
---@endsection
w,_ENV["255"] = 288, 160

function add(a, b)
    return {x = a.x + b.x, y = a.y + b.y}
end

function pol2car(r, theta)
    return {x = r*math.cos(theta), y = r*math.sin(theta)}
end

vecs = {}
vecs[1] = {start = {x = w/2, y = _ENV["255"]/2}, ang = math.pi/3, rate = 0.5, radius = 40, tail = {x = 0, y = 0}}
math.randomseed(os.time())
for i = 2, 15 do
    table.insert(vecs, {start = vecs[i - 1].tail, ang = math.random() * 2 * math.pi, rate = -vecs[i - 1].rate*math.random()*4, radius = vecs[i - 1].radius * math.random() * 2, tail = {x = 0, y = 0}})
end

history = {}

function onTick()
    for i = 1, #vecs do

        if i > 1 then
            vecs[i].start = vecs[i - 1].tail
        end

        vecs[i].ang = vecs[i].ang + vecs[i].rate / 30

        vecs[i].tail = add(vecs[i].start, pol2car(vecs[i].radius, vecs[i].ang))
    end
    table.insert(history, vecs[#vecs].tail)
    while #history >= 1200 do
        table.remove(history, 1)
    end
end

function onDraw()
    screen.setColor(200, 200, 200)
    for i = 1, #history - 1 do
       screen.drawLine(history[i].x, history[i].y, history[i + 1].x, history[i + 1].y)
    end
    screen.setColor(40, 40, 40, 100)
    for k,v in ipairs(vecs) do
        screen.drawCircle(v.start.x, v.start.y, v.radius)
    end
    screen.setColor(130, 130, 130, 150)
    for k,v in ipairs(vecs) do
        screen.drawLine(v.start.x, v.start.y, v.tail.x, v.tail.y)
    end
end
