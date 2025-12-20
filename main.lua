--[=[ Attribution notes:
        - Chess Set art by Master484 ]=]

require "functions"

Object = require "lib/classic"
Tick = require "lib/tick"

local Screen = require "obj.screen"
local ChessBoard = require "obj.ChessBoard"
local ChessSet = require "obj.ChessSet"

screen = nil
board = nil
Lightpiecelist = {}
Darkpeicelist = {}
Piecelist = { Lightpiecelist, Darkpeicelist }

local squareSize = 50

function love.load()
    screen = Screen()
    board = ChessBoard(screen.center, squareSize)
    -- table.insert(darkpeicelist, ChessSet.Pawn('dark', 0,0 , squareSize, {'a',7}))
    -- table.insert(darkpeicelist, ChessSet.Queen('dark', 0, 0, squareSize, {'d',8}))
    -- table.insert(lightpiecelist, ChessSet.Pawn('light', 0, 0, squareSize, {'a',2}))
    -- table.insert(lightpiecelist, ChessSet.Knight('light', 0, 0, squareSize,{'b',1}))
    -- table.insert(lightpiecelist, ChessSet.Bishop('light', 0, 0, squareSize,{'e',4}))
    makeStartingPieces(ChessSet, squareSize)
    placePieces()
end

function love.update(dt)
    for i, list in ipairs(Piecelist) do
        for v, peice in ipairs(list) do
            peice:update(dt)
        end
    end
end

function love.draw()
    board:draw()
    for i, list in ipairs(Piecelist) do
        for v, peice in ipairs(list) do
            peice:draw()
        end
    end
end

function love.mousepressed(mx, my)
    for i, list in ipairs(Piecelist) do
        -- detect when a peice is clicked
        for v, peice in ipairs(list) do
            if mx >= peice.left and mx < peice.right and
                my >= peice.top and my < peice.bottom then
                peice.moving = true
                print("Peice Clicked")
            end
        end
    end
end

function love.mousereleased(mx, my)
    snapPiece(mx, my)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
