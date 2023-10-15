function QuadTree(x, y, width, height, maxObjects)
    local self = {}
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.maxObjects = maxObjects or 10
    self.objects = {}
    self.nodes = {}
    self.divided = false
    self.level = 0
    
    function self:insert(object)
        if not self:contains(object.x, object.y) then
            return false
        else
            if #self.objects < self.maxObjects then
                table.insert(self.objects, object)
                return true
            else
                if not self.divided then
                    self:split()
                end
                if self.nodes[1]:insert(object) or self.nodes[2]:insert(object) or self.nodes[3]:insert(object) or self.nodes[4]:insert(object) then
                    return true
                else
                    return false
                end
            end
        end
    end

    function self:split()
        local subWidth = self.width / 2
        local subHeight = self.height / 2
        self.nodes[1] = QuadTree(self.x, self.y, subWidth, subHeight, self.maxObjects)
        self.nodes[2] = QuadTree(self.x + subWidth, self.y, subWidth, subHeight, self.maxObjects)
        self.nodes[3] = QuadTree(self.x, self.y + subHeight, subWidth, subHeight, self.maxObjects)
        self.nodes[4] = QuadTree(self.x + subWidth, self.y + subHeight, subWidth, subHeight, self.maxObjects)
        self.divided = true
    end

    function self:contains(px, py)
        return px >= self.x and px <= self.x + self.width and py >= self.y and py <= self.y + self.height
    end

    function self:intersects(px, py, range)
        return px > self.x - range and px < self.x + self.width + range and py > self.y - range and py < self.y + self.height + range
    end

    function self:query(px, py, range, results)
        if self:intersects(px, py, range) then
            for i = 1, #self.objects do
                table.insert(results, self.objects[i])
            end
            for i = 1, #self.nodes do
                self.nodes[i]:query(px, py, range, results)
            end
        end
        return results
    end

    function self:drawTree()
        -- screen.setColor(255, 255, 255)
        screen.drawRect(self.x, self.y, self.width, self.height)
        for i = 1, #self.nodes do
            self.nodes[i]:drawTree()
        end
    end

    return self
end