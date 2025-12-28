local Ui = Object:extend()

function Ui:new(caplist, squareSize)
    self.caplist = caplist
    self.squareSize = squareSize

    -- TimerZones --
    self.timer1 = { board.center.x - 20, board.top - 20 }
    self.timer2 = { board.center.x - 20, board.bottom + 20 }

    -- Captured Peice zones --
    self.capLight = {}; self.capDark = {}
    self.capturedLight = { board.left - (20+self.squareSize),
        board.center.y - board.squareSize * 4 }
    self.capturedDark = { board.right + 20,
        board.center.y - board.squareSize * 4 }
end

function Ui:buildCapDisplay()
    --[=[ ]=]

    local darkx, darky = self.squareSize, 0
    local lightx, lighty = 0, 0
------------------------------ still needs work ok for now -----------------------------------
    for i, piece in ipairs(Caplist) do
        if piece.color == 'dark' or piece.color == 'black' then
            darkx = (darkx == self.squareSize) and 2*self.squareSize or self.squareSize
            if darkx == self.squareSize then --this is causing an empty square in the top row
                darky = darky + self.squareSize
            end
            piece.x = screen.topRight.x - darkx
            piece.y = screen.topRight.y + darky
            table.insert(self.capDark, piece)
        elseif piece.color == 'light' or piece.color == 'white' then
            lightx = (lightx == 0) and self.squareSize or 0
            if lightx == 0 then --this is causing an empty square in the top row
                lighty = lighty + self.squareSize
            end
            piece.x = screen.topLeft.x + lightx
            piece.y = screen.topLeft.y + lighty
            table.insert(self.capLight, piece)
        end
    end
------------------------------ still needs work ok for now -----------------------------------
end

function Ui:draw()
    for i, piece in ipairs(Caplist) do
        piece:draw()
    end
end

return Ui
