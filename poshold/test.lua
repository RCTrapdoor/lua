x_vel = 0.5
x_pos = 0

function onTick()
  x_pos = x_pos + x_vel

  if x_pos >= 32 or x_pos <= 0 then
    x_vel = -x_vel
  end

  print(x_pos)
end