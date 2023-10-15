SI = "num kGM"
function numformat(num, dec)
    if num == 0 then
        return "0"
    end
    local l = -3+(num>=0 and 1 or -1)*math.log(math.abs(num), 10)//3
    if l == -3 then
        return string.format("%"..dec.."f", num)
    end
    return string.format("%"..(dec-(num > 0 and 1 or 2)).."f %s test", num/1000, SI:sub(l+7, l+7))
end

function siformat(num, dec)
    local l = -3+(num>=0 and 1 or -1)*math.log(math.abs(num), 10)//3
    local s = SI:sub(l*3+1, l*3+3)
    local n = num/10^(l*3)
    return string.format("%."..dec.."f %s", n, s)
end

-- for i = 0, 1000000, 1000 do
--     print(numformat(i, 7))
-- end

print(string.format("%04.3f", math.pi))