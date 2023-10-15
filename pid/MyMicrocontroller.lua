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
    simulator:setInputBool(31, simulator:getIsClicked(1))         -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
    simulator:setInputNumber(31, simulator:getSlider(1))          -- set input 31 to the value of slider 1

    simulator:setInputBool(32, simulator:getIsToggled(2))         -- make button 2 a toggle, for input.getBool(32)
    simulator:setInputNumber(32, simulator:getSlider(2) * 50)     -- set input 32 to the value from slider 2 * 50
  end

  ;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!
function foo()
end

function PID(P, I, D, min, max, f)
  return {
    f = f or 1,
    g = 0,
    h = 0,
    i = 0,
    run = function(k, l, m)
      local n = l - m
      k.g = math.max(min, math.min(max, k.g + n * I))
      k.i = k.f * n + (1 - k.f) * k.i
      local o = (k.i - k.h)
      k.h = k.i
      return P * n + k.g + D * o
    end
  }
end

pid_one = PID(0, 0.001, 0, -1, 1)

ticks = 0
function onTick()
  ticks = ticks + 1
  print(pid_one:run(0, math.sin(ticks / 60)))
end

function onDraw()
  screen.drawCircle(16, 16, 5)
end

function lerp(input_start, input_end, output_start, output_end, value)
  return output_start + ((output_end - output_start) / (input_end - input_start)) * (value - input_start)
end

function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
  return x > rectX and y > rectY and x < rectX+rectW and y < rectY+rectH
end

value = 0.5

function onTick()
  isClick = input.getBool(1) and not isPressed
  isPressed = input.getBool(1)

  touch_x = input.getNumber(3)
  touch_y = input.getNumber(4)

  if isClick and isPointInRectangle(touch_x, touch_y, 3, 7, 28, 5) then
    value = lerp(3, 3 + 28, 0, 1, touch_x)
  end

  output.setNumber(1, value)
end

function onDraw()
  
  screen.setColor(0, 255, 0)
  value_x = lerp(0, 1, 3, 3 + 28, value)
  screen.drawRectF(3, 7, value_x - 2, 5)
  screen.setColor(255, 0, 0)
  screen.drawLine(value_x, 7, value_x, 7 + 5)
  screen.setColor(255, 255, 255)
  screen.drawRect(3, 7, 28,  5)
end