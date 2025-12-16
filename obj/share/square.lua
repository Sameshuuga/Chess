local Square = Object:extend()


function Square:new(x, y, s, color)
    self.x = x; self.y = y
    self.size = s

    -- set boundries
    self.top = self.y
    self.bottom = self.y + self.size
    self.left = self.x
    self.right = self.x + self.size
end

function Square:draw()
    love.graphics.rectangle(self.color, self.x, self.y, self.size, self.size)
end
