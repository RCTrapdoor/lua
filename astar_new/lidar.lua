nums = {}

ticks = 0
zoom = 0.05
binsize = 0.5

map_ = {}
w = 288
h = 160
pixelsPerMeter = w/(zoom*1000)
ppm = pixelsPerMeter
factor = (zoom*1000)/2

function round(a)
	return (a-a%binsize)
end

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

function map.mapToScreen(mapX, mapY, zoom, screenWidth, screenHeight, worldX, worldY)
return math.floor((screenWidth/2) + (pixelsPerMeter * (worldX - mapX))), math.floor((screenHeight/2) + (pixelsPerMeter * (-worldY + mapY)))
end

function vecSub(a, b) -- Vector from a to b
    return { x = b.x - a.x, y = b.y - a.y }
end

function vecDist(a)
    return (a.x ^ 2 + a.y ^ 2) ^ 0.5
end

function m(n,o,p,q)local r=p-n
local s=q-o
local t=1
if s<0 then
t=-1
s=-s
end
local u=(2*s)-r
local f=o
for e=n,p-1 do
if not map_[e]then map_[e]={}end
if not(e==p and f==q)then
map_[e][f]=math.max(0,map_[e][f]and map_[e][f]-10 or 0)end
if u>0 then
f=f+t
u=u+(2*(s-r))else
u=u+2*s
end
end
end
function v(n,o,p,q)local r=p-n
local s=q-o
local w=1
if r<0 then
w=-1
r=-r
end
local u=(2*r)-s
local e=n
for f=o,q-1 do
if not map_[e]then map_[e]={}end
if not(e==p and f==q)then
map_[e][f]=math.max(0,map_[e][f]and map_[e][f]-10 or 0)end
if u>0 then
e=e+w
u=u+(2*(r-s))else
u=u+2*r
end
end
end
function plot(n,o,p,q)if math.abs(q-o)<math.abs(p-n)then
if n>p then
m(p,q,n,o)else
m(n,o,p,q)end
else
if o>q then
v(p,q,n,o)else
v(n,o,p,q)end
end
end

pi = math.pi
tau = pi * 2


function onTick()
	ticks = ticks + 1
	
	for i = 1, 32 do
		nums[i] = input.getNumber(i)
	end
	
	compass = nums[3]*math.pi*2
	compass2 = nums[6]*math.pi*2
	gps = {x = nums[1], y = nums[2]}
	g_gps = {x = round(gps.x), y = round(gps.y)}
	to = {x = -11000, y = -8000} -- target
	
	for i = 8, 12, 2 do
	dist = {x = nums[i], y = nums[i+1]}
	g_dist = {x=round(dist.x)/binsize,y=round(dist.y)/binsize}
	

	if ticks > 10 then
		if not map_[g_dist.x] then
			map_[g_dist.x] = {}
		end
		
		plot(g_gps.x/binsize, g_gps.y/binsize, g_dist.x, g_dist.y)
		map_[g_dist.x][g_dist.y] = math.min(255, map_[g_dist.x][g_dist.y] and map_[g_dist.x][g_dist.y] + 125 or 255)
	end
	end
	vector = vecSub(gps, to)

	heading = math.atan(-vector.x, vector.y)

	deltaHeading = (((heading - compass)/tau)%1+1.5)%1-0.5
	throttle = vecDist(vector)
	
	output.setNumber(2, throttle/5)
	output.setNumber(3, -deltaHeading*2)
	
		
end

function onDraw()
	w,h = screen.getWidth(), screen.getHeight()
	
	screen.setColor(100, 140, 100)
	screen.drawClear()

	
    for i = -factor-binsize, factor+binsize, binsize do
        for j = -factor-binsize, factor+binsize, binsize do
            screen.setColor(0, 0, 0)
            if map_[(g_gps.x+i)/binsize] and map_[(g_gps.x+i)/binsize][(g_gps.y+j)/binsize] then
                screen.setColor(0, 0, 0, map_[(g_gps.x+i)/binsize][(g_gps.y+j)/binsize])
            end
            px, py = map.mapToScreen(gps.x, gps.y, zoom, w, h, g_gps.x + i, g_gps.y + j)
            screen.drawRectF(px, py, ppm * binsize, ppm * binsize+1)
        end
    end
	screen.setColor(0, 0, 80)
	model = rot(mod, -compass2)
		screen.drawTriangleF(w/2+model[1].x, h/2+model[1].y, w/2+model[2].x, h/2+model[2].y, w/2+model[3].x, h/2+model[3].y)
		screen.drawTriangleF(w/2+model[1].x, h/2+model[1].y, w/2+model[3].x, h/2+model[3].y, w/2+model[4].x, h/2+model[4].y)
	x1, y1 = -math.sin(compass) * ppm*2, -math.cos(compass) * ppm*2
	screen.drawLine(w/2 + x1, h/2 + y1, w/2, h/2)
end