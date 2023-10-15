--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
--- Remember to set your Author name etc. in the settings: CTRL+COMMA

-- require("_build._simulator_config") -- default simulator config, CTRL+CLICK it or F12 to goto this file and edit it. Its in a separate file just for convenience.
require("LifeBoatAPI")              -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library

lst = {{1, 16}, {2, 16}, {3, 16}, {4, 16}, {5, 3}, {5, 4}, {5, 5}, {5, 6}, {5, 7}, {5, 8}, {5, 16}, {6, 8}, {6, 11}, {6, 12}, {6, 13}, {6, 14}, {6, 15}, {6, 16}, {7, 8}, {7, 16}, {8, 8}, {8, 16}, {9, 8}, {9, 16}, {10, 8}, {10, 16}, {11, 1}, {11, 2}, {11, 3}, {11, 4}, {11, 5}, {11, 6}, {11, 7}, {11, 8}, {11, 9}, {11, 10}, {11, 11}, {11, 12}, {11, 13}, {11, 16}, {12, 8}, {12, 16}, {13, 8}, {13, 12}, {13, 16}, {14, 2}, {14, 3}, {14, 4}, {14, 5}, {14, 8}, {14, 12}, {14, 16}, {15, 5}, {15, 8}, {15, 12}, {15, 16}, {16, 5}, {16, 8}, {16, 12}, {16, 16}, {17, 1}, {17, 2}, {17, 3}, {17, 5}, {17, 8}, {17, 12}, {18, 5}, {18, 12}, {19, 5}, {19, 12}, {20, 5}, {20, 12}, {21, 3}, {21, 5}, {21, 6}, {21, 7}, {21, 8}, {21, 9}, {21, 10}, {21, 11}, {21, 12}, {22, 3}, {22, 12}, {23, 3}, {23, 12}, {23, 13}, {23, 14}, {23, 15}, {23, 16}, {23, 17}, {23, 18}, {24, 3}, {24, 5}, {24, 6}, {24, 7}, {24, 8}, {24, 9}, {24, 10}, {24, 12}, {25, 3}, {25, 10}, {25, 12}, {26, 3}, {26, 10}, {26, 12}, {27, 3}, {27, 10}, {27, 12}, {28, 3}, {28, 10}, {28, 12}, {28, 17}, {29, 3}, {29, 4}, {29, 5}, {29, 6}, {29, 7}, {29, 10}, {29, 12}, {29, 13}, {29, 14}, {29, 17}, {30, 3}, {30, 10}, {30, 12}, {30, 14}, {30, 15}, {30, 16}, {30, 17}, {31, 3}, {31, 10}, {31, 14}, {32, 3}, {32, 10}, {32, 11}, {32, 12}, {32, 13}, {32, 14}, {33, 3}, {34, 3}}
w,h = 288, 160
map = {}

for i = 1, (w-16)/8 do
    map[i] = {}
    for j = 1, (h-16)/8 do
        map[i][j] = 0
    end
end

for k,v in ipairs(lst) do
    map[v[1]][v[2]] = -1
end

start = {x = 8, y = 5}
target = {x = 26, y = 16}

active = start
possible = {}
function dist(a, b)
    return ((a.x-b.x)^2+(a.y-b.y)^2)^0.5
end

ticks = 0
lclock = 0
-- d = os.date()
-- while d == os.date() do
--     d = os.date()
--     lclock = os.clock()
-- end

--[[ Naive approach:
-- onTick
if os.clock() - lclock >= 0.5 and not done then
    lclock = lclock + 0.5
    best = nil
    for i = -1, 1 do
        for j = -1, 1 do
            if not (i == 0 and j == 0) and active.x + i >= 1 and active.x + i <= 34 and active.y + j >= 1 and active.y + j <= 18 then
                if map[active.x + i][active.y + j] >= 0 then
                    d = dist({x = active.x + i, y = active.y + j}, slutt) + map[active.x + i][active.y + j]
                    if not best then
                        best = {d = d, x = active.x + i, y = active.y + j}
                    elseif d < best.d then
                        best = {d = d, x = active.x + i, y = active.y + j}
                    end
                end
            end
        end
    end
    map[best.x][best.y] = map[best.x][best.y] + 5
    active = {x = best.x, y = best.y}
    if best.d == 0 then
        done = true
    end
end

-- onDraw
for i = -1, 1 do
    for j = -1, 1 do
        if not (i == 0 and j == 0) and active.x + i >= 1 and active.x + i <= 34 and active.y + j >= 1 and active.y + j <= 18 then
            screen.setColor(60, 10, 0)
            screen.drawRectF((active.x + i)*8 + 1, (active.y + j)*8 + 1, 7, 7)
        end
    end
end
--]]
table.insert(possible, {x = active.x , y = active.y, d = dist({x = active.x, y = active.y}, target), parent = 0, v = 0, done = true})

function check(active_id)
    active = possible[active_id]
    local done = true
    if active.x - 1 > 0 and map[active.x - 1][active.y] == 0 then
        done = false
        map[active.x - 1][active.y] = active.v + 1
        table.insert(possible, {x = active.x - 1, y = active.y, d = dist({x = active.x - 1, y = active.y}, target) + active.v, parent = active_id, v = active.v + 1, done = false})
    end
    if active.x + 1 < 35 and map[active.x + 1][active.y] == 0 then
        done = false
        map[active.x + 1][active.y] = active.v + 1
        table.insert(possible, {x = active.x + 1, y = active.y, d = dist({x = active.x + 1, y = active.y}, target) + active.v, parent = active_id, v = active.v + 1, done = false})
    end
    if active.y - 1 > 0 and map[active.x][active.y - 1] == 0 then
        done = false
        map[active.x][active.y - 1] = active.v + 1
        table.insert(possible, {x = active.x, y = active.y - 1, d = dist({x = active.x, y = active.y - 1}, target) + active.v, parent = active_id, v = active.v + 1, done = false})
    end
    if active.y + 1 < 19 and map[active.x][active.y + 1] == 0 then
        done = false
        map[active.x][active.y + 1] = active.v + 1
        table.insert(possible, {x = active.x, y = active.y + 1, d = dist({x = active.x, y = active.y + 1}, target) + active.v, parent = active_id, v = active.v + 1, done = false})
    end
--     dist({x = active.x - 1, y = active.y}
-- dist({x = active.x + 1, y = active.y}
-- dist({x = active.x, y = active.y - 1}
-- dist({x = active.x, y = active.y + 1}
    possible[active_id].done = true

    local min = nil

    for k, v in ipairs(possible) do
        if not v.done then
            if not min or v.d < possible[min].d then
                min = k
            end
        end
    end
    return min
end

    active = check(1)
done = false
go = true
function onTick()
    ticks = ticks + 1
    if not done and go then
        active = check(active)
    end
    if possible[active].x == target.x and possible[active].y == target.y then
        route = {possible[active].parent}
        while route[#route] ~= 0 do
            table.insert(route, possible[route[#route]].parent)
        end
        done = true
    end
    lclock = os.clock()
    click = input.getBool(1) and not pressed
    pressed = input.getBool(1)
    touch = {x = input.getNumber(3), y = input.getNumber(4)}
    
    if click and touch.x >= 8 and touch.x < 280 and touch.y > 8 and touch.y < 152 then
        map[(touch.x)//8][(touch.y)//8] = map[(touch.x)//8][(touch.y)//8] >= 0 and -1 or 0
    elseif click then
        go = not go
        text = ""
        for x = 1, #map do
            for y = 1, #map[x] do
                if map[x][y] == 255 then
                    text = text .. ("{%d, %d}, "):format(x, y)
                end
            end
        end
        print(text)
    end
end
mul = 2
function onDraw()
    
    for x = 1, #map do
        for y = 1, #map[x] do
            if map[x][y] < 0 then
                screen.setColor(25, 10, 100)
                screen.drawRectF(x*8, y*8, 8, 8)
            else
                screen.setColor(math.min(255, map[x][y]*mul), math.min(255, map[x][y]*mul), math.min(255, map[x][y]*mul))
                screen.drawRectF(x*8, y*8, 8, 8)
            end
            screen.setColor(255, 255, 255)
            screen.drawRect(x*8, y*8, 8, 8)
        end
    end
    
    for k, v in ipairs(possible) do
        if k == active then
            screen.setColor(0, 255, 0)
        elseif v.done then
            screen.setColor(60, 20, 0)
        else
            screen.setColor(255, 255, 0)
        end
        screen.drawRectF(v.x*8 + 1,v.y*8 + 1, 7, 7)
    end
    screen.setColor(0, 255, 0)
    screen.drawTextBox(start.x * 8 + 1, start.y * 8 + 1, 8, 8, "S", 0, 0)
    screen.setColor(255, 100, 0)
    screen.drawTextBox(target.x * 8 + 1, target.y * 8 + 1, 8, 8, "F", 0, 0)

    if done then
        screen.setColor(0, 255, 0)
        for k, v in ipairs(route) do
            if v > 0 then
                screen.drawRectF(possible[v].x*8 + 1,possible[v].y*8 + 1, 7, 7)
            end
        end
    end
end
