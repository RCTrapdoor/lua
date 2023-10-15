-- Author: Trapdoor
-- GitHub: https://github.com/RCTrapdoor
-- Workshop: https://steamcommunity.com/id/rctrapdoor/myworkshopfiles/?appid=573090
--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
pi = math.pi

function roundedRectF(x, y, w, h, r)
    screen.drawRectF(x + r, y, w - r * 2, h)
    screen.drawRectF(x, y + r, w, h - r * 2)
    screen.drawCircleF(x + r, y + r, r)
    screen.drawCircleF(x + w - r, y + r, r)
    screen.drawCircleF(x + r, y + h - r, r)
    screen.drawCircleF(x + w - r, y + h - r, r)
end

function drawArc(center_x, center_y, radius, segments, start_angle, angle_span)
    from_angle = start_angle
    for i = 0, segments do
        to_angle = start_angle + (angle_span / segments) * (i + 1)
        screen.drawLine(center_x + radius * math.cos(from_angle), center_y - radius * math.sin(from_angle),
        center_x + radius * math.cos(to_angle),   center_y - radius * math.sin(to_angle))
        from_angle = to_angle
    end
end

function roundedRect(x, y, w, h, r) -- Using drawLine and drawArc
    -- screen.drawRect(x + r, y, w - r * 2, h)
    -- screen.drawRect(x, y + r, w, h - r * 2)
    -- screen.drawCircle(x + r, y + r, r)
    -- screen.drawCircle(x + w - r, y + r, r)
    -- screen.drawCircle(x + r, y + h - r, r)
    -- screen.drawCircle(x + w - r, y + h - r, r)
    drawArc(x + r, y + r, r, 32, pi, -pi/2)
    drawArc(x + w - r, y + r, r, 32, pi/2, -pi/2)
    drawArc(x + r, y + h - r, r, 32, pi, pi/2)
    drawArc(x + w - r, y + h - r, r, 32, -pi/2, pi/2)
    screen.drawLine(x + r, y, x + w - r, y)
    screen.drawLine(x + r, y + h - 1, x + w - r, y + h - 1)
    screen.drawLine(x, y + r, x, y + h - r)
    screen.drawLine(x + w - 1, y + r, x + w - 1, y + h - r)
end


function onDraw()
    screen.setColor(255, 255, 255)
    roundedRectF(5, 5, 100, 45, 15)
    screen.setColor(0, 255, 0)
    roundedRect(5, 5, 100, 45, 15)
    screen.setColor(255, 0, 0)
    screen.drawRect(5, 5, 100, 45)
end