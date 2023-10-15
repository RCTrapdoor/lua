-- Author: Trapdoor
-- GitHub: Trapdoor
-- Workshop: Trapdoor

--Trapdoor--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

require("_build._simulator_config") -- LifeBoatAPI allows you to use lua's "require" keyword. see the /build/_simulator_config.lua file for how to configure the simulator
require("LifeBoatAPI") -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library


myButton = LifeBoatAPI.LBTouchScreen:lbtouchscreen_newButton(0, 1, 31, 9) -- using the TouchScreen functionality from LifeBoatAPI - make a simple button
isRedToggle = false -- toggle to keep track of whether to draw in red or green
ticks = 0

function onTick()
    LifeBoatAPI.LBTouchScreen:lbtouchscreen_onTick() -- touchscreen handler provided by LifeBoatAPI. Handles checking for clicks/releases etc.
    ticks = ticks + 1

    -- example: touchscreen buttons
    if myButton:lbbutton_isClicked() then
        isRedToggle = not isRedToggle    
    end

    -- example debugging random values, and checking things per tick
    local myRandomValue = math.random()    
    if(ticks%100 == 0) then
        -- Debugging Tip (F6 to run Simulator):
        --  By clicking just left of the line number (left column), you can set a little red dot; called a "breakpoint"
        --  When you run this in the LifeBoatAPI Simulator, the debugger will stop at each breakpoint and let you see the memory values
        -- You can also look at the "callstack" to see which functions were called to get where you are.
        --  Put a breakpoint to the left of this a = nil statement, and you'll be able to see what the value of "myRandomValue" is by hovering over it
        a = nil;
    end
end


function onDraw()
	-- when you simulate, you should see a slightly green circle growing over 10 seconds and repeating.
    -- Clicking the button, will change between red and green
    if isRedToggle then
        LifeBoatAPI.LBColorSpace.lbcolorspace_setColorGammaCorrected(255, 125, 125) -- replacement for screen.setColor, that corrects the colours to be less washed out
    else
        LifeBoatAPI.LBColorSpace.lbcolorspace_setColorGammaCorrected(125, 255, 125)
    end
	
	screen.drawCircleF(16, 16, (ticks%600)/60)

    myButton:lbbutton_drawRect("Toggle") -- basic button drawing, you can of course use the .x,y,width,height property from the button to draw something more custom instead
end

--- Ready to put this in the game?
--- Just hit F7 and then copy the (now tiny) file from the /out/ folder


