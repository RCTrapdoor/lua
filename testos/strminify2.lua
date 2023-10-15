function onTick()
	str = string.format("%70.f", input.getNumber(1))
	for i = 1, 7 do
		output.setNumber(1, string.sub(str, i, i))
	end
end