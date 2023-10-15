shape = {{0, -12}, {3, -8}, {-3, -8}, {3, 8}, {-3, 8}, {0, 15}}

rotated_shape = {}

angle = 0

function onTick()
    -- angle = input.getNumber(1) * math.pi * 2
    angle = angle + 0.01

    for i = 1, #shape do
        rotated_shape[i] = {
            shape[i][1] * math.cos(angle) - shape[i][2] * math.sin(angle),
            shape[i][1] * math.sin(angle) + shape[i][2] * math.cos(angle)
        }
    end

end

function onDraw()
    width, height = screen.getWidth(), screen.getHeight()
    cx, cy = width / 2, height / 2

    screen.setColor(30, 30, 30)

    for i = 1, 4 do
        screen.drawTriangleF(cx + rotated_shape[i][1], cy + rotated_shape[i][2],
                             cx + rotated_shape[i + 1][1],
                             cy + rotated_shape[i + 1][2],
                             cx + rotated_shape[i + 2][1],
                             cy + rotated_shape[i + 2][2])
    end
end
