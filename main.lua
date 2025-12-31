--[=[ Attribution notes:
        - Chess Set art by Master484 ]=]

require "functions"

Object = require "lib/classic"
Tick = require "lib/tick"

local Screen = require "obj.screen"
local ChessBoard = require "obj.ChessBoard"
local ChessSet = require "obj.ChessSet"
local Timer = require "obj.Timer"
local Ui = require "obj.ui"

screen = nil
board = nil
ui = nil
local timer = nil


Piecelist = {}
Caplist = {}


gamestart = false
playerTurn = 'light'

local squareSize = 65
local timeLimit = 500 --in seconds


function love.load()
    screen = Screen()
    board = ChessBoard(screen.center, squareSize)

    ui = Ui(caplist, squareSize)
    timer1 = Timer(timeLimit, ui.timer1[1], ui.timer1[2])
    timer2 = Timer(timeLimit, ui.timer2[1], ui.timer2[2])

    table.insert(Piecelist, ChessSet.Bishop('dark', 0,0,squareSize,{'e',4}))

    makeStartingPieces(ChessSet, squareSize)
    setupBoard()
end

function love.update(dt)
    for i, peice in ipairs(Piecelist) do
        peice:update(dt)
    end

    if gamestart then
        if playerTurn == 'dark' then
            timer1:update(dt)
        elseif playerTurn == 'light' then
            timer2:update(dt)
        end
    end
end

function love.draw()
    board:draw()
    for i, peice in ipairs(Piecelist) do
        peice:draw()
    end

    timer1:draw(); timer2:draw()
    
    ui:draw()
    screen:draw()
end

function love.mousepressed(mx, my)
    drag(mx, my)
end

function love.mousereleased(mx, my)
    drop()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
