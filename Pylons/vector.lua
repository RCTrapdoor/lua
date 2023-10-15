function normalize(vec)
	local mag = (vec.x^2 + vec.y^2)^0.5
	return {x = vec.x / mag, y = vec.y / mag}
end

function add(vec1, vec2)
	return {x = vec1.x + vec2.x, y = vec1.y + vec2.y}
end

function limit(vec, limit)
	local mag = math.min((vec.x^2 + vec.y^2)^0.5, limit)
	return mult(normalize(vec), mag)
end

function sub(vec1, vec2)
	return {x = vec1.x - vec2.x, y = vec1.y - vec2.y}
end

function mult(vec, mul)
	return {x = vec.x * mul, y = vec.y * mul}
end