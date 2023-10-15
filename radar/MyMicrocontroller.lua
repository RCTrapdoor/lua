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
        simulator:setInputBool(31, simulator:getIsClicked(1))     -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(31, simulator:getSlider(1))      -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2))     -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50) -- set input 32 to the value from slider 2 * 50
    end

    ;
end
---@endsection


--[====[ IN-GAME CODE ]====]

tau = 2 * math.pi

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!
-- Matrix multiplication function
local function matrixMultiply(a, b)
    local result = {}
    for i = 1, #a do
        result[i] = {}
        for j = 1, #b[1] do
            local sum = 0
            for k = 1, #a[1] do
                sum = sum + a[i][k] * b[k][j]
            end
            result[i][j] = sum
        end
    end
    return result
end

-- Define the target's local coordinates provided by the radar
local localElevation = 0.25 -- Placeholder value for local elevation in turns
local localAzimuth = 0 -- Placeholder value for local azimuth in turns
local distance = 100 -- Placeholder value for distance

-- Define the roll, pitch, and yaw angles of the plane
local roll = 0 -- Placeholder value for roll in turns
local pitch = 0 -- Placeholder value for pitch in turns
local yaw = 0.25 -- Placeholder value for yaw in turns

-- Convert angles to radians
local tau = 2 * math.pi
roll = roll * tau
pitch = pitch * tau
yaw = yaw * tau

-- Define the quaternion rotations for roll, pitch, and yaw
local rollQuaternion = {math.cos(roll/2), 0, 0, math.sin(roll/2)}
local pitchQuaternion = {math.cos(pitch/2), math.sin(pitch/2), 0, 0}
local yawQuaternion = {math.cos(yaw/2), 0, 0, math.sin(yaw/2)}

-- Convert local azimuth and elevation to radians
local azimuthRad = localAzimuth * tau
local elevationRad = localElevation * tau

-- Convert local azimuth and elevation to quaternion representation
local localQuaternion = {
  math.cos(elevationRad/2) * math.cos(azimuthRad/2),
  math.cos(elevationRad/2) * math.sin(azimuthRad/2),
  math.sin(elevationRad/2) * math.sin(azimuthRad/2),
  math.sin(elevationRad/2) * math.cos(azimuthRad/2)
}

-- Apply roll, pitch, and yaw rotations to the local quaternion
local rotatedQuaternion = {
  rollQuaternion[1] * localQuaternion[1] - rollQuaternion[2] * localQuaternion[2] - rollQuaternion[3] * localQuaternion[3] - rollQuaternion[4] * localQuaternion[4],
  rollQuaternion[1] * localQuaternion[2] + rollQuaternion[2] * localQuaternion[1] - rollQuaternion[3] * localQuaternion[4] + rollQuaternion[4] * localQuaternion[3],
  rollQuaternion[1] * localQuaternion[3] + rollQuaternion[2] * localQuaternion[4] + rollQuaternion[3] * localQuaternion[1] - rollQuaternion[4] * localQuaternion[2],
  rollQuaternion[1] * localQuaternion[4] - rollQuaternion[2] * localQuaternion[3] + rollQuaternion[3] * localQuaternion[2] + rollQuaternion[4] * localQuaternion[1]
}

rotatedQuaternion = {
  pitchQuaternion[1] * rotatedQuaternion[1] + pitchQuaternion[2] * rotatedQuaternion[2] - pitchQuaternion[3] * rotatedQuaternion[3] - pitchQuaternion[4] * rotatedQuaternion[4],
  pitchQuaternion[1] * rotatedQuaternion[2] - pitchQuaternion[2] * rotatedQuaternion[1] + pitchQuaternion[3] * rotatedQuaternion[4] + pitchQuaternion[4] * rotatedQuaternion[3],
  pitchQuaternion[1] * rotatedQuaternion[3] + pitchQuaternion[2] * rotatedQuaternion[4] + pitchQuaternion[3] * rotatedQuaternion[1] - pitchQuaternion[4] * rotatedQuaternion[2],
  pitchQuaternion[1] * rotatedQuaternion[4] - pitchQuaternion[2] * rotatedQuaternion[3] + pitchQuaternion[3] * rotatedQuaternion[2] + pitchQuaternion[4] * rotatedQuaternion[1]
}

rotatedQuaternion = {
  yawQuaternion[1] * rotatedQuaternion[1] - yawQuaternion[2] * rotatedQuaternion[2] - yawQuaternion[3] * rotatedQuaternion[3] - yawQuaternion[4] * rotatedQuaternion[4],
  yawQuaternion[1] * rotatedQuaternion[2] + yawQuaternion[2] * rotatedQuaternion[1] - yawQuaternion[3] * rotatedQuaternion[4] + yawQuaternion[4] * rotatedQuaternion[3],
  yawQuaternion[1] * rotatedQuaternion[3] + yawQuaternion[2] * rotatedQuaternion[4] + yawQuaternion[3] * rotatedQuaternion[1] - yawQuaternion[4] * rotatedQuaternion[2],
  yawQuaternion[1] * rotatedQuaternion[4] - yawQuaternion[2] * rotatedQuaternion[3] + yawQuaternion[3] * rotatedQuaternion[2] + yawQuaternion[4] * rotatedQuaternion[1]
}

-- Convert the resulting quaternion back to azimuth and elevation angles
local globalAzimuth = math.atan(2 * (rotatedQuaternion[1] * rotatedQuaternion[2] + rotatedQuaternion[3] * rotatedQuaternion[4]), 1 - 2 * (rotatedQuaternion[2]^2 + rotatedQuaternion[3]^2))
local globalElevation = math.asin(2 * (rotatedQuaternion[1] * rotatedQuaternion[3] - rotatedQuaternion[4] * rotatedQuaternion[2]))

-- Convert global azimuth and elevation to radians
globalAzimuth = globalAzimuth % tau
globalElevation = globalElevation % tau

-- Calculate global X, Y, and Z coordinates
local globalX = distance * math.cos(globalElevation) * math.sin(globalAzimuth)
local globalY = distance * math.sin(globalElevation)
local globalZ = distance * math.cos(globalElevation) * math.cos(globalAzimuth)

-- Print the resulting global coordinates
print("Global X: " .. globalX)
print("Global Y: " .. globalY)
print("Global Z: " .. globalZ)