function onTick()
	str = ("%70.f"):format(input.getNumber(1))
	for i = 1, 7 do
		output.setNumber(1, str:sub(i, i))
	end
end