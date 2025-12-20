--[=[ Attribution notes:
        - Chess Set art by Master484 ]=]

require "functions"

Object = require "lib/classic"
Tick = require "lib/tick"

local Screen = require "obj.screen"
local ChessBoard = require "obj.ChessBoard"
local ChessSet = require "obj.ChessSet"

local screen
local lightpiecelist = {}
local darkpeicelist = {}

board = nil
piecelist = { lightpiecelist, darkpeicelist }

local squareSize = 50

function love.load()
    screen = Screen()
    board = ChessBoard(screen.center, squareSize)
    table.insert(darkpeicelist, ChessSet.Pawn('dark', 20, 20, squareSize, {'a',1}))
    table.insert(darkpeicelist, ChessSet.Queen('dark', 120, 20, squareSize))
    table.insert(lightpiecelist, ChessSet.Pawn('light', 20, 120, squareSize))
    table.insert(lightpiecelist, ChessSet.Knight('light', 120, 120, squareSize))
    
    print (darkpeicelist[1].location[1])
    placePieces()

    print('debug', darkpeicelist[1].left, darkpeicelist[1].right)

    print(board)
end

function love.update(dt)
    for i, list in ipairs(piecelist) do
        for v, peice in ipairs(list) do
            peice:update(dt)
        end
    end
end

function love.draw()
    board:draw()
    for i, list in ipairs(piecelist) do
        for v, peice in ipairs(list) do
            peice:draw()
        end
    end
end

function love.mousepressed(mx, my)
    for i, list in ipairs(piecelist) do
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
    snapPiece(mx,my)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
