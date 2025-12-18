local ChessPeice = Object:extend()
local Pawn = ChessPeice:extend()
local Knight = ChessPeice:extend()
local Bishop = ChessPeice:extend()
local Rook = ChessPeice:extend()
local Queen = ChessPeice:extend()
local King = ChessPeice:extend()

function ChessPeice:new(color, image, x, y, squareSize)
    --[=[ Class for creation of chesspeices. Each peice is a subclass of ChessPeice. Pass
        color, loaction (x,y), and squareSize]=]

    -- set image path based on color
    if color == 'white' or color == 'light' then
        self.color = 'light_pieces'
    elseif color == 'black' or color == 'dark' then
        self.color = 'dark_pieces'
    else
        error('Invalid color')
    end

    -- set image and scaling factor
    self.image = love.graphics.newImage(string.format('images/chess_set/%s/%s', self.color, image))
    self.scalefactor = squareSize / self.image:getWidth()

    -- default attributes
    self.x = x; self.y = y
    self.top = self.y; self.left = self.x
    self.bottom = self.y + squareSize; self.right = self.x + squareSize


    print('ChessSet Image W x H: ', self.image:getWidth(), self.image:getHeight())
end

function ChessPeice:move()
    
end

function ChessPeice:draw()
    love.graphics.draw(self.image, self.x, self.y,0,self.scalefactor)
end

---------------------------------------------------------------------------------------
----------------------------- sub classses --------------------------------------------
function Pawn:new(color, x, y, squareSize)
    Pawn.super:new(color, 'pawn.png', x, y, squareSize)
    self.type = 'pawn'
end

function Knight:new(color, x, y, squareSize)
    Knight.super:new(color, 'knight.png', x, y, squareSize)
    self.type = 'knight'
end

function Bishop:new(color, x, y, squareSize)
    Bishop.super:new(color, 'bishop.png', x, y, squareSize)
    self.type = 'bishop'
end

function Rook:new(color, x, y, squareSize)
    Rook.super:new(color, 'rook.png', x, y, squareSize)
    self.type = 'rook'
end

function Queen:new(color, x, y, squareSize)
    Queen.super:new(color, 'queen.png', x, y, squareSize)
    self.type = 'queen'
end

function King:new(color, x, y, squareSize)
    King.super:new(color, 'king.png', x, y, squareSize)
    self.type = 'king'
end

local ChessSet  = {}
ChessSet.Pawn   = Pawn
ChessSet.Knight = Knight
ChessSet.Bishop = Bishop
ChessSet.Rook   = Rook
ChessSet.Queen  = Queen
ChessSet.King   = King

return ChessSet
