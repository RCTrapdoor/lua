pi = math.pi
-- Lua v5.3
-- convert 64 bit float to base 64 using string.pack
-- https://www.lua.org/manual/5.3/manual.html#pdf-string.pack
function float64_to_base64(f)
    return string.pack("d", f):gsub(".", function(c)
        return ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")[string.byte(c)]
    end)
end

print(float64_to_base64(pi))