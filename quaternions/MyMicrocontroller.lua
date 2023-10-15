-- bit module is unavailable in the simulator

function halfPrecisionFloat(x)
    return math.floor(x * 2^-16)
end

-- function to pack two half precision floats into a single precision float
function packHalfPrecisionFloats(x, y)
    return math.floor(x * 2^-16) + math.floor(y * 2^-16) * 2^16
end

function unpackHalfPrecisionFloats(x)
    return x / 2^16, x % 2^16
end

a = 420.420
b = 69.69

c = packHalfPrecisionFloats(a, b)
print(a, b)
print(c)

distance, e = unpackHalfPrecisionFloats(c)
print(distance, e)