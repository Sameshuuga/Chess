--[=[ Attribution notes:
        - Chess Set art by Master484 ]=]

require "functions"

Object = require "lib/classic"
Tick = require "lib/tick"

local Screen = require "obj.screen"
local ChessBoard = require "obj.ChessBoard"
local ChessSet = require "obj.ChessSet"

local screen, board
local lightpiecelist = {}
local darkpeicelist = {}
local peicelist = { lightpiecelist, darkpeicelist }

local squareSize = 50

function love.load()
    screen = Screen()
    board = ChessBoard(screen.center, squareSize)
    table.insert(darkpeicelist, ChessSet.Pawn('dark', 20, 20, squareSize))
    table.insert(darkpeicelist, ChessSet.Queen('dark', 120, 20, squareSize))
    table.insert(lightpiecelist, ChessSet.Pawn('light', 20, 120, squareSize))
    table.insert(lightpiecelist, ChessSet.Knight('light', 120, 120, squareSize))

    print('debug', darkpeicelist[1].left, darkpeicelist[1].right)

    print(board)
end

function love.update(dt)
    for i, list in ipairs(peicelist) do
        for v, peice in ipairs(list) do
            peice:update(dt)
        end
    end
end

function love.draw()
    board:draw()
    for i, list in ipairs(peicelist) do
        for v, peice in ipairs(list) do
            peice:draw()
        end
    end
end

function love.mousepressed(mx, my)
    for i, list in ipairs(peicelist) do
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
    for i, list in ipairs(peicelist) do
        -- detect when a peice is dropped
        for v, peice in ipairs(list) do
            if mx >= peice.left and mx < peice.right and
                my >= peice.top and my < peice.bottom then
                peice.moving = false
                for i, squarelist in ipairs(board.squares) do
                    -- snap to nearest square
                    for v, square in ipairs(squarelist) do
                        local margin = 0
                        if square.center.x >= peice.left + margin and square.center.x < peice.right - margin and
                            square.center.y >= peice.top and square.center.y + margin < peice.bottom - margin then
                            peice.x = square.x; peice.y = square.y
                            -- peice.x = square.center.x - squareSize/2; peice.y = square.center.y - squareSize/2
                        end
                    end
                end
                print("Peice Released")
            end
        end
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
