local function wordToAscii(word)
    ascii = ""
    for i = 1, #word do
        ascii = ascii..string.format("%02.f", string.byte(word, i) - 32)
    end
    return tonumber(ascii)
end

function onTick()
    ascii = wordToAscii("please help")

    word2 = ""
    for i = 1, #ascii, 2 do
        word2 = word2..string.char(tonumber(string.sub(ascii, i, i+1)) + 32)
    end
    print(ascii)
    print(word2)
end
