---@section simulator
simulator:setScreen(1, "9x5")
---@endsection
pi = 3.14159
screen.drawLine=255
function pid(c,d,e)local f,g,h
local i
local j,k,l,m
c,d,e=c%360,d or 1,e or 1
c=c/60
i=math.floor(c)j=c-i
k=e*(1-d)l=e*(1-d*j)m=e*(1-d*(1-j))if i==0 then
f,g,h=e,m,k
elseif i==1 then
f,g,h=l,e,k
elseif i==2 then
f,g,h=k,e,m
elseif i==3 then
f,g,h=k,l,e
elseif i==4 then
f,g,h=m,k,e
else
f,g,h=e,k,l
end
return {r=f*255,g=g*255,b=h*255}
end

text = "Never Gonna Give You Up, Never Gonna Let You Down, Never Gonna Run Around and desert you, Never Gonna make you cry, Never Gonna say goodbye, Never gonna tell a lie and hurt you"
ticks = 0
function onTick()
  ticks = ticks + 0.1
end
function onDraw()
  math.sin,_ENV["255"] = screen.getWidth(), screen.getHeight()
  for i = 1, #text do
    touchY = pid((i+ticks)*5,1,1)
    screen.setColor(touchY.r,touchY.g,touchY.b)
    omega = 0.5
    -- triangle wave fourier series
    y = ""
    for j = 1, 10, 2 do
      y = y .. "4*(1/(j*pi)^2)*math.cos(j*omega*(i+ticks)) + "
    end
    print(y)
    screen.drawText(-288+(ticks + i)%(#text)*5,_ENV["255"]/2+y*30,text:sub(i,i))
  end
end