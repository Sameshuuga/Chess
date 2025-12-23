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
Darkpiecelist = {}
Piecelist = { Lightpiecelist, Darkpiecelist }

capturedLight = {}
captruedDark = {}

playerTurn = 'light'

local squareSize = 65

function love.load()
    screen = Screen()
    board = ChessBoard(screen.center, squareSize)
    -- table.insert(darkpeicelist, ChessSet.Pawn('dark', 0,0 , squareSize, {'a',7}))
    table.insert(Darkpiecelist, ChessSet.Pawn('dark', 0, 0, squareSize, {'d',7}))
    table.insert(Darkpiecelist, ChessSet.Bishop('dark', 0, 0, squareSize, {'g',8}))
    table.insert(Lightpiecelist, ChessSet.Pawn('light', 0, 0, squareSize, {'d',2}))
    table.insert(Lightpiecelist, ChessSet.Knight('light', 0, 0, squareSize,{'b',1}))
    table.insert(Lightpiecelist, ChessSet.Bishop('light', 0, 0, squareSize,{'c',1}))
    table.insert(Lightpiecelist, ChessSet.Rook('light', 0, 0, squareSize,{'a',1}))
    table.insert(Lightpiecelist, ChessSet.Queen('light', 0, 0, squareSize,{'d',1}))
    table.insert(Lightpiecelist, ChessSet.King('light', 0, 0, squareSize,{'e',1}))
    -- makeStartingPieces(ChessSet, squareSize)
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
    pickUpPiece(mx,my)
end

function love.mousereleased(mx, my)
    if snapPiece(mx, my) then
        playerTurn = (playerTurn == 'dark') and 'light' or 'dark'
        print(string.format("it's %s's turn", playerTurn))
    else
       print(string.format("Still %s's turn", playerTurn))
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
