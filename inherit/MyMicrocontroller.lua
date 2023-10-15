waypoint = {}

function clone(struct)
	local item = {}
	for k,v in pairs(struct) do
		item[k] = v
	end
	return item
end

function waypoint.new(screenX, screenY)
	local self = clone(waypoint)
	self.screenX = screenX
	self.screenY = screenY
	self.drawRadius = 5
	x, y = map.mapToScreen(mapX, mapY, zoom, w, h, screenX, screenY)
	self.x = x
	self.y = y
	return self
end

function waypoint.add(screenX, screenY)
	local self = clone(waypoint)
	self.screenX = screenX
	self.screenY = screenY
	self.drawRadius = 5
	self.x = x
	self.y = y
	return self
end

mapX, mapY = 0, 0
zoom = 1
w, h = 288, 160

waypoints = waypoint.new(100, 100)

print(waypoints)