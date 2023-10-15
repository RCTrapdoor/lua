file = {}
dc={}
dex = 1
dwnlen = 0
scale = {x=1,y=1,z=1}
center = {x=0,y=0,z=0}
gu = {{-5,-5,5},{5,-5,5},{5,5,5},{5,-5,5},{5,-5,-5},{5,-5,5}}
function clickin(x, y, rectX, rectY, rectW, rectH)
	return x > rectX and y > rectY and x < rectX+rectW and y < rectY+rectH
end
function car2pol(coordinate_list)
    x=coordinate_list[1]
    y=coordinate_list[2]
    return {math.sqrt(x^2+y^2), math.deg(math.atan(y,x))}
end
function pol2car(coordinate_list)
    r=coordinate_list[1]
    a=math.rad(coordinate_list[2])
    return {r*math.cos(a), r*math.sin(a)}
end
function rotate(points, degrees, gimbal, axis)
	ans = {}
	for point = 1, #points, 1 do
		xr = points[point][1]
		yr = points[point][2]
		zr = points[point][3]
		if (axis[1] == 1) then polar = car2pol({yr-gimbal[2], zr-gimbal[3]}) end
		if (axis[2] == 1) then polar = car2pol({xr-gimbal[1], zr-gimbal[3]}) end
		if (axis[3] == 1) then polar = car2pol({xr-gimbal[1], yr-gimbal[2]}) end
		r = polar[1]
		a = polar[2] + degrees
		i = pol2car({r, a})
		if (axis[1] == 1) then ans[point] = {xr, i[1]+gimbal[2], i[2]+gimbal[3]} end
		if (axis[2] == 1) then ans[point] = {i[1]+gimbal[1], yr, i[2]+gimbal[3]} end
		if (axis[3] == 1) then ans[point] = {i[1]+gimbal[1], i[2]+gimbal[2], zr} end
	end
	return ans
end

function onTick()
	w,h = input.getNumber(1), input.getNumber(2)
	mus = {x=input.getNumber(3), y=input.getNumber(4)}
	vrot = input.getNumber(5)*180
	hrot = input.getNumber(6)*180
	zoom = (input.getNumber(7)+1.7)^10
	pressed = input.getBool(1)
	index = input.getNumber(29)
	
	if index > dwnlen then dwnlen=dwnlen+1 end
	
	if not last and pressed and clickin(mus.x,mus.y, 1,1,23,10) then
		rx=true
		file={}
		dex=1
		dwnlen=0
	end
	
	if rx then
		if index == dex then
			table.insert(file, {x=input.getNumber(30),y=input.getNumber(31),z=input.getNumber(32)})
			dex=dex+1
		elseif index < dex and dex > 1 then
			rx = false
			roof={0,0,0}
			floor={0,0,0}
			for i=1,#file,1 do
				roof[1] = math.max(roof[1], file[i].x)
				roof[2] = math.max(roof[2], file[i].y)
				roof[3] = math.max(roof[3], file[i].z)
				floor[1] = math.min(roof[1], file[i].x)
				floor[2] = math.min(roof[2], file[i].y)
				floor[3] = math.min(roof[3], file[i].z)
			end

			center = {x=0,y=0,z=0}
			for k,v in ipairs(file) do
				center.x = center.x+v.x
				center.y = center.y+v.y
				center.z = center.z+v.z
			end
			center.x = center.x/#file
			center.y = center.y/#file
			center.z = center.z/#file
			roof = {roof[1]-center.x,roof[2]-center.y,roof[3]-center.z}
			--scale = {x=w/2/(roof[1]-floor[1]), y=h/2/(roof[2]-floor[2]), z=h/2/(roof[3]-floor[3])}
		end

	dc = {}
	for i=1,#file,1 do
		table.insert(dc, {center.x-file[i].x,center.y-file[i].y,center.z-file[i].z})
	end
	center = {x=0,y=0,z=0}
	last = pressed
	end
end

function onDraw()
	screen.setColor(255, 0, 255)
	screen.drawText(2,30, vrot)
	if #dc > 0 then
		dwg = rotate(dc,vrot,{0,0,0},{1,0,0})
		dwg = rotate(dwg,hrot,{0,0,0},{0,1,0})
		cgu = rotate(gu,vrot,{0,0,0},{1,0,0})
		cgu = rotate(cgu,hrot,{0,0,0},{0,1,0})
		for i=1,#cgu-1,1 do
    		screen.drawLine(15+cgu[i][1], h-15+cgu[i][2], 15+cgu[i+1][1], h-15+cgu[i+1][2])
		end
		screen.drawText(15+cgu[1][1],h-15+cgu[1][2], "Y")
		screen.drawText(15+cgu[3][1],h-15+cgu[3][2], "X")
		screen.drawText(15+cgu[5][1],h-15+cgu[5][2], "Z")
	end
	if rx then
		if dex == 1 then
			screen.drawText(25,4, string.format('Synching: %.0f',index))
		else
			screen.drawText(25,4, "Downloading...")
			screen.drawText(25,8, string.format('TX: %.0f',dwnlen))
			screen.drawText(25,12, string.format('RX: %.0f',#file))
		end
	end

	screen.setColor(255, 255, 255)
	screen.drawRectF(1,1,23,10)
	screen.setColor(0, 0, 0)
	screen.drawText(3,4,"File")

	screen.setColor(255, 255, 255)
	if #dc > 0 then
		screen.setColor(255, 0, 0)
		screen.drawCircle(w/2+center.x,h/2+center.y,4)
		screen.setColor(255, 255, 255)
	end
	if not rx and #file > 1 then
		for k,v in ipairs(dwg) do
			screen.drawCircleF(w/2+(v[1])*scale.x*zoom, h/2+(v[2])*scale.y*zoom,0.5)
		end
	end
end