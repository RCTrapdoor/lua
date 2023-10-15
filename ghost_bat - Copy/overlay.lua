-- Author: <Authorname> (Please change this in user settings, Ctrl+Comma)
-- GitHub: <GithubLink>
-- Workshop: <WorkshopLink>
--
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


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

--overlay
w,h = 288, 160
function isrec(x,y,rX,rY,rW,rH)return x>rX and y>rY and x<rX+rW and y<rY+rH end

btn = {
	{0,0,15,15, "M", 0, 0},
	{273,0,15,15, "+", 0, 0},
	{273,145,15,15, "-", 0, 0},
    {0, 145, 15, 15, "R", 0, 0}
}
nav=0
function onTick()
    nav = 0
	click = input.getBool(7) and not press
	press = input.getBool(7)
	to={x=input.getNumber(13),y=input.getNumber(14)}
	
	men=false
	if press then
		for i=1,#btn do
			if isrec(to.x,to.y,table.unpack(btn[i])) then
                nav = i
			end
		end
	end
	output.setNumber(1,nav)
end
function onDraw()
	for i=1,#btn do
		screen.setColor(100,100,100,155)
		screen.drawRectF(btn[i][1], btn[i][2], btn[i][3], btn[i][4])
		screen.setColor(0,0,0)
		screen.drawTextBox(table.unpack(btn[i]))
		screen.drawRect(btn[i][1], btn[i][2], btn[i][3], btn[i][4])
	end
end