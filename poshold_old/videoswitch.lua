require("_build._simulator_config")

drf=screen.drawRectF
pgt=property.getText

ticks = 0
channel = 1

labels = {}
for i = 1, 4 do
    labels[i] = property.getText("Label "..i)
end

function onTick()
    ticks = ticks + 1
    if channel ~= (input.getNumber(1) // 1) + 1 then
        ticks = 0
    end
    channel = (input.getNumber(1) // 1) + 1
end

function onDraw()
    w,h = screen.getWidth(),screen.getHeight()
    if ticks < 60 then
        screen.setColor(0, 0, 0, math.max(0, math.min(255, 512 - (ticks / 10) * 255)))
        screen.drawRectF(0, 0, w, h)
        screen.setColor(255, 255, 255, math.max(0, math.min(255, 512 - (ticks / 15) * 255)))
        dst((w - (#labels[channel] * 4 - 0.5)*(w//32))/2, (h - w//32 * 4 - 2) / 2, labels[channel], w//32, 1, true)
    end
end

FONT=pgt("FONT1")..pgt("FONT2")
FONT_D={}
FONT_S=0
for n in FONT:gmatch("....")do FONT_D[FONT_S+1]=tonumber(n,16)FONT_S=FONT_S+1 end
function dst(x,y,t,s,r,m)s=s or 1
r=r or 1
if r>2 then t=t:reverse()end
t=t:upper()for c in t:gmatch(".")do
ci=c:byte()-31 if 0 < ci and ci <= FONT_S then
for i=1,15 do
if r>2 then p=2^i else p=2^(16-i)end
if FONT_D[ci]&p==p then
xx,yy=((i-1)%3)*s,((i-1)//3)*s
if r%2==1 then drf(x+xx,y+yy,s,s)else drf(x+5-yy,y+xx,s,s)end
end
end
if FONT_D[ci]&1==1 and not m then
i=2*s
else
i=4*s
end
if r%2==1 then x=x+i else y=y+i end
end
end
end