vars = property.getText("Variables")

function onTick()
    n,b = 1,1
    for k, v in vars:gmatch("(%w+)=(%w+)") do
        if k == "b" then b = b+1 else n = n+1 end
        _ENV[v] = input[(k == "b") and "getBool" or "getNumber"](k==b and b or n)
    end

    -- The rest of your code here
end