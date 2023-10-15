--lua color table reference list--
o1=ocean
s1=shallows
l1=land
g1=grass
s2=sand
s3=snow
s4=screen
t1=table
g2=green
d1=debug

--lua map color table--
function mapcolor(o1,s1,l1,g1,s2,s3)
        s4.setMapColorOcean(t1.unpack(
            ({
                g2={0,5,0},
                d1={0,0,0}
            })[o1]
        ));
        s4.setMapColorShallows(t1.unpack(
            ({
                g2={0,10,0},
                d1={0,0,0}
            })[s1]
        ));
        s4.setMapColorLand(t1.unpack(
            ({
                g2={0,20,0},
                d1={0,0,0}
            })[l1]
        ));
        s4.setMapColorGrass(t1.unpack(
            ({
                g2={0,25,0},
                d1={0,0,0}
            })[g1]
        ));
        s4.setMapColorSand(t1.unpack(
            ({
                g2={0,15,0},
                d1={0,0,0}
            })[s2]
        ));
        s4.setMapColorSnow(t1.unpack(
            ({
                g2={0,30,0},
                d1={0,0,0}
            })[s3]
        ));
end

--lua text color table--
function textcolor(i)
    s4.setColor(t1.unpack(
        ({
            g2={0,0,0},
            d1={0,0,0}
        })[i]
    ));
end

--lua line color table--
function linecolor(i)
    s4.setColor(t1.unpack(
        ({
            g2={0,0,0},
            d1={0,0,0}
        })[i]
    ));
end
    
--lua kentucky windage calculator reference list--
sb=output.setBool
set_number=output.setNumber
gn=input.getNumber
gb=input.getBool

--brains of the lua kentucky windage calculator--
function onTick()
X1=gn(1)
Y1=gn(2)
X2=gn(3)
Y2=gn(4)
end

--this lua draws the map--
function onDraw()
s4_w=s4.getWidth()
s4_h=s4.getHeight()
s4.drawMap(X1, Y1, 50)
mapcolor("g2","g2","g2","g2","g2","g2")
PX1,PY1=map.mapToScreen(X1,Y1,50,s4_w,s4_h,X1,Y1)
PX2,PY2=map.mapToScreen(X2,Y2,50,s4_w,s4_h,X2,Y2)
s4.drawLine(PX1,PY1,PX2,PY2)
s4.drawCircle(PX2,PY2,10)
end  