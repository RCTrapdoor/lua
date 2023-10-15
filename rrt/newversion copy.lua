-- require("_build._simulator_config")
require("LifeBoatAPI")

-- math.randomseed(os.time())

function ellipse(a, b, theta, phi)
	local sin, cos = { t = math.sin(theta), p = math.sin(phi) }, { t = math.cos(theta), p = math.cos(phi) }
	return { x = a * cos.t * cos.p - b * sin.t * sin.p, y = a * sin.t * cos.p + b * cos.t * sin.p }
end
function pointInEllipse(x, y, xp, yp, d, D, angle)
	local cosa, sina, dd, DD, a, b, ellipse
	cosa = math.cos(angle)
	sina = math.sin(angle)
	dd = d * d
	DD = D * D
	a = (cosa * (xp - x) + sina * (yp - y)) ^ 2
	b = (sina * (xp - x) - cosa * (yp - y)) ^ 2
	ellipse = (a / dd) + (b / DD)

	if ellipse <= 1 then
		return true
	end
	return false
end
function vecDist(a)
	return (a.x ^ 2 + a.y ^ 2) ^ 0.5
end
function vecSub(a, b) -- Vector from a to b
	return { x = b.x - a.x, y = b.y - a.y }
end
function vecAdd(a, b)
	return { x = b.x + a.x, y = b.y + a.y }
end
function angle(a)
	return math.atan(a.y, a.x)
end
function vecScale(a, b)
	return { x = b * (a.x / vecDist(a)), y = b * (a.y / vecDist(a)) }
end
function vecDot(a, b)
	return a.x * b.x + a.y * b.y
end
function vecProj(a, b)
	local k = vecDot(a, b) / vecDot(b, b)
	return {x=k*b.x, y=k*b.y}
end
function findMin(branch, newNode, shortestNode)
	shortestNode = shortestNode or branch
	for i = 1, #branch.nodes do
		if vecDist(vecSub(branch.nodes[i], newNode)) < vecDist(vecSub(shortestNode, newNode)) then
			shortestNode = branch.nodes[i]
		end
		shortestNode = findMin(branch.nodes[i], newNode, shortestNode)
	end
	return shortestNode
end

function drawbranch(branch)
	if #branch.nodes == 0 or not branch.parent then
		screen.drawCircle(branch.x, branch.y, 2)
	end
	for i = 1, #branch.nodes do
		screen.drawLine(branch.x, branch.y, branch.nodes[i].x, branch.nodes[i].y)
		drawbranch(branch.nodes[i])
	end
end

function hypot2(a,b)
	return vecDot(vecSub(a, b), vecSub(a, b))
end

function distanceSegmentToPoint(A, B, C)
    AC = vecSub(C, A);
    AB = vecSub(B, A);

    D = vecAdd(vecProj(AC, AB), A);

    AD = vecSub(D, A);
    k = math.abs(AB.x) > math.abs(AB.y) and AD.x / AB.x or AD.y / AB.y;

    if (k <= 0.0) then
        return math.sqrt(hypot2(C, A))
	elseif (k >= 1.0) then
        return math.sqrt(hypot2(C, B))
    end

    return math.sqrt(hypot2(C, D))
end
start = { x = 5, y = 5 }
goal = { x = 280, y = 150 }

tree = { nodes = {} }
tree.nodes[1] = { x = start.x, y = start.y, nodes = {} }
obstacles = {}

done = false

while true do
	p = { x = math.random(0, 287), y = math.random(0, 159), r = math.abs(math.random() * 20)}
	if vecDist(vecSub(p, start)) > p.r and vecDist(vecSub(p, goal)) > p.r then
		table.insert(obstacles, p)
		if #obstacles > 30 then
			break
		end
	end
end

ticks = 0

--node = { x = math.random(0, 95), y = math.random(0, 95) }

function onTick()
	if ticks == 0 then
		tree = { nodes = {} }
		tree.nodes[1] = { x = start.x, y = start.y, nodes = {} }
	end
	ticks = ticks + 1
	if click then
		goal = { x = input.getNumber(3), y = input.getNumber(4) }
		tree = { nodes = {} }
		tree.nodes[1] = { x = start.x, y = start.y, nodes = {} }
		minVec = nil
		done = false
		ticks = 0
	end
	click = input.getBool(1) and not isPressed
	isPressed = input.getBool(1)

	if not done then
		if ticks % 20 == 0 then
			node = goal
		else
			node = { x = math.random(0, 287), y = math.random(0, 159) }
		end
		minVec = findMin(tree.nodes[1], node)
		v = vecSub(minVec, node)
		dr = math.min(vecDist(v), 20)
		vec = vecScale(v, dr)
		node = vecAdd(minVec, vec)
		--det = minVec.x * vec.y - minVec.y * vec.x
		for i = 1, #obstacles do
			local obstacle = obstacles[i]
			D = vecSub(minVec, node)
			F = vecSub(obstacle, minVec)
			A = vecDot(D, D)
			B = 2*vecDot(F, D)
			C = vecDot(F, F)-obstacle.r*obstacle.r
			det = B*B-4*A*C
			if det >= 0 then
				t1 = (-B-det)/(2*A)
				t2 = (-B+det)/(2*A)
				if t1 >= 0 and t1 <= 1 then
					print("skip")
					goto skip
				elseif t2 >= 0 and t2 <= 1 then
					print("skip")
					goto skip
				end
			end
		end
		table.insert(minVec.nodes, { x = minVec.x + vec.x, y = minVec.y + vec.y, nodes = {}, parent = minVec })
		if vecDist(vecSub(goal, node)) < 1 then
			--print("We're done here!")
			done = findMin(tree.nodes[1], goal)
			print(done.x, done.y)
		end
		::skip::
	end
end

function onDraw()
	w = screen.getWidth()
	h = screen.getHeight()
	c = { x = w / 2, y = h / 2 }
	screen.setColor(60, 60, 30)
	screen.drawClear()

	screen.setColor(5, 5, 5)
	for i = 1, #obstacles do
		local v = obstacles[i]
		screen.drawCircleF(v.x, v.y, v.r)
	end
	if minVec then
		screen.setColor(10, 10, 140)
		screen.drawCircle(node.x, node.y, 2)
		screen.setColor(25, 25, 25)
		screen.drawLine(minVec.x, minVec.y, node.x, node.y)
	end
	drawbranch(tree.nodes[1])

	if done then
		screen.setColor(0, 160, 0)
		l = done
		while l.parent do
			screen.drawCircle(l.x, l.y, 2)
			screen.drawLine(l.x, l.y, l.parent.x, l.parent.y)
			l = l.parent
		end
	end
	
	screen.setColor(0, 140, 0)
	screen.drawCircle(start.x, start.y, 2)
	screen.setColor(140, 0, 0)
	screen.drawCircle(goal.x, goal.y, 2)
end

-- for i = 0, math.pi*2, math.pi/10 do
--     p = f(40, 10, ticks / 100, i)
--     if lp then
--         screen.drawLine(c.x+p.x, c.y+p.y, c.y+lp.x, c.x+lp.y)
--     end
--     lp = p
-- end
