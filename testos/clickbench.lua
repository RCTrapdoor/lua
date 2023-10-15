function one()
    local press = 0
    local down = true

	for i = 1, 20000000 do
		if down then
			press = press + 1
		else
			press = 0
		end

		if press >= 120 then
			hold = true
		else
			hold = false
		end
	end
end

function two()
    local press = 0
    local down = true
	for i = 1, 20000000 do
		press = down and (press + 1) or 0
		hold = press >= 120
	end
end

-- benchmark the two functions
for i = 1, 10 do
    time0 = os.clock()
    one()
    time1 = os.clock()
    two()
    time2 = os.clock()

    onetime = time1 - time0
    twotime = time2 - time1

    print(string.format("one: %.6f", onetime))
    print(string.format("two: %.6f", twotime))

    print(string.format("%.02f%% difference in favor of %s", math.abs(100-(onetime) / (twotime) * 100), onetime < twotime and "one" or "two"))
    print()
end