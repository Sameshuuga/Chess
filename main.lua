
--[=[ Attribution notes:
        - Chess Set art by Master484 ]=]


Object = require "lib/classic"
Tick = require "lib/tick"

local Screen = require "obj.screen"
local ChessBoard = require "obj.ChessBoard"
local ChessSet = require "obj.ChessSet"

function love.load()

    screen = Screen()
    board = ChessBoard(8, 8, screen.center, 50)
    lPawn = ChessSet.Pawn('dark')
    lKnight = ChessSet.Knight('dark')
    lBishop = ChessSet.Bishop('dark')
    lRook = ChessSet.Rook('dark')
    lQueen = ChessSet.Queen('dark')
    lKing = ChessSet.King('dark')
    print(board)
   
end

function love.update(dt)

end

function love.draw()
    board:draw()
end
