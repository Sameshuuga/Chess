--[=[ Attribution notes:
        - Chess Set art by Master484 ]=]

require "functions"

Object = require "lib/classic"
Tick = require "lib/tick"

local Screen = require "obj.screen"
local ChessBoard = require "obj.ChessBoard"
local ChessSet = require "obj.ChessSet"

local lightpiecelist = {}
local darkpeicelist = {}
local peicelist = { lightpiecelist, darkpeicelist }

local squareSize = 50

function love.load()
    screen = Screen()
    board = ChessBoard(8, 8, screen.center, squareSize)
    table.insert(darkpeicelist, ChessSet.Pawn('dark', 20, 20, squareSize))
    table.insert(darkpeicelist, ChessSet.Queen('dark', 120, 20, squareSize))
    table.insert(lightpiecelist, ChessSet.Pawn('light', 20, 120, squareSize))
    table.insert(lightpiecelist, ChessSet.Knight('light', 120, 120, squareSize))

    print('debug', darkpeicelist[1].left, darkpeicelist[1].right)

    print(board)
end

function love.update(dt)

end

function love.draw()
    board:draw()
    for i, list in ipairs(peicelist) do
        for v, peice in ipairs(list) do
            peice:draw()
            -- print(peice.type)
        end
    end
end

function love.mousepressed(mx, my)

    for i, list in ipairs(peicelist) do
        -- detect when a peice is clicked
        for v, peice in ipairs(list) do
            if mx >= peice.left and mx < peice.right and
                my >= peice.top and my < peice.bottom then
                print("Peice Clicked")
            end
        end
    end
end
