
--[=[ Attribution notes:
        - Chess Set art by Master484 ]=]


Object = require "lib/classic"
Tick = require "lib/tick"

Screen = require "obj.screen"
ChessBoard = require "obj.ChessBoard"

function love.load()
    screen = Screen()
    board = ChessBoard(8, 8, screen.center, 50)
    print(board)
    -- for i, v in ipairs(board.squares) do
    --     for b,c in ipairs(v) do
    --         print(c.id.column, c.id.row)
    --     end
    -- end
end

function love.update(dt)

end

function love.draw()
    board:draw()
end
