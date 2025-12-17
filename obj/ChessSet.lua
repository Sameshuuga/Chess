local ChessPeice = Object:extend()
local Pawn = ChessPeice:extend()
local Knight = ChessPeice:extend()
local Bishop = ChessPeice:extend()
local Rook = ChessPeice:extend()
local Queen = ChessPeice:extend()
local King = ChessPeice:extend()

function ChessPeice:new(color, image)
    -- set image path based on color
    if color == 'white' or color == 'light' then
        self.color = 'light_pieces'
    elseif color == 'black' or color == 'dark' then
        self.color = 'dark_pieces'
    else
        error('Invalid color')
    end
    self.image = love.graphics.newImage(string.format('images/chess_set/%s/%s', self.color, image))

    print('ChessSet Image W x H: ', self.image:getWidth(), self.image:getHeight())
end

function Pawn:new(color)
    Pawn.super:new(color, 'pawn.png')
    self.type = 'pawn'
end

function Knight:new(color)
    Knight.super:new(color, 'knight.png')
    self.type = 'knight'
end

function Bishop:new(color)
    Bishop.super:new(color, 'bishop.png')
    self.type = 'bishop'
end

function Rook:new(color)
    Rook.super:new(color, 'rook.png')
    self.type = 'rook'
end

function Queen:new(color)
    Queen.super:new(color, 'queen.png')
    self.type = 'queen'
end

function King:new(color)
    King.super:new(color, 'king.png')
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
