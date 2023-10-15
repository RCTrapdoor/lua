simulator:setScreen(1, "2x2")

width = 2*32
height = 2*32

grid = {}
for i = 1, width do
    grid[i] = {}
    for j = 1, height do
        grid[i][j] = math.random()*2 - 1
    end
end

base_grid = {}
for i = 1, width do
    base_grid[i] = {}
    for j = 1, height do
        base_grid[i][j] = 0
    end
end

function drawPixel(x, y, color)
    -- color = math.min(1, math.max(0, color))
    screen.setColor(color * 255, color * 255, color * 255)
    screen.drawLine(x, y, x+1, y)
end

function activation(x)
    return 1 - 1/math.exp(-x^2)
end

function copy_grid(grid)
    new_grid = {}
    for i = 1, width do
        new_grid[i] = {}
        for j = 1, height do
            new_grid[i][j] = grid[i][j]
        end
    end
    return new_grid
end

kernel = {
    {0.68, -0.9, 0.68},
    {-0.9, -0.66, -0.9},
    {0.68, -0.9, 0.68}
}

function onTick()
    isClick = input.getBool(1) and not isPressed
    isPressed = input.getBool(1)
    -- convolve, wrap around all edges
    touch = {x = input.getNumber(3), y = input.getNumber(4)}
    if isPressed then
        grid[touch.x + 1][touch.y + 1] = math.random()
    end
    new_grid = copy_grid(base_grid)
    for i = 1, width do
        for j = 1, height do
            new_grid[i][j] = 0
            for k = -1, 1 do
                for l = -1, 1 do
                    new_grid[i][j] = grid[(i+k-1)%width + 1][(j+l-1)%height + 1] * kernel[k + 2][l + 2]
                    -- new_grid[i][j] = math.max(0, math.min(1, grid[(i+k-1)%width + 1][(j+l-1)%height + 1] * kernel[k + 2][l + 2]))
                end
            end
        end
    end
    grid = new_grid
    -- draw
end

function onDraw()
    for i = 1, width do
        for j = 1, height do
            drawPixel(i, j, activation(grid[i][j]))
        end
    end
end