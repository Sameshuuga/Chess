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
Piecelist = {}
capturedLight = {}
captruedDark = {}

playerTurn = 'light'

local squareSize = 65


function love.load()
    screen = Screen()
    board = ChessBoard(screen.center, squareSize)
    table.insert(Piecelist, ChessSet.Rook('light', 0, 0, squareSize, { 'h', 1 }))
    table.insert(Piecelist, ChessSet.Rook('light', 0, 0, squareSize, { 'a', 1 }))
    table.insert(Piecelist, ChessSet.King('light', 0, 0, squareSize, { 'e', 1 }))
    table.insert(Piecelist, ChessSet.Rook('dark', 0, 0, squareSize, { 'h', 8 }))
    table.insert(Piecelist, ChessSet.Rook('dark', 0, 0, squareSize, { 'a', 8 }))
    table.insert(Piecelist, ChessSet.King('dark', 0, 0, squareSize, { 'e', 8 }))
    table.insert(Piecelist, ChessSet.Bishop('dark', 0, 0, squareSize, { 'c', 8 }))
    table.insert(Piecelist, ChessSet.Bishop('light', 0, 0, squareSize, { 'c', 1 }))
    -- makeStartingPieces(ChessSet, squareSize)
    setupBoard()
end

function love.update(dt)
    for i, peice in ipairs(Piecelist) do
        peice:update(dt)
    end
end

function love.draw()
    board:draw()
    for i, peice in ipairs(Piecelist) do
        peice:draw()
    end
end

function love.mousepressed(mx, my)
    pickupPiece(mx, my)
end

function love.mousereleased(mx, my)
    dropPiece()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
