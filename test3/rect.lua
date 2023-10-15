
function check_collision(box1, box2)
    if box1[1] < box2[1] + box2[3] and box1[1] + box1[3] > box2[1] then
        if box1[2] < box2[2] + box2[4] and box1[2] + box1[4] > box2[2] then
            return true
        end
    end
    return false
end

a = {0, 0, 10, 10}
b = {45, 45, 5, 5}

function onTick()
    touch = {x = input.getNumber(3), y = input.getNumber(4)}
    a[1] = touch.x - a[3] / 2
    a[2] = touch.y - a[4] / 2
end

function onDraw()
    screen.setColor(0, 0, 255)
    screen.drawRect(a[1], a[2], a[3], a[4])
    screen.setColor(0, 255, 0)
    screen.drawRect(b[1], b[2], b[3], b[4])
    if check_collision(a, b) then
        screen.setColor(255, 255, 255)
        screen.drawText(0, 0, "Collision")
        screen.drawRect(a[1], a[2], a[3], a[4])
    end
end