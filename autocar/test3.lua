waypoints = { {10, 10}, {150, 10}, {150, 86}, {10, 86} }

seg = 20

function calcNorms()
    wpabs = {}
    wpnorm = {}
    for i = 1, #waypoints do
        to = waypoints[i]
        from = waypoints[(i- 2) % #waypoints + 1]
        wpabs_ = math.sqrt((to[1]-from[1])^2+(to[2]-from[2])^2)
        wpnorm_ = {(to[1]-from[1])/wpabs_, (to[2]-from[2])/wpabs_}
        table.insert(wpabs, wpabs_)
        table.insert(wpnorm, wpnorm_)
    end
end

calcNorms()

function onTick()
    click = input.getBool(1) and not isPressed
    isPressed = input.getBool(1)
    inX,inY = input.getNumber(3),input.getNumber(4)
    if click then
        table.insert(waypoints, {inX, inY})
        print(waypoints)
        if #waypoints > 10 then
            table.remove(waypoints, 1)
        end
        calcNorms()
    end
    --seg = input.getNumber(5)
end

function onDraw()
    for i = 1, #waypoints do
        to = waypoints[i]
        from_ = (i- 2) % #waypoints + 1
        from = waypoints[from_]
        screen.setColor(20, 250, 50)
        screen.setColor(255, 20, 20)
        
        lx1, ly1 = from[1]+wpnorm[i][1]*seg, from[2]+wpnorm[i][2]*seg
        lx2, ly2 = from[1]+wpnorm[i][1]*(wpabs[i]-seg), from[2]+wpnorm[i][2]*(wpabs[i]-seg)
        screen.drawLine(lx1, ly1, lx2, ly2)
        lx3, ly3 = lx2, ly2
        
        
        for s = 1, seg do
            x1, y1 = from[1]+wpnorm[i][1]*(wpabs[i]-seg+s), from[2]+wpnorm[i][2]*(wpabs[i]-seg+s)
            x2, y2 = to[1]+wpnorm[i%#waypoints+1][1]*(s), to[2]+wpnorm[i%#waypoints+1][2]*(s)
            x3, y3 = (1-s/seg)*x1+(s/seg)*x2, (1-s/seg)*y1+(s/seg)*y2
            screen.drawLine(lx3, ly3, x3, y3)
            lx3, ly3 = x3, y3
        end
    end
end