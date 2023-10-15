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

function isrec(x,y,rX,rY,rW,rH)
	return x > rX and y > rY and x < rX+rW and y < rY+rH
end

numm=""
val=""
enter = false
function numpad(p)
	screen.setColor(0,0,0)
	screen.drawRectF(p[1],p[2],32,32)
	screen.setColor(0,255,0)
	a=0
	if #numm>6 then a=-5*(#numm-6)end
	if t%30<20 then screen.drawLine(p[1]+math.min(5*5,#numm*5)+2,p[2]+32/4-2,p[1]+math.min(5*5,#numm*5)+5,p[2]+32/4-2)end
	screen.drawText(p[1]+a+1,p[2]+1,numm)
	if #numm>6 then
		screen.setColor(0,0,0,80)
		for i=0,15 do 
			screen.drawRectF(i-10,1,5,32/4-2)
		end
	end
	mp={p[1],p[2]}
	p[2]=p[2]+(32/4-1)
	a="-E1234567890"
	b={0,0}
	c={}
	for i=1,#a do
		table.insert(c,{p[1]+b[1],p[2]+b[2],32/4,32/4,string.sub(a,i,i)})
		screen.setColor(20,20,20)
		screen.drawRect(p[1]+b[1],p[2]+b[2],32/4,32/4)
		screen.setColor(100,200,200)
		screen.drawText(p[1]+b[1]+2,p[2]+b[2]+2,string.sub(a,i,i))
		if b[1]>=6*3 then
			b[2]=b[2]+(32/4)
			b[1]=0
		else	
			b[1]=b[1]+(32/4)
		end
	end
	screen.setColor(20,20,20)
	--screen.drawRect(p[1],32/4,32,32-32/4)
	screen.setColor(50,100,50)
	screen.drawRect(p[1],p[2],32/4,32/4)
	-- screen.drawRect(p[1]+p[1]/4,p[2],32/4,32/4)
	enter = false
	if click then
		for i=1,#c do
			if isrec(to.x,to.y,c[i][1],c[i][2],c[i][3],c[i][4]) then
				screen.drawRectF(c[i][1],c[i][2],c[i][3],c[i][4])
				if i==1 then
					if #numm<1 then
						numm="-"
					else
						numm=string.sub(numm,0,#numm-1)
						numm=numm:sub(0, #numm-1)
					end
				end
				if i==2 then
					val=tonumber(numm)
					numm=""
					enter = true
				end
				if #numm<=7 and i~=1 and i~=2 then
					numm=numm..c[i][5]
				end
			end
		end
		if isrec(to.x,to.y,mp[1],mp[2],32,32/4) then numm=numm.."." end
	end
	return val
end

t=0
function onTick()
	click = input.getBool(1) and not press
	press = input.getBool(1)
	to={x=input.getNumber(3),y=input.getNumber(4)}
	output.setNumber(1,val)
	output.setBool(1,enter)
	t=t+1
end

function onDraw()
	w=screen.getWidth()
	h=screen.getHeight()
	
	val=numpad({60,40})
end

