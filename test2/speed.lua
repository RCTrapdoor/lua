function generateSample(noiseAmount)
    return noiseAmount*(math.random()-0.5), noiseAmount*(math.random()-0.5)
end

noise = 2
lastX, lastY = generateSample(noise)
velX, velY = 0, 0
speed = 0

for i = 1, 1000000 do
    currentX, currentY = generateSample(noise)
    velX = velX * 0.995 + currentX * 0.005
    velY = velY * 0.995 + currentY * 0.005
    lastX = currentX
    lastY = currentY
end
print("Average speed of the stationary object is "..(velX^2 + velY^2)^0.5)