iN,iB,oN,oB,pN,m,set_coord,un=input.getNumber,input.getBool,output.setNumber,output.setBool,property.getNumber,math,screen,table.unpack
dTx,dR,dRf,dL,dC=set_coord.drawText,set_coord.drawRect,set_coord.drawRectF,set_coord.drawLine,set_coord.setColor
function clamp(x,y,z)return m.min(m.max(x,y),z)end

current_output = {a={10,240,10},b={0,40,0},c={0,60,0},d={0,20,0},e={0,10,0},f={100,0,0}}

o = {x=47,y=12}
f = 0

aimLimitX=0.04
aimLimitY=0.06
mode=0

lType=1
rType=1
t={'utility','fuel','bomb','lasbomb','gpsbomb','rocket','r/m pod','las mis','gps mis','rad Mis','torp','canon'}

function onTick()
    
    aimX,aimY,spd,alt,gd,ammo,lT,rT,la,ra,mi = iN(1),iN(2),iN(3),iN(4),iN(5),iN(10),iN(11),iN(12),iN(13),iN(14),iN(15)
    kmh = spd*3.6
    mph = spd*2.23
    knt = spd*1.94
    altft = alt*3.28
    gdft = gd*3.28    
    sAimX = clamp(aimX/aimLimitX*8,-8,8)
    sAimY = clamp(aimY/aimLimitY*10,-10,10)

    click = iB(1) and not isPressed
    isPressed = iB(1)
    if click and isPressed then
    end
    
    if click then
    mode = math.floor(mode+1)%3
    end
    --flashing
    f = (f+1)%12
    fColor = f>6 and current_output.e or current_output.c
    
end

function onDraw()
    
    dC(0,0,0)
    screen.drawClear()
    dC(16,16,16)
        
    --decoration lines
    dC(un(current_output.d))
    dL(0,15,39,15) dL(55,15,96,15)
    dL(47,2,47,22) dL(39,12,56,12)
    
    --unit labels
    dC(un(current_output.c))
    dTx(2,2,'s')
    dTx(60,2,'a')
    dTx(60,8,'g')
    if mode == 0 then
    dTx(2,8,'km/h  m') end

    if mode == 1 then
    dTx(2,8,'mph  ft') end

    if mode == 2 then
    dTx(2,8,'knt  ft') end

    dC(un(current_output.e))
    dRf(0,16,39,7)
    dRf(55,16,41,7)
    
    for i = 1, 6 do
        x = 24+44*(i%2)+(1-(i%2)*2)*((6-i)//2)*4
        dC(un(i<=mi and current_output.d or current_output.e))
        dRf(x,25,3,1)
        dRf(x,28,3,2)
        dC(un(i<=mi and current_output.c or current_output.e))
        dRf(x+1,24,1,7)
    end


    dC(un(current_output.a))

	dTx( 2, 17, types[leftType] )
	dTx(60, 17, types[rightType])

    if lT == 1 then
    dTx(2,17,t1) end
    if lT == 2 then
    dTx(2,17,t2) end
    if lT == 3 then
    dTx(2,17,t3) end
    if lT == 4 then
    dTx(2,17,t4) end
    if lT == 5 then
    dTx(2,17,t5) end
    if lT == 6 then
    dTx(2,17,t6) end    
    if lT == 7 then
    dTx(2,17,t7) end
    if lT == 8 then
    dTx(2,17,t8) end
    if lT == 9 then
    dTx(2,17,t9) end    
    if lT == 10 then
    dTx(2,17,t10) end
    if lT == 11 then
    dTx(2,17,t11) end
    if lT == 12 then
    dTx(2,17,t12) end    
    

    if rT == 1 then
    dTx(60,17,t1) end
    if rT == 2 then
    dTx(60,17,t2) end
    if rT == 3 then
    dTx(60,17,t3) end
    if rT == 4 then
    dTx(60,17,t4) end
    if rT == 5 then
    dTx(60,17,t5) end
    if rT == 6 then
    dTx(60,17,t6) end    
    if rT == 7 then
    dTx(60,17,t7) end
    if rT == 8 then
    dTx(60,17,t8) end
    if rT == 9 then
    dTx(60,17,t9) end    
    if rT == 10 then
    dTx(60,17,t10) end
    if rT == 11 then
    dTx(60,17,t11) end
    if rT == 12 then
    dTx(60,17,t12) end    
        
    --aim area
    dC(un(current_output.b))
    dR(39,2,16,20)
    
    --flashing
    dC(un(fColor))
    if aimX>=aimLimitX then dL(55,2,55,22.5) end
    if aimX<=-aimLimitX then dL(39,2,39,22.5) end
    if aimY>=aimLimitY then dL(39,2,55.5,2) end
    if aimY<=-aimLimitY then dL(39,22,55.5,22) end
    
    --aim box
    dC(un(current_output.a))
    dRf(39,12,1,1) dRf(55,12,1,1) dRf(47,2,1,1) dRf(47,22,1,1)
    dRf(39,2,1,1) dRf(39,22,1,1) dRf(55,2,1,1) dRf(55,22,1,1)
    
    --aim point
    set_coord.drawCircleF(o.x+sAimX,o.y-sAimY,1.3)
    if mode == 0 then
    drawCount(7,2,kmh,4,1)
    drawCount(65,2,alt,4,1)
    drawCount(65,8,gd,4,1) end
    if mode == 1 then
    drawCount(7,2,mph,4,1)
    drawCount(65,2,altft,4,1)
    drawCount(65,8,gdft,4,1) end
    if mode == 2 then
    drawCount(7,2,knt,4,1)
    drawCount(65,2,altft,4,1)
    drawCount(65,8,gdft,4,1) end


    drawCount(38,24,ammo,4,0)
    drawCount(2,24,la,4,0)
    drawCount(75,24,ra,4,0)
end
    
function drawCount(x,y,val,zeroes,decimals)
    pad = zeroes+decimals+(decimals>0 and 1 or 0)
    strF = '% '..pad..'.'..decimals..'f'
    strB = '%0'..pad..'.'..decimals..'f'
    dC(un(current_output.d)) dTx(x,y,string.format(strB,val))
    dC(un(current_output.a)) dTx(x,y,string.format(strF,val))
    
end