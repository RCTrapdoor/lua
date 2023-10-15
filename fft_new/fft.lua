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
    simulator:setScreen(1, "9x5")
    simulator:setProperty("ExampleNumberProperty", 123)

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
        simulator:setInputBool(31, simulator:getIsClicked(1))       -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(31, simulator:getSlider(1))        -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2))       -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50)   -- set input 32 to the value from slider 2 * 50
    end;
end
---@endsection

ticks = 0

tickrate = 60

tau = math.pi * 2
pi = tau / 2

max_frequency = 30

samples = 180

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
    if width then
    
    if not history2 then
        history2 = {}
        for a = 0, width do
            history2[a] = 0
        end
    end
    
    ticks = ticks + 1

    -- table.insert(history, input.getNumber(1))
    table.insert(history, math.sin((ticks / 30) * tau) + math.sin((ticks / 10) * tau))
    
    while #history >= samples do
        table.remove(history, 1)
    end
    
    mean = 0
    
    for k,d in ipairs(history) do
        mean = mean + d
    end
    
    mean = mean / #history

    for a = 1, width do
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


