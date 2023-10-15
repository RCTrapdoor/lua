function dec2bin(dec)
    local i, bin = 8, {}
    while dec // 1 > 0 do
        bin[i] = dec % 2
        dec = math.floor(dec / 2)
        i = i - 1
    end
    return bin
end

num = 63

function onTick()
    bin = dec2bin(num)

    for i = 1, 8 do
        output.setBool(i, bin[i])
    end
end