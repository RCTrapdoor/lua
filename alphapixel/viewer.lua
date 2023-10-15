-- Author: Trapdoor
-- GitHub: Trapdoor
-- Workshop: Trapdoor

--Trapdoor--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@section CONFIG
require("_build._simulator_config") -- LifeBoatAPI allows you to use lua's "require" keyword. see the /build/_simulator_config.lua file for how to configure the simulator
--require("LifeBoatAPI") -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library
---@endsection

ticks = 0

frames = {}
number_of_frames = 70

do
    nclock = os.clock()
    for frame_number = 0, number_of_frames-1 do
        --lclock = os.clock()
        frames[frame_number] = {}

        --local frame = {}
        local px = 0
        local data = ""
        local t = ""
        
        for part = 0, 13 do
            t = property.getText(("frame%.fo%.f"):format(frame_number, part))
            if not t then
                print(frame_number, part)
                break
            end
            data = data .. t
        end

        for i = 1, #data-6, 6 do
            px = px + 1
            table.insert(frames[frame_number], {tonumber(data:sub(i, i+1))*2.55, tonumber(data:sub(i+2, i+3))*2.55, tonumber(data:sub(i+4, i+5))*2.55})
        end
            c = 0
            -- for s in string.gmatch(t, '%d%d') do
            --     table.insert(frames[frame_number][c//3], tonumber(s))
            --     c = c + 1
            -- end
        --print(frame_number, i, os.clock()-lclock, px)
        --frames[frame_number] = frame
        --debug.log(frame_number)
    end
    print(os.clock()-nclock)
end

-- getFrames()

function onTick()
	ticks = ticks + 1
end

function onDraw()
    width, height = screen.getWidth(), screen.getHeight()
    -- print(width, height)
    -- local frame, px = "", 0
    
    -- for part = 0, 13 do
    --     print(("frame%.fo%.f"):format((ticks // 5) % number_of_frames, part))
    --     t = property.getText(("frame%.fo%.f"):format((ticks // 5) % number_of_frames, part))
    --     if not t then
    --         break
    --     end
    --     frame = frame .. t
    -- end
    -- ltime = os.clock()
    -- for r,g,b in frame:gmatch('(%d%d)(%d%d)(%d%d)') do
    --     if px % 1000 == 0 then
    --         print(r,g,b)
    --     end
    --     screen.setColor(tonumber(r)*2.55, tonumber(g)*2.55, tonumber(b)*2.55)
    --     screen.drawRect(px%width, px//width, 1, 0)
    --     px = px + 1
    -- end
    -- print(px, os.clock()-ltime)
    for px_key, pixel in ipairs(frames[ticks % number_of_frames]) do
        if #pixel == 3 then
            screen.setColor(pixel[1], pixel[2], pixel[3])
            screen.drawRect((px_key-1)%width, (px_key-1)//height, 1, 0)
        end
    end
    
end
