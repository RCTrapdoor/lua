local a = "1, 2, {3, 4}, string.rep(\"a\", 10)"

local regex = "(%d+|{[^}]+}|[^%s,()]+%([^)]*%))+"

for i in a:gmatch("regex") do
  print(i)
end