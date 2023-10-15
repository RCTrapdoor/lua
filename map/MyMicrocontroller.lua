--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
--- Remember to set your Author name etc. in the settings: CTRL+COMMA

require("_build._simulator_config") -- default simulator config, CTRL+CLICK it or F12 to goto this file and edit it. Its in a separate file just for convenience.
require("LifeBoatAPI")              -- Type 'LifeBoatAPI.' and use intellisense to checkout the new LifeBoatAPI library functions; such as the LBVec vector maths library

x = 0
y = 0
w = 0
h = 0
REFRSH = false
INC = 1
OFSX = 0
OFSY = 0

function onTick()
    TCH = input.getBool(1)
    TCHX = input.getNumber(3)
    TCHY = input.getNumber(4)
    GPSX = input.getNumber(5)
    GPSY = input.getNumber(6)

    compass = -input.getNumber(7) * math.pi * 2 - math.pi / 2
    --x, y = map.mapToScreen(GPSX + OFSX, GPSY + OFSY, INC, w, h, GPSX, GPSY)
    x, y = map.screenToMap(GPSX + OFSX, GPSY + OFSY, INC, w, h, GPSX, GPSY)

    tri = {}
    for i = -1, 1 do
        table.insert(tri, x + 5 * math.cos(compass + i * 2.5))
        table.insert(tri, y + 5 * math.sin(compass + i * 2.5))
    end
end

function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
    return x > rectX and y > rectY and x < rectX + rectW and y < rectY + rectH
end

function onDraw()
    screen.setMapColorOcean(13, 27, 81, 255)
    screen.setMapColorShallows(13, 27, 81, 255)
    screen.setMapColorLand(80, 80, 80, 255)
    screen.setMapColorGrass(0, 17, 1, 255)
    screen.setMapColorSand(96, 69, 0, 255)
    screen.setMapColorSnow(96, 96, 96, 255)
    screen.drawMap(GPSX + OFSX, GPSY + OFSY, INC)

    screen.setColor(0, 255, 0)

    screen.drawRect(1, 56, 7, 7)
    screen.drawText(2, 57, "Z")

    screen.drawRect(1, 26, 7, 7)
    screen.drawText(2, 27, "<")

    screen.drawRect(56, 26, 7, 7)
    screen.drawText(58, 27, ">")

    screen.drawRect(28, 56, 7, 7)
    screen.drawText(30, 57, "V")

    screen.drawRect(28, 1, 7, 7)
    screen.drawText(30, 2, "^")

    screen.drawRect(10, 56, 7, 7)
    screen.drawText(11, 57, "R")

    if isPointInRectangle(TCHX, TCHY, 1, 56, 7, 7) and TCH then
        if INC < 3 and REFRSH then
            INC = INC + 1
            REFRSH = false
        elseif INC == 3 and REFRSH then
            INC = 0
            REFRSH = false
        end
    end

    if isPointInRectangle(TCHX, TCHY, 1, 26, 7, 7) and TCH then
        OFSX = OFSX - 5
    end

    if isPointInRectangle(TCHX, TCHY, 56, 26, 7, 7) and TCH then
        OFSX = OFSX + 5
    end

    if isPointInRectangle(TCHX, TCHY, 28, 56, 7, 7) and TCH then
        OFSY = OFSY - 5
    end

    if isPointInRectangle(TCHX, TCHY, 28, 1, 7, 7) and TCH then
        OFSY = OFSY + 5
    end

    if isPointInRectangle(TCHX, TCHY, 10, 56, 7, 7) and TCH then
        if REFRSH then
            OFSY = 0
            OFSX = 0
        end
    end

    w, h = screen.getWidth(), screen.getHeight()

    screen.setColor(255, 0, 0)
    screen.drawTriangle(table.unpack(tri))
end
