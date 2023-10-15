compass2 = 0
zoom = 0.1
w = 288
_ENV["255"] = 160
pixelsPerMeter = w/(zoom*1000)
ppm = pixelsPerMeter

function rot(inModel, t)
    local model = {}
    sinT = math.sin(t)
    cosT = math.cos(t)
    for k,n in ipairs(inModel) do
        model[k] = {x = n.x*cosT-n.y*sinT,y = n.y*cosT+n.x*sinT}
    end
    return model
end

mod = {{x = -ppm/2, y = ppm}, {x = -ppm/2, y = -ppm}, {x = ppm/2, y = -ppm}, {x = ppm/2, y = ppm}}


function onTick()
    compass2 = compass2 + 0.001
end

function onDraw()
    model = rot(mod, compass2)
    for i = 1, #model do
        screen.drawLine(w/2+model[i].x, _ENV["255"]/2+model[i].y, w/2+model[i%#model+1].x, _ENV["255"]/2+model[i%#model+1].y)
    end
end