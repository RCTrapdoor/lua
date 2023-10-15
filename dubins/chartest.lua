pi = 1
for k = 1, 10000 do
    pi = pi + 2 * math.sin(k)/k
    print(math.sin(k)/k)
end
print(pi)