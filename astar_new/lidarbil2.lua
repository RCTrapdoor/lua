nums = {}

ticks = 0
zoom = 0.05
binsize = 0.5

map_ = {}
w = 288
h = 160
ppm = w/(zoom*1000)
factor = (zoom*1000)/2

function round(a) return a-a%binsize end
setC = screen.setColor
f = math.floor
function plot(x,y,c) setC(0, 0, 0, c*255) screen.drawLine(x, y, x, y+1) end
function fpart(x) return x-f(x) end
function rfpart(x) return 1-fpart(x) end
function rot(iM,t)
	local m = {}
	sinT = math.sin(t)
	cosT = math.cos(t)
	for k,n in ipairs(iM) do
		m[k] = {x = n.x*cosT-n.y*sinT,y = n.y*cosT+n.x*sinT}
	end
	return m
end

mod = {{x = -ppm/2, y = ppm}, {x = -ppm/2, y = -ppm}, {x = ppm/2, y = -ppm}, {x = ppm/2, y = ppm}}

function m2s(mapX, mapY, zoom, screenWidth, screenHeight, worldX, worldY)
return f((screenWidth/2) + (ppm * (worldX - mapX))), f((screenHeight/2) + (ppm * (-worldY + mapY)))
end

function vecSub(a, b) -- Vector from a to b
	return { x = b.x - a.x, y = b.y - a.y }
end

function vecDist(a)
	return (a.x ^ 2 + a.y ^ 2) ^ 0.5
end

pi = math.pi
tau = pi * 2

function line(x0,y0,x1,y1)local steep=math.abs(y1-y0)>math.abs(x1-x0)if steep then
	x0,x1=x1,x0
	y0,y1=y1,y0
	end
	if x0>x1 then
	x0,x1=x1,x0
	y0,y1=y1,y0
	end
	dx,dy=x1-x0,y1-y0
	g=dx==0 and 1 or dy/dx
	xend=round(x0)yend=y0+g*(xend-x0)xgap=rfpart(x0+.5)xpxl1=xend
	ypxl1=f(yend)if steep then
	plot(ypxl1,xpxl1,rfpart(yend)*xgap)plot(ypxl1+1,xpxl1,fpart(yend)*xgap)else
	plot(xpxl1,ypxl1,rfpart(yend)*xgap)plot(xpxl1,ypxl1+1,fpart(yend)*xgap)end
	i=yend+g
	xend=round(x1)yend=y1+g*(xend-x1)xgap=fpart(x1+.5)xpxl2=xend
	ypxl2=f(yend)if steep then
	plot(ypxl2,xpxl2,rfpart(yend)*xgap)plot(ypxl2+1,xpxl2,fpart(yend)*xgap)else
	plot(xpxl2,ypxl2,rfpart(yend)*xgap)plot(xpxl2,ypxl2+1,fpart(yend)*xgap)end
	if steep then
	for x=xpxl1+1,xpxl2-1 do
	plot(f(i),x,rfpart(i))plot(f(i)+1,x,fpart(i))i=i+g
	end
	else
	for x=xpxl1+1,xpxl2-1 do
	plot(x,f(i),rfpart(i))plot(x,f(i)+1,fpart(i))i=i+g
	end
	end
	end
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
	--g_dist = {x=(dist.x-dist.x%binsize)/binsize,y=(dist.y-dist.y%binsize)/binsize}
	g_dist = {x=round(dist.x)/binsize,y=round(dist.y)/binsize}
	
	
	--if dist.y ~= 0 and dist.x ~= 0 and gps.y ~= 0 and gps.x ~= 0 and math.abs(dist.x) < 100000 and math.abs(dist.y) < 100000 and vecDist(vecSub(gps, dist)) > 0.25 then
	if ticks > 10 then
		if not map_[g_dist.x] then
			map_[g_dist.x] = {}
		end
		
		line(g_gps.x/binsize, g_gps.y/binsize, g_dist.x, g_dist.y)
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
	
	setC(100, 140, 100)
	screen.drawClear()

	
	for i = -factor-binsize, factor+binsize, binsize do
		for j = -factor-binsize, factor+binsize, binsize do
			setC(0, 0, 0)
			if map_[(g_gps.x+i)/binsize] and map_[(g_gps.x+i)/binsize][(g_gps.y+j)/binsize] then
				setC(0, 0, 0, map_[(g_gps.x+i)/binsize][(g_gps.y+j)/binsize])
			end
			px, py = m2s(gps.x, gps.y, zoom, w, h, g_gps.x + i+binsize/2, g_gps.y + j+binsize/2)
			screen.drawRectF(px, py, ppm * binsize, ppm * binsize+1)
		end
	end
	setC(0, 0, 0)
	model = rot(mod, -compass2)
	for i = 1, #model do
		screen.drawLine(w/2+model[i].x, h/2+model[i].y, w/2+model[i%#model+1].x, h/2+model[i%#model+1].y)
	end
	x1, y1 = -math.sin(compass) * 10, -math.cos(compass) * 10
	x2, y2 = -math.sin(compass) * ppm, -math.cos(compass) * ppm
	screen.drawLine(w/2 + x1, h/2 + y1, w/2 + x2, h/2 + y2)
	setC(255, 0, 0)
end