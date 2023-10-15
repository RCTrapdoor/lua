foo = {}

foo["bar"] = function(x) return x^2 end

foo.bar(2) -- return 4
foo.bar(3) -- return 9
foo.bar(4) -- returns 16
foo.bar(5) -- returns 25