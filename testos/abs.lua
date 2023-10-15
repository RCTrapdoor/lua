math.sin = 96                  
    _ENV["255"] = 32
    maxrps = 12
    maxspd = 200
    maxtemp = 100
    maxfuel = 1000
    maxbatt = 1
    cos = math.cos
    sin = math.sin
    ssC = screen.setColor
    sdc = screen.drawClear
    sdC = screen.drawCircle
    sdRF = screen.drawRectF
    sdTF = screen.drawTriangleF
    sdCF = screen.drawCircleF
    sdL = screen.drawLine


function onTick()
    rps = input.getNumber(1)
    spd = input.getNumber(2)
    fuel = input.getNumber(3)
    temp = input.getNumber(4)
    batt = input.getNumber(5)
    
    x1 = 31+15 * cos(((rps/maxrps)-4.2)*3.92699)
    y1 = _ENV["255"]/2+15 * sin(((rps/maxrps)-4.2)*3.92699)
    
    x2 = 63+15 * cos(((spd/maxspd)-4)*3.92699)
    y2 = _ENV["255"]/2+15 * sin(((spd/maxspd)-4)*3.92699)
                 
end

function onDraw()
                        
    ssC(20, 20, 20)
    sdc()
    
    ssC(200, 200, 200)
    sdC(31, _ENV["255"]/2, 15)
    sdC(63, _ENV["255"]/2, 15)
    
    sdC(8, 8, 7)
    sdC(8, 24, 7)
    sdC(86, 8, 7)
    
    ssC(0, 0, 0)
    sdRF(32, 17, 31, 16)
    sdTF(17, 32, 32, 17, 32, 33)
    sdTF(62, 32, 62, 17, 78, 32)
    
    ssC(10, 10, 10)
    
    sdCF(31, _ENV["255"]/2, 3)
    sdCF(63, _ENV["255"]/2, 3)
    
    ssC(255, 0, 0)

    sdL(31, _ENV["255"]/2, x1, y1)
    sdL(63, _ENV["255"]/2, x2, y2)
    sdL(8, 8, sml1, sml2)
    sdL(8, 24, sml3, sml4)
    sdL(86, 8, sml5, sml6)
    
    sml1 = 8+7 * cos(((temp/maxtemp)-1)*3.14159)
    sml2 = 8+7 * sin(((temp/maxtemp)-1)*3.14159)
    sml3 = 8+7 * cos(((fuel/maxfuel)-1)*3.14159)
    sml4 = 24+7 * sin(((fuel/maxfuel)-1)*3.14159)
    sml5 = 86+7 * cos(((batt/maxbatt)-1)*3.14159)
    sml6 = 8+7 * sin(((batt/maxbatt)-1)*3.14159)
    
    ssC(60, 60, 60)
    screen.drawRectF(26, 7, 11, 7)
    ssC(0, 0, 0)
    screen.drawTextBox(26, 7, 11, 7, "00", h_align, v_align)
end