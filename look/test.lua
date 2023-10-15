function bNew(x, y, t, val, cb)
    return {x=x, y=y, w=x+3*string.len(t), h=y+5, val=val, cb=cb}
end

 local bl=bNew(0, 40, "xyz", true, testFunction)

 function onTick()
    output.setNumber(10, bl.x)
    output.setNumber(11, bl.y)
    output.setNumber(12, bl.w)
    output.setNumber(13, bl.h)
 end