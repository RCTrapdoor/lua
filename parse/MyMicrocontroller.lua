set_coord = "-1, -2, -3, -4; 1, 2, 3, 4"
lib = {}
for sprite in set_coord:gmatch("[^;]+") do
  lib[#lib+1] = {}
  for line in sprite:gmatch("[^,]+") do
    lib[#lib][#lib[#lib]+1] = tonumber(line)
  end
end

for k, v in pairs(lib) do
  print(k, table.concat(v," | "))
end