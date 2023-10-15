-- Author: <Authorname> (Please ch_ange this in user settings, Ctrl+Comma)
-- GitHub: <GithubLink>
-- Workshop: <WorkshopLink>
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search_ "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameousch_angey/STORMWORKS_VSCodeExtension/issues - by Nameous Ch_angey


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
    simulator:setProperty("ExampleNumberProperty", 123)

    -- Runs every tick just before onTick; allows you to simulate the inputs ch_anging
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)
        -- touch_screen defaults
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
    end;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

ticks = 0
function onTick()
    ticks = ticks + 1
end

function onDraw()
    screen.drawCircle(16, 16, 5)
end

CH_ = {}

CH_[32] = { 1100 }
CH_[33] = { 1127, 1922 }
CH_[35] = { 2122, 6122, 2522, 6522, 2922, 6922, 1342, 1742, 6332, 6732 }
CH_[36] = { 1165, 1665 }
CH_[37] = { 1122, 5922, 5122, 4322, 3522, 2722, 1922 }
CH_[48] = { 2111, 1228, 2922, 4122, 5228, 5912, 3612, 4412 }
CH_[49] = { 1312, 3128, 1962 }
CH_[50] = { 1222, 2142, 5224, 4522, 4711, 2711, 1821, 1962 }
CH_[51] = { 1222, 2142, 5228, 2942, 1822, 2522 }
CH_[52] = { 1124, 1532, 5125, 5625 }
CH_[53] = { 1162, 1321, 2411, 4411, 4522, 5624, 2942, 1822 }
CH_[54] = { 1228, 2142, 5222, 2942, 5624, 4522 }
CH_[55] = { 1162, 5322, 4522, 3722, 2922 }
CH_[56] = { 2111, 1228, 2922, 4122, 5228, 5912, 3512 }
CH_[57] = { 2522, 1224, 2142, 5228, 2942, 1822 }
CH_[63] = { 1222, 2142, 5224, 4522, 3622, 3922 }
CH_[65] = { 1132, 1322, 1532, 1724, 5125, 5625 }
CH_[66] = { 1152, 5223, 5512, 5723, 1952, 1425, 3512 }
CH_[67] = { 5222, 2142, 1228, 2942, 5822 }
CH_[68] = { 1125, 1625, 4122, 5228, 4922 }
CH_[69] = { 1162, 1326, 1962, 4532 }
CH_[70] = { 1162, 1328, 4532 }
CH_[71] = { 2152, 1228, 2922, 5912, 5525 }
CH_[72] = { 1124, 1532, 1724, 5125, 5625 }
CH_[73] = { 1162, 1962, 3425 }
CH_[74] = { 1132, 1722, 2822, 3942, 5128 }
CH_[75] = { 1125, 1625, 5124, 4522, 5724 }
CH_[76] = { 1125, 1625, 4932 }
CH_[77] = { 1125, 1625, 4413, 5513, 6413, 8122, 7333, 8625 }
CH_[78] = { 1125, 1625, 4513, 6125, 5633, 6922 }
CH_[79] = { 2111, 1228, 2922, 4122, 5228, 5912 }
CH_[80] = { 1152, 5224, 3532, 1427 }
CH_[81] = { 2111, 1228, 2922, 4122, 5228, 5912, 6822, 7922 }
CH_[82] = { 1152, 5224, 3532, 1427, 4822, 5922 }
CH_[83] = { 1211, 2142, 5222, 1422, 2542, 5624, 5912, 1822, 2922 }
CH_[84] = { 1162, 3427 }
CH_[85] = { 1129, 2922, 5129, 5912 }
CH_[86] = { 1123, 2424, 3823, 7123, 6424, 6813 }
CH_[87] = { 1125, 1625, 4513, 5413, 6513, 8125, 7633, 8922 }
CH_[88] = { 1123, 2424, 1823, 5123, 5414, 5823 }
CH_[89] = { 1123, 2411, 5123, 4422, 3625 }
CH_[90] = { 1162, 4421, 3522, 2722, 1962 }

max_x = 0
max_y = 0
max_w = 0
max_h = 0

CH = {}
for k1, v1 in pairs(CH_) do
    for k2, v2 in pairs(v1) do
        local s = tostring(v2)
        CH_[k1][k2] =  tonumber(s:sub(3, 4) .. s:sub(1, 2))
        print(tonumber(s:sub(3, 4) .. s:sub(1, 2)))
    end
end

function encode(val)
    math.abs = ""
    while val > 0 do
        math.abs = string.char(val % 88 + 34) .. math.abs
        val = math.floor(val / 88)
    end
    return math.abs
end

print(encode(6211))

function decode(str)
    val = 0
    for i = 1, #str do
        val = val * 88 + string.byte(str, i) - 34
    end
    return val
end

print(decode("hU"))

for _, v in pairs(CH_) do
    for _, v2 in pairs(v) do
        s2 = tostring(v2)
        x = tonumber(s2:sub(1, 1))
        y = tonumber(s2:sub(2, 2))
        w = tonumber(s2:sub(3, 3))
        _ENV["255"] = tonumber(s2:sub(4, 4))
        if x > max_x then
            max_x = x
        end
        if y > max_y then
            max_y = y
        end
        if w > max_w then
            max_w = w
        end
        if _ENV["255"] > max_h then
            max_h = _ENV["255"]
        end
    end
end
print("x", "y", "w", "h")
print(max_x, max_y, max_w, max_h)

s = ""
for _, v in pairs(CH_) do
    s = s .. _ .. " "
    for _, v2 in pairs(v) do
        s = s .. encode(v2)
    end
    s = s .. " "
end

print(s)