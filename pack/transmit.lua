function encodeCharacters(chars)
    local encodedValue = 0
    for k = 1, 4 do
        encodedValue = encodedValue << 6
        encodedValue = chars[k] and (encodedValue | chars[k]) or (encodedValue | 0)
    end
    return encodedValue
end

text = property.getText("Text"):upper()
channels = math.min(math.ceil(#text / 4), property.getNumber("Max channels"))
start_channel = property.getNumber("Start channel")

function onTick()
    str = {}

    for j = 1, channels do
        str[j] = {}
        for i = 1, math.min(4, #text - 4 * (j - 1)) do
            str[j][i] = string.byte(text, (j - 1) * 4 + i) - 32
        end
    end

    for k = 1, #str do
        a = encodeCharacters(str[k])
        output.setNumber(k + start_channel - 1, a)
    end
end
