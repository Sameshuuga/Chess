Object = require "lib.classic"

local Timer = Object:extend()

function Timer:new(timeLimit, x, y, increment)
    --[=[ Clock : timelimit is in seconds]=]
    
    -- set timer
    self.timeLimit = timeLimit
    self.timeRemaining = self.timeLimit

    --starting location
    self.x,self.y = x,y
    

end

function Timer:update(dt)
    --[=[ Countdown ]=]

    self.timeRemaining = self.timeRemaining - dt
    -- print(self.timeRemaining)

end

function Timer:draw()
    
    love.graphics.print(self.timeRemaining, self.x, self.y)

end


return Timer
