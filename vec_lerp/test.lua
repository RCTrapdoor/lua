set_coord = "1,1,2,2,3,3,4,4,5,5"
-- s = property.getText("Points")

points = {}
for x, y in set_coord:gmatch("(%d+),(%d+)") do
  table.insert(points, {x = tonumber(x), y = tonumber(y)})
end

function dist(a, b)
  b = b or {x = 0, y = 0}
  return ((a.x-b.x)^2+(a.y-b.y)^2)^0.5
end

function onTick()
  gps = {x = input.getNumber(5), y = input.getNumber(6)}
--   gps = {x = 7, y = 5}

  sorted = {}
  
  for k = 1, #points do
    table.insert(sorted, {x=points[k].x, y=points[k].y})
  end

  table.sort(sorted, function(a, b) return dist(gps, a) < dist(gps, b) end)


  for k,v in ipairs(sorted) do
    print(v.x, v.y, dist(gps, v))
  end
  -- some more code

end