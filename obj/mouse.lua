local Mouse = Object:extend()

function Mouse:new()
    self.x = 0
    self.y = 0
    self.isPressed = false
    self.x, self.y = love.mouse.getPosition()

    self.radius = 1

    self.top = self.y - self.radius; self.bottom = self.y + self.radius
    self.left = self.x - self.radius; self.right = self.x + self.radius
end

function Mouse:update(dt)
    self.x, self.y = love.mouse.getPosition()
    self.top = self.y - self.radius; self.bottom = self.y + self.radius
    self.left = self.x - self.radius; self.right = self.x + self.radius

    self.isPressed = love.mouse.isDown(1) -- Left mouse button
end

function Mouse:draw()
    
end

return Mouse
