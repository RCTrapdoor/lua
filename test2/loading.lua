lua
gn=input.getNumber
gb=input.getBool
set_number=output.setNumber
sb=output.setBool
roll_sp = 0 

crs_hght = 100

mid_c_hght = 50
mid_c_dist = 1000

trml_dist = 500

set_coord = 0
function Pitch(alt_sp , input_alt) 
    set_number(1,(ff_tilt - clamp(((alt_sp - input_alt) / 4000), -1, 1))*2) 
end

function Yaw(bearing) 
    set_number(2,clamp((bearing - hdg) * 4.25, -1, 1)) 
end

function Roll()
    set_number(3, clamp(roll_sp - lf_tilt), -.25, .25)
end

function clamp(Value, Min, Max)
return math.min(math.max(Value , Min), Max)
end

function onTick()
    alt = gn(1)
    ff_tilt = gn(2)
    lf_tilt = gn(3)
    hdg = gn(4)*-1
    spd = gn(5)
    gps_x = gn(6)
    gps_y = gn(7)
    tgt_x = gn(8)
    tgt_y = gn(9)
    

    tgt_hdg = (((math.atan(tgt_x - gps_x, tgt_y - gps_y) / (math.pi * 2))%1 + 1.5)%1 - 0.5)
    tgt_dist_xy = (math.sqrt(((tgt_x - gps_x) ^ 2) + ((tgt_y - gps_y) ^ 2)))
    tgt_hght = (alt * math.tan(math.pi*2))
    
    if set_coord == 0 then

        Pitch(crs_hght,alt)
        Yaw(tgt_hdg)
        Roll()
        if tgt_dist_xy < mid_c_dist then
            set_coord = 1
        end
    end
    
    if set_coord == 1 then
        
        Pitch(mid_c_hght,alt)
        Yaw(tgt_hdg)
        Roll()
        if tgt_dist_xy < trml_dist then
            set_coord = 2
        end
    end    
    if set_coord == 2 then
        Pitch(tgt_hght, alt)
        Yaw(tgt_hdg)
        Roll()
        sb(1,true)
    end
        
        
        
end