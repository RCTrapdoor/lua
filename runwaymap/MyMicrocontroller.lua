require("_build._simulator_config") -- default simulator config, CTRL+CLICK it or F12 to goto this file and edit it. Its in a separate file just for convenience.

ticks = 0

function onTick()
    compass = input.getNumber(1)
    