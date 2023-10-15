waypoints = {}
sn = 0
co = 0
function onTick()
    set_coord = input.getBool(1) -- set coordicates
    xi = input.getNumber(1) --x input
    yi = input.getNumber(2) --y input
    d = input.getNumber(3) --distance from target
    if set_coord then 
    table.insert(waypoints,{x = xi, y = yi, ss = sn})    
    sn = sn + 1
    end
    for k = co, #waypoints,xc, yc,sn do          
    output.setNumber(1,xc) --x output
    output.setNumber(2,yc) --Y output
    end
    if d <= 200 then co = co+1 end
    if co >= sn then co = 0 sn = 0 end
end

function onDraw()
    w = screen.getWidth()                  
    h = screen.getHeight()                    
    screen.setColor(0, 255, 0)
    
    for #waypoints,xc,yc,sn  do               
    screen.drawText(0,((sn*5)+5),string.format("X=%.2f","Y=%.2f","SET=%.2f",xc,yc,sn))
    end
end