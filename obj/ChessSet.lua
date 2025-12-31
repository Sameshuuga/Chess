local ChessPeice = Object:extend()
local Pawn = ChessPeice:extend()
local Knight = ChessPeice:extend()
local Bishop = ChessPeice:extend()
local Rook = ChessPeice:extend()
local Queen = ChessPeice:extend()
local King = ChessPeice:extend()

function ChessPeice:new(color, image, x, y, squareSize, location)
    --[=[ Class for creation of chesspeices. Each peice is a subclass of ChessPeice. Pass
        color, location of the center point (x,y), and squareSize]=]

    -- set image path based on color
    if color == 'white' or color == 'light' then
        self.color = 'light'
    elseif color == 'black' or color == 'dark' then
        self.color = 'dark'
    else
        error('Invalid color')
    end
    -- set image and scaling factor
    self.image = love.graphics.newImage(string.format('images/chess_set/%s_pieces/%s', self.color, image))
    self.activeImage = love.graphics.newImage(string.format('images/chess_set/%s_pieces/active_%s', self.color, image))
    self.scalefactor = squareSize / self.image:getWidth()

    -- default attributes
    self.squareSize = squareSize
    self.center = { x = x, y = y }
    self.x = self.center.x - self.squareSize / 2; self.y = self.center.y - self.squareSize / 2
    self.top = self.y; self.left = self.x
    self.bottom = self.y + squareSize; self.right = self.x + squareSize

    -- state info
    self.moving = false
    self.active = false
    self.hasMoved = false
    self.location = { column = location[1], row = location[2] }
    self.target = self.location
end

function ChessPeice:update(dt)
    if self.moving == true then
        local x, y = love.mouse.getPosition()
        self.x = x - self.squareSize / 2
        self.y = y - self.squareSize / 2
    end

    self.top = self.y; self.left = self.x
    self.bottom = self.y + self.squareSize; self.right = self.x + self.squareSize
end

function ChessPeice:draw()
    love.graphics.draw(self.image, self.x, self.y, 0, self.scalefactor)

    if self.active == true then
        love.graphics.draw(self.activeImage, self.x, self.y, 0, self.scalefactor)
        for i, move in pairs(self:getValidMoves()) do
            for i, square in ipairs(board.squarelist) do
                if move.column == square.id.column and
                    move.row == square.id.row then
                    love.graphics.circle('line', square.x + square.size / 2, square.y + square.size / 2, 20)
                end
            end
        end
    end
end

function ChessPeice:getValidMoves()
    --[=[ ]=]
    local validMoves = {}
    for i, move in ipairs(self:validMoves()) do
        table.insert(validMoves, move)
    end
    if self.type == 'king' then
        if self:checkCastle() then
            for i, move in ipairs(self:checkCastle()) do
                table.insert(validMoves, move)
            end
        end
    end

    return validMoves
end

function ChessPeice:_cc(value)
    --[=[ Convert Column ]=]
    local converter = {
        a = 1,
        b = 2,
        c = 3,
        d = 4,
        e = 5,
        f = 6,
        g = 7,
        h = 8,
        [1] = 'a',
        [2] = 'b',
        [3] = 'c',
        [4] = 'd',
        [5] = 'e',
        [6] = 'f',
        [7] = 'g',
        [8] = 'h'
    }
    return converter[value]
end

---------------------------------------------------------------------------------------
----------------------------- sub classses --------------------------------------------

----------------------------- pawn ----------------------------------------------------
function Pawn:new(color, x, y, squareSize, location)
    Pawn.super.new(self, color, 'pawn.png', x, y, squareSize, location)
    self.type = 'pawn'
end

function Pawn:validMoves()                         -- still need to avoid the brick, can be done by treating the empty square as if it is occupyed for one move
    local moves = {}
    local move = self.color == 'light' and 1 or -1 -- Light moves up, dark moves down

    -- Forward move
    if self.hasMoved == false then
        local firstmove = self.color == 'light' and 2 or -2
        local moveSquare = board:getSquare({ self.location.column, self.location.row + firstmove })
        if moveSquare.occupyingPeice == 'none' then
            table.insert(moves, moveSquare.id)
        end
    end
    local validRow = self.location.row + move
    if validRow >= 1 and validRow <= 8 then
        local moveSquare = board:getSquare({ self.location.column, validRow })
        if moveSquare.occupyingPeice == 'none' then
            table.insert(moves, moveSquare.id)
        end

        -- Diagonal captures
        for i, offset in ipairs({ -1, 1 }) do
            local validColumn = self:_cc(self.location.column) + offset
            if validColumn >= 1 and validColumn <= 8 then
                local capSquare = board:getSquare({ self:_cc(validColumn), validRow })
                if capSquare.occupyingPeice ~= 'none'
                    and capSquare.occupyingPeice.color ~= self.color then
                    table.insert(moves, capSquare.id)
                end
            end
        end
    end


    return moves
end

---------------------------------------------------------------------------------------
----------------------------- knight ----------------------------------------------------
function Knight:new(color, x, y, squareSize, location)
    Knight.super.new(self, color, 'knight.png', x, y, squareSize, location)
    self.type = 'knight'
end

function Knight:validMoves()
    local moves = {}
    local offsets = {
        { 2, 1 }, { 2, -1 }, { -2, 1 }, { -2, -1 },
        { 1, 2 }, { 1, -2 }, { -1, 2 }, { -1, -2 }
    }
    for i, offset in ipairs(offsets) do
        local validColumn = self:_cc(self.location.column) + offset[1]
        local validRow = self.location.row + offset[2]
        if validColumn >= 1 and validColumn <= 8 and validRow >= 1 and validRow <= 8 then
            local moveSquare = board:getSquare({ self:_cc(validColumn), validRow })
            if moveSquare.occupyingPeice.color ~= self.color then
                table.insert(moves, moveSquare.id)
            end
        end
    end
    return moves
end

---------------------------------------------------------------------------------------
----------------------------------- bishop --------------------------------------------
function Bishop:new(color, x, y, squareSize, location)
    Bishop.super.new(self, color, 'bishop.png', x, y, squareSize, location)
    self.type = 'bishop'
end

function Bishop:validMoves()
    local moves = {}
    local directions = { { 1, 1 }, { 1, -1 }, { -1, 1 }, { -1, -1 } } -- Diagonal directions
    for i, dir in ipairs(directions) do
        for v = 1, 8 do
            local validColumn = self:_cc(self.location.column) + dir[1] * v
            local validRow = self.location.row + dir[2] * v
            if validColumn >= 1 and validColumn <= 8 and validRow >= 1 and validRow <= 8 then
                local moveSquare = board:getSquare({ self:_cc(validColumn), validRow })
                if moveSquare.occupyingPeice.color == self.color then
                    break
                elseif moveSquare.occupyingPeice ~= 'none' and moveSquare.occupyingPeice.color ~= self.color then
                    table.insert(moves, moveSquare.id)
                    break
                end
                table.insert(moves, moveSquare.id)
            else
                break
            end
        end
    end
    return moves
end

---------------------------------------------------------------------------------------
----------------------------------- rook --------------------------------------------
function Rook:new(color, x, y, squareSize, location)
    Rook.super.new(self, color, 'rook.png', x, y, squareSize, location)
    self.type = 'rook'
end

function Rook:validMoves()
    local moves = {}
    local directions = { { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 } } -- Horizontal and vertical directions
    for i, dir in ipairs(directions) do
        for v = 1, 8 do
            local validColumn = self:_cc(self.location.column) + dir[1] * v
            local validRow = self.location.row + dir[2] * v
            if validColumn >= 1 and validColumn <= 8 and validRow >= 1 and validRow <= 8 then
                local moveSquare = board:getSquare({ self:_cc(validColumn), validRow })
                if moveSquare.occupyingPeice.color == self.color then
                    break
                elseif moveSquare.occupyingPeice ~= 'none' and moveSquare.occupyingPeice.color ~= self.color then
                    table.insert(moves, moveSquare.id)
                    break
                end
                table.insert(moves, moveSquare.id)
            else
                break
            end
        end
    end
    return moves
end

---------------------------------------------------------------------------------------
----------------------------------- queen --------------------------------------------

function Queen:new(color, x, y, squareSize, location)
    Queen.super.new(self, color, 'queen.png', x, y, squareSize, location)
    self.type = 'queen'
end

function Queen:validMoves()
    local moves = {}
    local directions = {
        { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 },  -- Horizontal and vertical directions
        { 1, 1 }, { 1, -1 }, { -1, 1 }, { -1, -1 } -- Diagonal directions
    }
    for i, dir in ipairs(directions) do
        for v = 1, 8 do
            local validColumn = self:_cc(self.location.column) + dir[1] * v
            local validRow = self.location.row + dir[2] * v
            if validColumn >= 1 and validColumn <= 8 and validRow >= 1 and validRow <= 8 then
                local moveSquare = board:getSquare({ self:_cc(validColumn), validRow })
                if moveSquare.occupyingPeice.color == self.color then
                    break
                elseif moveSquare.occupyingPeice ~= 'none' and moveSquare.occupyingPeice.color ~= self.color then
                    table.insert(moves, moveSquare.id)
                    break
                end
                table.insert(moves, moveSquare.id)
            else
                break
            end
        end
    end
    return moves
end

---------------------------------------------------------------------------------------
----------------------------------- king --------------------------------------------

function King:new(color, x, y, squareSize, location) -- still need castle function
    King.super.new(self, color, 'king.png', x, y, squareSize, location)
    self.type = 'king'
end

function King:validMoves()
    local moves = {}
    local directions = {
        { 1, 0 }, { -1, 0 }, { 0, 1 }, { 0, -1 },  -- Horizontal and vertical directions
        { 1, 1 }, { 1, -1 }, { -1, 1 }, { -1, -1 } -- Diagonal directions
    }
    for i, dir in ipairs(directions) do            -- normal moves
        local validColumn = self:_cc(self.location.column) + dir[1]
        local validRow = self.location.row + dir[2]
        if validColumn >= 1 and validColumn <= 8 and validRow >= 1 and validRow <= 8 then
            local moveSquare = board:getSquare({ self:_cc(validColumn), validRow })
            if moveSquare.occupyingPeice.color ~= self.color then
                table.insert(moves, moveSquare.id)
            end
        end
    end
    return moves
end

---------- under construction (working, might need improving) --------------------------------------------
function King:checkCastle()
    --[=[ checks if castle is a valid move. Returns list of avialiable castle moves,
            includes 'type' and 'direction' in the move data to be used by :docastle()]=]
    if self.hasMoved then
        return false
    end
    local moves = {}
    local directions = { 1, -1 }

    for i, dir in ipairs(directions) do -- efficentcy improvment idea: make a list of all squares to check and run the getSquare loop once to return them all 
        local column = self:_cc(self.location.column)
        while column >= 1 and column <= 8 do
            column = column + dir
            local square = board:getSquare({ self:_cc(column), self.location.row })
            if square.occupyingPeice ~= 'none' then
                if square.occupyingPeice.type == 'rook' and square.occupyingPeice.hasMoved == false then
                    table.insert(moves, {
                        column = square.id.column,
                        row = square.id.row,
                        type = 'castle',
                        direction = dir 
                    })
                end
                break
            end
        end
    end

    return moves
end

function King:doCastle(move)
    local square = board:getSquare({move.column,move.row})
    local rook = square.occupyingPeice
    local column = self:_cc(self.location.column) + move.direction + move.direction
    self.target.column = self:_cc(column)
    rook.target = {column = self:_cc(column - move.direction), row = rook.location.row}
    placePiece(rook)
end

---------- construction end -----------------------------------------------------------------------

---------------------------------------------------------------------------------------

local ChessSet  = {}
ChessSet.Pawn   = Pawn
ChessSet.Knight = Knight
ChessSet.Bishop = Bishop
ChessSet.Rook   = Rook
ChessSet.Queen  = Queen
ChessSet.King   = King

return ChessSet
