function rotPoints(points, angle)
    local rotated_points = {}
    for k = 1, #points do
        rotated_points[k] = rot2d(points[k], angle)
    end
    return rotated_points
end

function rot2d(point, angle)
    local c, s = math.cos(angle), math.sin(angle)
    local x, y = point.x, point.y
    return { x = x * c - y * s, y = x * s + y * c }
end

bar_1 = {
    { x = -4, y = 16 },
    { x = 4, y = 16 },
    { x = 4, y = 0 },
    { x = -4, y = 0 }
}
bar_2 = {
    { x = -4, y = 0 },
    { x = 4, y = 0 },
    { x = 4, y = -16 },
    { x = -4, y = -16 }
}

ticks = 0
function onTick()
    ticks = ticks + 1
    value = math.sin(ticks / 60)
    bar_3 = {
        { x = -4, y = 2 + value * 14 },
        { x = 4, y = 2 + value * 14 },
        { x = 4, y = -2 + value * 14 },
        { x = -4, y = -2 + value * 14 }
    }
    bar_1_rotated = rotPoints(bar_1, ticks / 100)
    bar_2_rotated = rotPoints(bar_2, ticks / 100)
    bar_3_rotated = rotPoints(bar_3, ticks / 100)
end

function onDraw()
    x_offset = 32
    y_offset = 32
    screen.setColor(70, 70, 70)
    screen.drawClear()
    screen.setColor(255, 0, 0)
    screen.drawTriangle(bar_1_rotated[1].x + x_offset, bar_1_rotated[1].y + y_offset, bar_1_rotated[2].x + x_offset, bar_1_rotated[2].y + y_offset, bar_1_rotated[3].x + x_offset, bar_1_rotated[3].y + y_offset)
    screen.drawTriangle(bar_1_rotated[1].x + x_offset, bar_1_rotated[1].y + y_offset, bar_1_rotated[3].x + x_offset, bar_1_rotated[3].y + y_offset, bar_1_rotated[4].x + x_offset, bar_1_rotated[4].y + y_offset)

    screen.setColor(0, 255, 0)
    screen.drawTriangle(bar_2_rotated[1].x + x_offset, bar_2_rotated[1].y + y_offset, bar_2_rotated[2].x + x_offset, bar_2_rotated[2].y + y_offset, bar_2_rotated[3].x + x_offset, bar_2_rotated[3].y + y_offset)
    screen.drawTriangle(bar_2_rotated[1].x + x_offset, bar_2_rotated[1].y + y_offset, bar_2_rotated[3].x + x_offset, bar_2_rotated[3].y + y_offset, bar_2_rotated[4].x + x_offset, bar_2_rotated[4].y + y_offset)

    screen.setColor(0, 0, 0)
    screen.drawTriangle(bar_3_rotated[1].x + x_offset, bar_3_rotated[1].y + y_offset, bar_3_rotated[2].x + x_offset, bar_3_rotated[2].y + y_offset, bar_3_rotated[3].x + x_offset, bar_3_rotated[3].y + y_offset)
    screen.drawTriangle(bar_3_rotated[1].x + x_offset, bar_3_rotated[1].y + y_offset, bar_3_rotated[3].x + x_offset, bar_3_rotated[3].y + y_offset, bar_3_rotated[4].x + x_offset, bar_3_rotated[4].y + y_offset)
end
