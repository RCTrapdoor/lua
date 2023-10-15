--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


--[====[ HOTKEYS ]====]
-- Press F6 to simulate this file
-- Press F7 to build the project, copy the output from /_build/out/ into the game to use
-- Remember to set your Author name etc. in the settings: CTRL+COMMA


--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "3x3")
    simulator:setProperty("Text", "TEST")

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)
        -- touchscreen defaults
        local screenConnection = simulator:getTouchScreen(1)
        simulator:setInputBool(1, screenConnection.isTouched)
        simulator:setInputNumber(1, screenConnection.width)
        simulator:setInputNumber(2, screenConnection.height)
        simulator:setInputNumber(3, screenConnection.touchX)
        simulator:setInputNumber(4, screenConnection.touchY)

        -- NEW! button/slider options from the UI
        simulator:setInputBool(31, simulator:getIsClicked(1))     -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(31, simulator:getSlider(1))      -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2))     -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50) -- set input 32 to the value from slider 2 * 50
    end

    ;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

function encodeCharacters(chars)
    local encodedValue = 0
    for k = 1, 4 do
        encodedValue = encodedValue << 6
        encodedValue = chars[k] and (encodedValue | chars[k]) or (encodedValue | 0)
    end
    return encodedValue
end

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


str = {}
text = property.getText("Text"):upper()

channels = math.ceil(#text / 4)

for j = 1, channels do
    str[j] = {}
    for i = 1, math.min(4, #text-4*(j-1)) do
        str[j][i] = string.byte(text, (j - 1)*4+i) - 32
    end
end

out = ""

for k = 1, #str do
    a = encodeCharacters(str[k])

    print(a)

    t = decodeCharacters(a)

    out = out .. t

    print(t)
end

print(out)
print(("This used %.f channels."):format(channels))