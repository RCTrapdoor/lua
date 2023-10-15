-- Author: Trapdoor
-- GitHub: Trapdoor
-- Workshop: Trapdoor

--Trapdoor--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey

print(tonumber(false))

require("_build._simulator_config") -- LifeBoatAPI allows you to use lua's "require" keyword. see the /build/_simulator_config.lua file for how to configure the simulator
require("LifeBoatAPI") -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library
-- Simple EPN, by Lassi#9944

lastRateX=0
lastRateY=0
lastAccX=0
lastAccY=0

navRate=property.getNumber("Rate nav") or -0.17
navAcc=property.getNumber("Acc nav") or -0.047
navJerk=property.getNumber("Jerk nav") or -0.071

smoothclosingv=0
tab = {}
ticks = 0

closingv = 0

function onTick()
	ticks = (ticks % 5) + 1
	rateX=input.getNumber(1)
	rateY=input.getNumber(2)
	distance = input.getNumber(3)
	
	if distance ~= 0 and math.abs((lastValue or distance) - distance) < 100 then
		tab[ticks] = (lastValue or distance) - distance
	end
	
	total = 0
	
	for i,v in ipairs(tab) do
		total = total + v
	end
	
	if #tab > 0 then
		closingv = -(total / #tab)
	end
		
	if math.abs(closingv)>10 then
		closingv=0
	end
	--smoothclosingv=smoothclosingv+(closingv-smoothclosingv)/2
	smoothclosingv=closingv
	Tgo=math.min(distance/math.max(closingv*60,1),10)
	
	accX=rateX-lastRateX
	accY=rateY-lastRateY
	jerkX=accX-lastAccX
	jerkY=accY-lastAccY
	
	output.setNumber(1,(rateX*navRate*math.abs(smoothclosingv) + accX*navAcc*Tgo^2 + jerkX*navJerk*Tgo)*(property.getNumber("Yaw multiplier") or 1))
	output.setNumber(2,(rateY*navRate*math.abs(smoothclosingv) + accY*navAcc*Tgo^2 + jerkY*navJerk*Tgo)*(property.getNumber("Pitch multiplier") or 1))
	
	output.setNumber(3,rateX)
	output.setNumber(4,rateY)
	output.setNumber(5,closingv)
	output.setNumber(6,smoothclosingv)
	
	lastRateX=rateX
	lastRateY=rateY
	lastAccX=accX
	lastAccY=accY
	lastValue = distance
end