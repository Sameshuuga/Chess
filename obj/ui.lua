local Ui = Object:extend()

function Ui:new()

    -- TimerZones --
    self.timer1 = { board.center.x - 20, board.top-20 }
    self.timer2 = {board.center.x-20, board.bottom+20}

    
    
end

function Ui:draw()
    


end

return Ui
