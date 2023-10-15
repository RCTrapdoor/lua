--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
--- Remember to set your Author name etc. in the settings: CTRL+COMMA

require("_build._simulator_config") -- default simulator config, CTRL+CLICK it or F12 to goto this file and edit it. Its in a separate file just for convenience.

FONT = property.getText("FONT1")..property.getText("FONT2")
FONT_D={}
FONT_S=0
for n in FONT:gmatch("....")do FONT_D[FONT_S+1]=tonumber(n,16)FONT_S=FONT_S+1 end
function dst(x,y,text,scale,rotation,m) scale=scale or 1
rotation=rotation or 1
if rotation>2 then text=text:reverse()end
text=text:upper()for letter in text:gmatch(".")do
ci=letter:byte()-31 if 0<ci and ci<=FONT_S then
for i=1,15 do
if rotation>2 then p=2^i else p=2^(16-i)end
if FONT_D[ci]&p==p then
xx,yy=((i-1)%3)*scale,((i-1)//3)*scale
if rotation%2==1 then screen.drawRectF(x+xx,y+yy,scale,scale)else screen.drawRectF(x+5-yy,y+xx,scale,scale)end
end
end
if FONT_D[ci]&1==1 and not m then
i=2*scale
else
i=4*scale
end
if rotation%2==1 then x=x+i else y=y+i end
end
end
end

function vecSub(b, a) -- Vector from a to b
	return { x = a.x - b.x, y = a.y - b.y }
end

function vecDist(a)
	return (a.x ^ 2 + a.y ^ 2) ^ 0.5
end

function vecScale(a, b)
	return { x = b * (a.x / vecDist(a)), y = b * (a.y / vecDist(a)) }
end

function vecProduct(a, b)
	return a.x * b.x + a.y * b.y
end

function scalarProj(a, b)
	return vecProduct(a, b) / (vecDist(a) * vecDist(b))
end

function vecAdd(a, b)
	return { x = a.x + b.x, y = a.y + b.y }
end

function sgn(a)
    return a > 0 and 1 or -1
end

tau = math.pi * 2
pi = tau / 2
angle_delta = 0

function onTick()
	gps = { x = input.getNumber(1), y = input.getNumber(2) }
	waypoint = { to = { x = 3673, y = -5589 }, from = { x = 4115, y = -6031 } }
	compass = -input.getNumber(5) * math.pi * 2
	altimeter = input.getNumber(6)

	line_vector = vecSub(waypoint.from, waypoint.to)
	you_vector = vecSub(waypoint.from, gps)

    proj_distance = scalarProj(you_vector, line_vector) * vecDist(you_vector)
    proj_point = vecAdd(waypoint.from, vecScale(line_vector, proj_distance))
    proj_vector = vecSub(gps, proj_point)
    proj_angle = math.atan(proj_vector.x, proj_vector.y)
    line_angle = (math.atan(line_vector.x, line_vector.y) / tau * 360 + 360) % 360
    dist_to_line = vecDist(proj_vector)
    angle_delta = ((proj_angle-compass+pi/2)%tau+pi*3)%tau-pi
    dots_factor = math.abs((dist_to_line/300)^(1/2)) --* sgn(proj_angle)
    dots_factor = dots_factor * (math.abs(angle_delta) > (pi/2) and 1 or -1)

end

function onDraw()
    w,h = screen.getWidth(), screen.getHeight()

    for i = w/2, w/2 + (w/2) * (-dots_factor), -sgn(dots_factor)*4 do
        screen.setColor(0, 255, 0)
        screen.drawRectF(i, 3, 2, 2)
    end

    screen.setColor(0, 0, 0)
    screen.drawRectF(w/2-2, 0, 4, h)

    screen.setColor(255, 0, 0)
    if proj_distance < 0 then
        for i = 1, math.min((-proj_distance / 100) * h, h), 4 do
            screen.drawRectF(w/2-1, i, 4, 2)
        end
    elseif proj_distance < vecDist(line_vector) then
        screen.setColor(0, 255, 0)
        for i = 1, math.min(((vecDist(line_vector)-proj_distance) / 100) * h, h), 4 do
            screen.drawRectF(w/2, i, 2, 2)
        end
    else
        for i = 1, h, 4 do
            screen.drawRectF(w/2-1, i, 4, 2)
        end
    end

    screen.setColor(255, 200, 0)
    for i = 10, w/2, 8 do
        screen.drawRectF(i, 9, 3, 3)
        screen.drawRectF(w - i-1, 9, 3, 3)
    end

    screen.setColor(255,0,0)
    dst(w-30, h-14, ("%3.0f%s"):format(math.min(999, dist_to_line),dots_factor < 0 and "R" or "L"), 2, 1, true)
    dst(2, h-14, ("%03.f"):format(line_angle), 2, 1, true)
end
