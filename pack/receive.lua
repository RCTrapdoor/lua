function decodeCharacters(encodedValue)
    local char1 = 0
    local char2 = 0
    local char3 = 0
    local char4 = 0

    char1 = (encodedValue & 0xFC0000) >> 18
    char2 = (encodedValue & 0x3F000) >> 12
    char3 = (encodedValue & 0xFC0) >> 6
    char4 = (encodedValue & 0x3F)

    return string.char(char1 + 32, char2 + 32, char3 + 32, char4 + 32)
end

channels = property.getNumber("Max channels")
start_channel = property.getNumber("Start channel")

function onTick()
    for k = 1, channels do
        a = input.getNumber(k + start_channel - 1)
        t = decodeCharacters(a)
        out = out .. t
    end
end

function onDraw()
    screen.drawText(2, 2, out)
end