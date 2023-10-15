liste = {1, 2, 3, 4}

time = os.clock()
for i = 1, 1000000 do
    a = liste[0]
    table.remove(liste, 0)
    table.insert(liste, a)
end
print(os.clock() - time)