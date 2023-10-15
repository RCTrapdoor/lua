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

w,h=288,160

bnam = {
	"Settings",
	"Live view",
	"Map",
	"SDR",
	"Actions",
	"Stats"
}
bre = {}
bsel = 2
for i=1,#bnam,1 do
	table.insert(bre, {0,i*15,50,15})
end

to = {}

function smoothstep(x)
	return x*x*(3-2*x)
end

get = false
timer = 30

function isrec(x,y,rX,rY,rW,rH)
	return x > rX and y > rY and x < rX+rW and y < rY+rH
end

function onTick()
	-- get = input.getBool(32) and not get or get
	if input.getNumber(32) // 1 == 1 then
		get = true
		timer = 30
	end
	-- if get then bsel = 0 end
	if get then
		timer = math.max(0, timer-1)
		click = input.getBool(7) and not press
		press = input.getBool(7)
		to={x=input.getNumber(13),y=input.getNumber(14)}
		
		if click then
			if isrec(to.x,to.y,0,0,50,15) then
				get = false
			else
				for i=1,#bnam do
					if isrec(to.x,to.y,0,bre[i][2],50,15) then
						bsel=i
						get = false
						break
					end
				end
			end
		end
		
	else
		timer = math.min(30, timer+3)
	end
	output.setNumber(1, bsel)
end

function onDraw()
	-- if get then
		y = smoothstep(timer/30) * 15 * (#bnam+1) + 1
		screen.setColor(100,100,100,220)
		screen.drawRectF(0,-y,50,15)
		screen.setColor(0,0,0)
		screen.drawRect(0,-y,50,15)
		screen.drawTextBox(0,-y,50,15,"Menu",0,0)
		
		pos = 15
		for i=1,#bnam,1 do
			screen.setColor(55,55,55,220)
			screen.drawRectF(bre[i][0], bre[i][2]-y, bre[i][3], bre[i][4])
			screen.setColor(0,0,0)
			screen.drawTextBox(0,bre[i][2]-y,50,15,bnam[i],0,0)
			screen.drawRect(bre[i][0], bre[i][2]-y, bre[i][3], bre[i][4])
		end
		screen.setColor(255, 0, 0)
	-- end
end