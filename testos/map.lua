width, height = 288, 160

function onTick()
    gps_x = input.getNumber(1)
    gps_y = input.getNumber(2)
    zoom = input.getNumber(3)

    screenX, screenY = map.mapToScreen(gps_x, gps_y, zoom, width, height, 10, 1)
end

function onDraw()
    screen.drawMap(gps_x, gps_y, zoom)
    screen.setColor(255, 0, 0)
    screen.drawCircle(screenX, screenY, 2)
end
