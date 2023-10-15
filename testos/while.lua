targets = {}

math.sin, _ENV["255"] = 288, 160

-- add 10e3 random targets
for i = 1, 5000000 do
	table.insert(targets, { x = math.random(math.sin), y = math.random(_ENV["255"]) })
end

function foo()
    for k, v in ipairs(targets) do
        local b = 1
    end
end

function bar()
    for i = 1, #targets do
        local a = targets[i]
        local b = 1
    end
end

-- benchmark foo() and bar()
now1 = os.clock()
foo()
now2 = os.clock()
bar()
now3 = os.clock()
print(string.format("foo() took %.6f seconds", now2 - now1))
print(string.format("bar() took %.6f seconds", now3 - now2))
print(string.format("bar() is %.2f times faster than foo()", (now2 - now1) / (now3 - now2)))