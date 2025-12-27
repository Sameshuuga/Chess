local Screen = Object.extend(Object)

------------------------------------------------------------------------------------
function Screen:new()
    --[=[ Screen object for control of screen ]=]

    -- Screen set up --
    self.title = love.window.setTitle("Chess")
    -- love.window.maximize()

    -- Screen dimensions --
    self.width = love.graphics.getWidth()
    self.height = love.graphics.getHeight()
    print("Widow dimensions W x H: ", self.width, self.height) --debug information

    -- Screen focal points --
    self.bottomCenter = { x = self.width / 2, y = self.height }
    self.topCenter = { x = self.width / 2, y = 0 }
    self.leftCenter = { x = 0, y = self.height / 2 }
    self.rightCenter = { x = self.width, y = self.height / 2 }
    self.center = { x = self.width / 2, y = self.height / 2 }
    self.topRight = { x = self.width, y = 0 }

end

------------------------------------------------------------------------------------

------------------------------------------------------------------------------------
function Screen:draw()
    --[=[ method to draw tests to the screen object ]=]
end

------------------------------------------------------------------------------------

return Screen
