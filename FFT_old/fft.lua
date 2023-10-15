-- Author: Trapdoor
-- GitHub: Trapdoor
-- Workshop: Trapdoor

--Trapdoor--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("_build._simulator_config") -- LifeBoatAPI allows you to use lua's "require" keyword. see the /build/_simulator_config.lua file for how to configure the simulator
require("LifeBoatAPI") -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library

ticks = 0

tickrate = 60

tau = math.pi * 2
pi = tau / 2

max_frequency = 30

samples = 600

history = {}

for a = 0, samples do
    history[a] = 0
end

peaks = {{0, 0}, {0, 0}, {0, 0}}

function peak_check(data, key, value, window)
    window = window or 5
    for i = -window, window do
        if data[key+i] then
            if value < data[key+i] then
                return false
            end
        end
    end
    return true
end

function onTick()
    ch = math.floor(math.min(6, math.max(1, input.getNumber(16))))
    lbl = property.getText("Label "..ch)
    if width then
    
    if not history2 then
        history2 = {}
        for a = 0, width do
            history2[a] = 0
        end
    end
    
    ticks = ticks + 1

    table.insert(history, input.getNumber(9+ch))
    
    while #history >= samples do
        table.remove(history, 1)
    end
    
    mean = 0
    
    for k,d in ipairs(history) do
        mean = mean + d
    end
    
    mean = mean / #history

    for a = ticks % 3, width, 3 do
        freq = (a / width) * max_frequency
        x_sum = 0
        for k,val in ipairs(history) do
            theta = k * (freq/tickrate) * tau
            x_sum = x_sum + (val - mean) * math.cos(theta)
        end
        history2[a] = (math.abs((x_sum / #history) + history2[a]))/2
    end
    peaks = {}
    for freq_key, freq_value in ipairs(history2) do
        if freq_key > 1 and freq_key < #history2 then
            if freq_value > history2[freq_key-1] and freq_value > history2[freq_key+1] then
                if peak_check(history2, freq_key, freq_value) then
                    table.insert(peaks, {freq_key, freq_value})
                end
            end
        end
    end

    ma = math.max(table.unpack(history2))*1.2
    mi = math.min(table.unpack(history2))

    span = ma-mi
    factor = height / span
    ma_ = math.max(table.unpack(history))
    mi_ = math.min(table.unpack(history))

    span_ = ma_ - mi_
    factor_ = height / span_
    table.sort(peaks, function(a, b) return a[2] > b[2] end)
end
end

function onDraw()
    width,height = screen.getWidth(), screen.getHeight()
    screen.setColor(70, 70, 10)
    screen.drawText(2, 1, ("Channel %.f: %s"):format(ch, lbl or "No Label"))
    if mi then
        
        for n = 1, #history2-1 do
            -- for _, pk in ipairs(peaks) do
            --     if n == pk[1] then
            --         screen.drawCircle(n, height-factor*(history2[n]-mi), 1)
            --         break
            --     end
            -- end
            screen.setColor(120, 120, 120)
            screen.drawLine(n, height-factor*(history2[n]-mi), (n+1), height-factor*(history2[n+1]-mi))
        end

        screen.setColor(180, 180, 180, 80)
        for n = 1, #history-1 do
            screen.drawLine(n*(width/samples), height/4-factor_/4*(history[n]-mi_), (n+1)*(width/samples), height/4-factor_/4*(history[n+1]-mi_))
        end

        for i = 0, width+1, width / 4 do
            screen.setColor(35, 20, 0, 150)
            screen.drawLine(i, 0, i, height)
            screen.setColor(35, 20, 0)
            screen.drawText(i-11, 8, ("%2.fHz"):format((i / width)* max_frequency))
        end

        for a = 1, math.min(#peaks, 4) do
            pk = peaks[a]
            screen.setColor(185, 140, 120)
            --screen.drawText(40*a, 2, ('%5.2fHz'):format((pk[1]/width)*max_frequency))
            screen.setColor(160, 120, 0)
            y = math.max(height-factor*(pk[2]-mi), 28)
            screen.drawCircle(pk[1], y, 2)
            screen.drawText(pk[1]+4, y-(y%10), ('%4.1fHz'):format((pk[1]/width)*max_frequency))
        end

    end
end