data1 = {}
data2 = {}
data3 = {}
data4 = {}

Blue = property.getText("Blue")


Red = property.getText("Red")


Yellow = property.getText("Yellow")


Green = property.getText("Green")


function onTick()
    max_data_points = input.getNumber(5)
    --add the current value of the input to the data table
    input_value1 = input.getNumber(1)
    input_value2 = input.getNumber(2)
    input_value3 = input.getNumber(3)
    input_value4 = input.getNumber(4)
    
    table.insert(data1, input_value1)
    table.insert(data2, input_value2)
    table.insert(data3, input_value3)
    table.insert(data4, input_value4)
    
    --remove oldest data point from the table
    if #data1 > max_data_points then
        table.remove(data1, 1)
    end
    
    if #data2 > max_data_points then
        table.remove(data2, 2)
    end
    
    if #data3 > max_data_points then
        table.remove(data3, 3)
    end
    
    if #data4 > max_data_points then
        table.remove(data4, 4)
    end
        
        
end


function onDraw()
    w = screen.getWidth()
    h = screen.getHeight()
    
    --set background color to white
    screen.setColor(255, 255, 255)
    screen.drawRectF(0, 0, w, h)
    
    --draw the x and y axis of the graph
    screen.setColor(120, 120, 180)
    screen.drawLine(0, h / 2, w, h / 2) --x axis
    screen.setColor(120, 120, 180, 150) 
    screen.drawLine(w / 2, 0, w / 2, h) --y axis
    
    if w+h > 158 then
        Screen_big = true
        
    
        --top left (blue)
        if #Blue > 0 then
        --code
        --code
        --code
            if Screen_big then
            screen.setColor(255, 255, 255)
            screen.drawRectF(0, 0, 8, 8)
            screen.drawTextBox(10, 0, (w / 2) - 13, 8, Blue, -1, -1) --display blue value name
            end
        end
        
        
        --top right (red)
        if #Red > 0 then
            
            if Screen_big then
            screen.setColor(255, 255, 255)
            screen.drawRectF(w - 8, 0, 8, 8)
            screen.drawTextBox((w / 2) + 3, 0, (w / 2) - 13, 8, Red, 1, -1) --display red value name
            end
        end
        --bottom left (yellow)
        if #Yellow > 0 then
            
            if Screen_big then
            screen.setColor(255, 255, 255)
            screen.drawRectF(0, h - 8, 8, 8)
            screen.drawTextBox(10, h - 8, w / 2, 8, Yellow, -1, 1) --display yellow value name
            end
        end
        --bottom right (green)
        if #Green > 0 then
            
            if Screen_big then
            screen.setColor(255, 255, 255)
            screen.drawRectF(w - 8, h - 8, 8, 8)
            screen.drawTextBox((w / 2) + 3, h - 8, (w / 2) - 13, 8, Green, 1, 1) --display green value name
            end
        end 
        
        
    
    end

end