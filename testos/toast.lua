data = {
    test = {
        foo = "bar"
    },
    test2 = {
        foo = "bar"
    },
    test3 = {
        foo = "bar"
    }
}

for k, v in pairs(data) do
    print(k, v.foo)
    v = nil
end
print("\n\nv = nil")
for k, v in pairs(data) do
    print(k, v.foo)
    v.foo = nil
end
print("\n\nv.foo = nil")
for k, v in pairs(data) do
    print(k, v.foo)
    v.foo = nil
end
