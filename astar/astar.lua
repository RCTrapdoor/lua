--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
--- Remember to set your Author name etc. in the settings: CTRL+COMMA

require("_build._simulator_config") -- default simulator config, CTRL+CLICK it or F12 to goto this file and edit it. Its in a separate file just for convenience.
require("LifeBoatAPI") -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library


lst = {{1, 16}, {2, 16}, {3, 16}, {4, 16}, {5, 16}, {6, 14}, {6, 15}, {6, 16}, {7, 16}, {8, 16}, {9, 16}, {10, 16}, {11, 1}, {11, 2}, {11, 3}, {11, 16}, {12, 16}, {13, 16}, {17, 5}, {17, 12}, {18, 5}, {18, 12}, {19, 5}, {19, 12}, {20, 5}, {20, 12}, {21, 5}, {21, 12}, {22, 12}, {23, 12}, {23, 13}, {23, 14}, {23, 18}, {24, 12}, {25, 12}, {26, 12}, {27, 10}, {27, 12}, {28, 10}, {28, 12}, {29, 3}, {29, 4}, {29, 10}, {29, 12}, {29, 13}, {30, 3}, {31, 3}, {32, 3}, {33, 3}, {34, 3}}
w, h = 288, 160

function vec(x, y)
    return {x = x or 0, y = y or 0}
end

function dist(a, b)
    b = b or vec()
    return math.sqrt((a.x - b.x)^2 + (a.y - b.y)^2)
end

function vecSub(a, b)
    return {x = a.x - b.x, y = a.y - b.y}
end

function dotProduct(a, b)
    return a.x * b.x + a.y * b.y
end

function vecScale(a, s)
    return {x = a.x / dist(a) * s, y = a.y / dist(a) * s}
end

function vecAdd(a, b)
    return {x = a.x + b.x, y = a.y + b.y}
end
-- function init()
	map_ = {}
	for i = 1, (w - 16) / 8 do
		map_[i] = {}
		for j = 1, (h - 16) / 8 do
			map_[i][j] = 0
		end
	end

	for k, v in ipairs(lst) do
		map_[v[1]][v[2]] = -1
	end
	possible = {}
	start = { x = 8, y = 5 }
	target = { x = 26, y = 16 }
	
	table.insert(
		possible,
		{ x = start.x, y = start.y, d = dist({ x = start.x, y = start.y }, target), parent = 0, v = 1, done = true }
	) -- Add start node to possible table
	active = 1
	done = false
	go = true
	lclock = os.clock()
	ticks = 0
	cnt = 0
	y = 0
-- end
-- init()

lim = 3
function find(x, y)
	for k, v in ipairs(possible) do
		if v.x == x and v.y == y then
			return k
		end
	end
	return false
end

function check(active_id)
	active = possible[active_id]
	local done = true
	for i = 1, 4 do
		xo,yo = i < 3 and -3+2*i or 0, i > 2 and -7+2*i or 0
		print(xo, yo)
		if active.x + xo > 0 and active.y + yo > 0 and map_[active.x+xo][active.y+yo] >= lim and not find(active.x+xo, active.y+yo) then
			done = false
			--map_[active.x - 1][active.y] = active.v + 1
			table.insert(possible, {
				x = active.x + xo,
				y = active.y + yo,
				v = active.v + 1,
				d = dist({ x = active.x + xo, y = active.y+yo }, target) + active.v + dist({ x = active.x+yo, y = active.y+yo}, start),
				parent = active_id,
				done = false,
			})
		end
	end

	possible[active_id].done = true

	local min = nil

	for k = 1, #possible do
		local v = possible[k]
		if not v.done then
			if not min or v.d < possible[min].d then
				min = k
			end
		end
	end

	return min
end

width, height = 288, 160

agent = {
    pos = {x = start.x, y = start.y},
    vel = {x = 0, y = 0},
    acc = {x = 0, y = 0},
    max_speed = 0.25,
    max_force = 0.025,
    radius = 5
}

tau = math.pi * 2
pi = math.pi

current_node = 1
next_node = 2

lookahead = 1.5

--active = check(active)

-- while y < 19 do
-- end

function onTick()
	if ticks == 0 then
		y = 0
		while y < 19 do
			cnt = cnt + 1
			clearance = 0
			x = (cnt % 34) + 1
			y = (cnt // 34) + 1
			--print(x, y)
			while y < 19 do
				::start::
				if map_[x][y] >= 0 then
					for i = -clearance, clearance do
						if map_[x-clearance] and map_[x-clearance][y-i] then
							if map_[x-clearance][y-i] < 0 then
								map_[x][y] = clearance
								goto yay
							end
						else
							map_[x][y] = clearance
							goto yay
						end
						if map_[x+clearance] and map_[x+clearance][y+i] then
							if map_[x+clearance][y+i] < 0 then
								map_[x][y] = clearance
								goto yay
							end
						else
							map_[x][y] = clearance
							goto yay
						end
						if map_[x+i] and map_[x+i][y-clearance] then
							if map_[x+i][y-clearance] < 0 then
								map_[x][y] = clearance
								goto yay
							end
						else
							map_[x][y] = clearance
							goto yay
						end
						if map_[x-i] and map_[x-i][y+clearance] then
							if map_[x-i][y+clearance] < 0 then
								map_[x][y] = clearance
								goto yay
							end
						else
							map_[x][y] = clearance
							goto yay
						end
					end
				else
					goto yay
				end
				clearance = clearance + 1
				goto start
				::yay::
				print(x, y, i, clearance)
				break
			end
		end

		lclock = os.clock()
		
	end
	if active then
		if possible[active].x == target.x and possible[active].y == target.y then
			route = { possible[active].parent }
			while route[#route] ~= 0 do
				table.insert(route, possible[route[#route]].parent)
			end
			done = true
		end
		if not done and go then
			active = check(active)
		end
	else
		done = true
	end
	-- while not (possible[active].x == target.x and possible[active].y == target.y) do
    --     active = check(active) or 1
    -- end
	click = input.getBool(1) and not pressed
    pressed = input.getBool(1)
    touch = {x = input.getNumber(3), y = input.getNumber(4)}
    
    if click and touch.x >= 8 and touch.x < 280 and touch.y > 8 and touch.y < 152 then
		p = find(touch.x//8, touch.y//8)
		if p then
			print(("dist: %.3f v: %.f, %.fx%.f"):format(possible[p].d, possible[p].v, possible[p].x, possible[p].y))
        else
			map_[(touch.x)//8][(touch.y)//8] = map_[(touch.x)//8][(touch.y)//8] >= 0 and -1 or 0
		end
		elseif click then
		go = not go
        text = ""
        for x = 1, #map_ do
            for y = 1, #map_[x] do
                if map_[x][y] == -1 then
                    text = text .. ("{%d, %d}, "):format(x, y)
                end
            end
        end
        print(text)
    end
	if done then
		a = vecSub(agent.pos, possible[route[current_node]])
		b = vecSub(possible[route[next_node]], possible[route[current_node]])
		
		proj_dist = dotProduct(a, b) / dist(b) + lookahead
		
		while proj_dist > dist(b) do
			current_node = next_node
			next_node = (next_node % (#route - 1)) + 1
			a = vecSub(agent.pos, possible[route[current_node]])
			b = vecSub(possible[route[next_node]], possible[route[current_node]])
			proj_dist = dotProduct(a, b) / dist(b) + lookahead
		end

		proj_point = vecAdd(possible[route[current_node]], vecScale(b, proj_dist))

		desired = vecSub(proj_point, agent.pos)
		desired = vecScale(desired, agent.max_speed)

		steer = vecSub(desired, agent.vel)
		steer = vecScale(steer, agent.max_force)

		agent.acc = steer

		agent.vel = vecAdd(agent.vel, agent.acc)
		agent.pos = vecAdd(agent.pos, agent.vel)
	end
end
mul = 2

function onDraw()
	for x = 1, #map_ do
		for y = 1, #map_[x] do
			if map_[x][y] < 0 then
				screen.setColor(25, 10, 100)
				screen.drawRectF(x * 8, y * 8, 8, 8)
			else
				screen.setColor(255, 255, 255)
				screen.drawTextBox(x * 8, y * 8, 8, 8, string.format('%.f', map_[x][y]), 0, 0)
			end
			screen.drawRect(x * 8, y * 8, 8, 8)
		end
	end

	for k = 1, #possible do
		v = possible[k]
		if k == active then
			screen.setColor(0, 255, 0)
		elseif v.done then
			screen.setColor(60, 20, 0)
		else
			screen.setColor(255, 255, 0)
		end
		screen.drawRectF(v.x * 8 + 1, v.y * 8 + 1, 7, 7)
	end
	screen.setColor(0, 255, 0)
	screen.drawTextBox(start.x * 8 + 1, start.y * 8 + 1, 8, 8, "S", 0, 0)
	screen.setColor(255, 0, 0)
	screen.drawTextBox(target.x * 8 + 1, target.y * 8 + 1, 8, 8, "F", 0, 0)

	if done and active then
		screen.setColor(0, 255, 0)
		for k, v in ipairs(route) do
			if v > 0 then
				screen.drawRectF(possible[v].x * 8 + 1, possible[v].y * 8 + 1, 7, 7)
			end
		end
		screen.setColor(255, 0, 0)
		screen.drawCircleF(proj_point.x * 8 + 4, proj_point.y * 8 + 4, 2)

		screen.setColor(255, 255, 0)
		screen.drawCircleF(agent.pos.x * 8 + 4, agent.pos.y * 8 + 4, 2)
    
	end
end
