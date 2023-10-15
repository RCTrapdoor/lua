--Compressed using YAGoOaR's JS minifier
--GOOD LUCK TO UNDERSTAND THE CODE xD
property.getNumber = property.getNumber
explode_if_target_lost = property.getBool("ExplodeIfTargetLost")
nav_constant = property.getNumber("N")
fuze_distance = property.getNumber("FuzeDistance")
fuze_distance_extrapolate_ticks = property.getNumber("FuzeDistanceExtrapolateTicks")

bB = 0.8 * 60
aP = 0
bg = false
pi = math.pi
tau = pi * 2
distance = 3.5
e = 0.0007
f = 1.5
g = 3.5
height = 0.0007
l = 1.5

vec3_FQG = function(F, Q, G)
	return { F = F, Q = Q, G = G }
end

vec3_xyz = function(x, y, z)
	return { x = x, y = y, z = z }
end

output.setNumber = output.setNumber
input.getNumber = input.getNumber
input.getBool = input.getBool
output.setBool = output.setBool
math.abs = math.abs
math.cos = math.cos
math.sin = math.sin
math.acos = math.acos
math.asin = math.asin

function vec3_add(A, B)
	return vec3_xyz(A.x + B.x, A.y + B.y, A.z + B.z)
end

function nan_to_0(x)
	if not (x > 0 or x < 0) then
		return 0
	end
	return x
end

function vec3_subtract(A, B)
	return vec3_xyz(A.x - B.x, A.y - B.y, A.z - B.z)
end

function vec3_multiply(A, n)
	return vec3_xyz(A.x * n, A.y * n, A.z * n)
end

function vec3_divide(A, n)
	return vec3_xyz(A.x / n, A.y / n, A.z / n)
end

function bt(a, b)
	return (b - a + pi * 3) % tau - pi
end

function aU(A, B)
	return vec3_FQG(bt(A.F, B.F), bt(A.Q, B.Q), 0)
end

function W(x)
	if x < 0 then
		return -1
	else
		return 1
	end
end

function bj(F, Q, H)
	if H == nil then
		H = 1
	end
	return vec3_xyz(-math.sin(F) * math.cos(Q) * H, math.cos(F) * math.cos(Q) * H, math.sin(Q) * H)
end

function bk(I)
	H = vec3_magnitude(I)
	if H == 0 then
		return aC()
	end
	X = vec2_magnitude(I)
	x = I.x / X
	y = I.y / X
	z = I.z / H
	return vec3_FQG(-math.acos(y) * W(x), math.asin(z), 0)
end

function vec3_magnitude(I)
	return (I.x * I.x + I.y * I.y + I.z * I.z) ^ 0.5
end

function vec2_magnitude(I)
	return (I.x * I.x + I.y * I.y) ^ 0.5
end

function vec3_normalize(I)
	return vec3_divide(I, vec3_magnitude(I))
end

function vec3_opposite(I)
	return vec3_multiply(I, -1)
end

aD = function(Y, aX, aZ)
	if aZ == nil then
		aZ = 0
	end
	local m = {}
	for i = 0, Y - 1 do
		m[i] = {}
		for j = 0, aX - 1 do
			m[i][j] = aZ
		end
	end
	m.Y = Y
	m.aX = aX
	m.bl = function(o)
		p = aD(m.Y, o.aX, 0)
		if m.aX ~= o.Y then
			ap = 1
			return p
		end
		for i = 0, m.Y - 1 do
			for j = 0, o.aX - 1 do
				J = 0
				for r = 0, m.aX - 1 do
					J = J + m[i][r] * o[r][j]
				end
				p[i][j] = J
			end
		end
		return p
	end
	m.aa = function()
		return m[0][0] * m[1][1] - m[1][0] * m[0][1]
	end
	return m
end

function bC(I)
	m = aD(3, 1)
	m[0][0] = I.x
	m[1][0] = I.y
	m[2][0] = I.z
	return m
end

function bv(m)
	return vec3_xyz(m[0][0], m[1][0], m[2][0])
end

function bI(v, ab, u)
	R = aD(3, 3, 0)
	V = bC(v)
	ac = math.cos(ab)
	ad = math.sin(ab)
	aq = (1 - ac)
	R[0][0] = ac + u.x ^ 2 * aq
	R[0][1] = u.x * u.y * aq - u.z * ad
	R[0][2] = u.x * u.z * aq + u.y * ad
	R[1][0] = u.y * u.x * aq + u.z * ad
	R[1][1] = ac + u.y ^ 2 * aq
	R[1][2] = u.y * u.z * aq - u.x * ad
	R[2][0] = u.z * u.x * aq - u.y * ad
	R[2][1] = u.z * u.y * aq + u.x * ad
	R[2][2] = ac + u.z ^ 2 * aq
	return bv(R.bl(V))
end

function aE(a, b)
	i = aD(2, 2)
	j = aD(2, 2)
	k = aD(2, 2)
	i[0][0] = a.y
	i[0][1] = a.z
	i[1][0] = b.y
	i[1][1] = b.z
	j[0][0] = a.x
	j[0][1] = a.z
	j[1][0] = b.x
	j[1][1] = b.z
	k[0][0] = a.x
	k[0][1] = a.y
	k[1][0] = b.x
	k[1][1] = b.y
	return vec3_xyz(i.aa(), -j.aa(), k.aa())
end

function aY(v)
	return vec3_normalize(aE(v, vec3_xyz(0, 0, 1)))
end

function bZ(v, bm)
	if bm == nil then
		bm = aY(v)
	end
	return vec3_opposite(vec3_normalize(aE(v, bm)))
end

function aC()
	return vec3_FQG(0, 0, 0)
end

function aF()
	return vec3_xyz(0, 0, 0)
end

ar = function()
	return vec3_xyz(0, 0, 1)
end

bn = function()
	return vec3_xyz(1, 0, 0)
end

function bJ(aG, as, ae)
	return bI(bI(aG, as, ar()), ae, bn())
end

function bK(as, ae)
	return bI(bI(vec3_xyz(0, 1, 0), as, bn()), ae, ar())
end

function bG(A, B)
	return A.x * B.x + A.y * B.y + A.z * B.z
end

function bL(af, ag)
	return math.acos(bG(af, ag) / (vec3_magnitude(af) * vec3_magnitude(ag)))
end

function bS(ba, bb, bo, bD)
	A = bD.x
	B = bD.y
	C = bD.z
	D = 0
	t = -(A * ba.x + B * ba.y + C * ba.z + D) / (A * bb.x + B * bb.y + C * bb.z)
	K = vec3_add(ba, vec3_multiply(bb, t))
	return K
end

last_radar_distance = 0
bR = { bc = aF(), ah = aF(), q = aF() }
bd = aC()
ai = aC()
aj = aC()
aH = aC()
be = aC()

bT = function(bf, at, aI)
	bH = aE(at, bf)
	if vec3_magnitude(vec3_subtract(aI, bH)) > 1 then
		return 1
	else
		return -1
	end
end

function onTick()
	launched = input.getBool(1)

	if not launched then
		output.setNumber(1, 0)
		output.setNumber(2, 0)
		output.setNumber(3, 0)
		return
	end

	radar_data = vec3_FQG(-input.getNumber(1) * tau, input.getNumber(2) * tau, 0)
	bw = math.asin(math.sin(radar_data.F) / math.cos(radar_data.Q))
	bx = math.asin(math.sin(radar_data.Q) / math.cos(radar_data.F))
	radar_data.F = bw
	radar_data.Q = bx
	radar_distance = input.getNumber(3)
	bF = math.max(math.abs(radar_distance - last_radar_distance), 0.1)

	if last_radar_distance == 0 then
		bF = 0
	end

	au = { pitch = input.getNumber(4) * tau, roll = input.getNumber(5) * tau }
	al = { heading = input.getNumber(6) * tau, heading_normal = input.getNumber(7) * tau }
	bO = { bc = bK(au.pitch, al.heading), ah = bK(au.roll, al.heading_normal) }
	bO.q = aE(bO.bc, bO.ah)
	bP = { L = aF(), M = bR.q }
	bQ = { L = aF(), M = bR.ah }
	set_coord = aC()
	bU = bS(bO.bc, bP.M, bP.L, bP.M)
	bV = bS(bO.bc, bQ.M, bQ.L, bQ.M)
	aK = bL(bR.bc, bU)
	aL = bL(bR.bc, bV)
	set_coord.F = bT(bU, bR.bc, bP.M) * aK
	set_coord.Q = bT(bV, bR.bc, bQ.M) * aL
	bz = bJ(vec3_xyz(0, 1, 0), radar_data.F, radar_data.Q)
	aM = bk(bz)
	bq = aU(aM, bd)
	aw = aU(set_coord, bq)
	aN = aU(aw, aH)
	aO = aU(aN, be)
	N = nan_to_0(aw.F * bF + aN.F / 2 + aO.F / 6) * nav_constant
	O = nan_to_0(aw.Q * bF + aN.Q / 2 + aO.Q / 6) * nav_constant
	K = { x = -N - f * bq.F, y = -O - l * bq.Q, z = 0 }
	output.setNumber(1, K.x)
	output.setNumber(2, K.y)
	output.setNumber(3, K.z)
	br = (((radar_distance - bF * fuze_distance_extrapolate_ticks) < fuze_distance and radar_distance ~= 0) or (explode_if_target_lost and bg and radar_distance == 0)) and launched and aP > bB

	if not bg and launched and radar_distance < 100 and radar_distance ~= 0 then
		bg = true
	end

	if aP <= bB then
		aP = aP + 1
	end

	output.setBool(1, br)
	last_radar_distance = radar_distance
	bR = bO
	bd = aM
	ai = P
	aH = aw
	be = aN
end
