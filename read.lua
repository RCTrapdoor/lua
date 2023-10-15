
frame = {{"r", "g", "b"}}
data = "040506506070"

for i = 1, #data, 6 do
    table.insert(frame, {data:sub(i, i+1), data:sub(i+2, i+3), data:sub(i+4, i+5)})
end

for k,d in ipairs(frame) do
    print(k, d[1], d[2], d[3])
end


frames = {}
for frame_number = 1, amount_of_frames do
    data = property.getText("Frame Data number "..frame_number)
    frame = {}
        for i = 1, #data, 6 do
            table.insert(frame, {data:sub(i, i+1), data:sub(i+2, i+3), data:sub(i+4, i+5)})
        end
    table.insert(frames, frame}
end