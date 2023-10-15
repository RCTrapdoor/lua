ans = math.min({10, 6, 8, 9, 5, 7, 3, 4, 2, 1})
for k, v in pairs(ans) do
    print(k, v)
end
print(table.sort(ans)[1])