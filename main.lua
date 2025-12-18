
--[=[ Attribution notes:
        - Chess Set art by Master484 ]=]

require "functions"

Object = require "lib/classic"
Tick = require "lib/tick"

local Screen = require "obj.screen"
local Mouse = require "obj.mouse"
local ChessBoard = require "obj.ChessBoard"
local ChessSet = require "obj.ChessSet"

local peicelist = {}

function love.load()

    screen = Screen()
    mouse = Mouse()
    board = ChessBoard(8, 8, screen.center, 50)
    table.insert(peicelist, ChessSet.Pawn('dark', 20, 20, 50))
    print('debug', peicelist[1].left, peicelist[1].right)
    print('debug',mouse.left,mouse.right)

    print(board)
   
end

function love.update(dt)
    for i, peice in ipairs(peicelist) do
        if check_collision(mouse,peice) then
            print('colide')
        end
    end
    
    
    -- print(love.mouse.getPosition())
end

function love.draw()
    board:draw()

    for i,peice in ipairs(peicelist) do
        peice:draw()
    end
end
