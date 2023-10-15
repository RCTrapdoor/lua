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
    simulator:setScreen(1, "2x2")
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
--define som e global variables for snek
speed = 1
speedX = 0
speedY = 0
size = 4
posX = 5
posY = 10
isAlive = true


width = 64
height = 64

--initialize the map
grid = {}
for y = 1, height do
  grid[y] = {}
  for x = 1, width do
    grid[y][x] = 0
  end
end



-- Tick function that will be executed every logic tick (60 times per second)
function onTick()
    --register keypresses
    ws = input.getNumber(1)
    ad = input.getNumber(2)
    --Set direction for snek

    --pressing up
    if ws > 0 and speedY == 0 then

        speedY = -speed 
        speedX = 0

    --pressing down
    elseif ws < 0 and speedY == 0 then

        speedY = speed 
        speedX = 0

    end
    --pressing right
    if ad > 0 and speedX == 0 then

        speedX = speed 
        speedY = 0
    --pressing left
    elseif ad < 0 and speedX == 0 then

        speedX = -speed 
        speedY = 0

    end

    --Move snek
    posX = posX + speedX
    posY = posY + speedY

    --if snek moves beyond the screen loop around
    if posX > 64 then posX=1
        elseif posX < 1 then posX=64
    end
    if posY > 64 then posY=1
        elseif posY < 1 then posY=64
    end

    --mark on the grid where head has been
    grid[posX][posY]=1

    grid[15][15]=10

end

-- Draw function that will be executed when this script renders to a screen
function onDraw()
    w = screen.getWidth()                  -- Get the screen's width and height
    h = screen.getHeight()
    screen.setColor(0, 255, 0)             -- Set draw color to green
    screen.drawRect(0, 0, w-1, h-1)

    --Draw sneks head
    screen.drawRect(posX,posY, 1, 1)

    --Draw sneks body i e the parts of the map where head has passed
    for y = 1, height do
      for x = 1, width do
        if grid[x][y] == 1 then
            screen.drawRect(grid[x],grid[y], 1, 1)
        end
      end
    end
    --debug
    screen.setColor(255, 255, 0)
end