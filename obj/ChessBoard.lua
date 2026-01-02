local ChessBoard = Object:extend()
local Square = Object:extend()

-----------------------------------------------------------
-- ChessBoard
-----------------------------------------------------------
function ChessBoard:new(center, squareSize, w, h)
    --[=[ ChessBoard object. Specify the width and height
            in squares (defaluts to 8 x 8). Specify the center coordinates of
            he board. Specify the square size as pixels
            wide/tall.]=]

    -- print('Board color image W x H: ',self.board_colors:getWidth(),self.board_colors:getHeight())
    self.width      = w or 8
    self.height     = h or 8
    self.squareSize = squareSize

    -- Boundries
    self.center     = center
    self.top        = center.y - squareSize * 4
    self.bottom     = center.y + squareSize * 4
    self.left       = center.x - squareSize * 4
    self.right      = center.x + squareSize * 4
    self.topLeft    = {
        x = self.center.x - (self.width * self.squareSize) / 2,
        y = self.center.y - (self.height * self.squareSize) / 2
    }

    -- Build array
    self.rows       = {}
    self.columns    = {}
    for i = 1, self.height do
        self.rows[i] = self.height - i + 1
    end
    for i = 0, self.width - 1 do
        self.columns[i + 1] = string.char(string.byte("a") + i)
    end

    -- Build list of Square objects
    self.squarelist = {}
    local y = self.topLeft.y
    local color = 'dark'

    for r, row in ipairs(self.rows) do
        local x = self.topLeft.x

        for c, column in ipairs(self.columns) do
            -- Toggle color each square
            color = (color == 'dark') and 'light' or 'dark'
            local id = { column = column, row = row }
            -- print(id.row,id.column)
            table.insert(self.squarelist, Square(id, x, y, self.squareSize, color))
            x = x + squareSize
        end

        -- Toggle again each row to ensure checkerboard pattern stays aligned
        color = (color == 'dark') and 'light' or 'dark'
        y = y + squareSize --next row
    end

    -- for i, square  in ipairs(self.squarelist) do
    --     print (square.id.column,square.id.row)
    -- end
end

function ChessBoard:draw()
    for i, square in ipairs(self.squarelist) do
        square:draw(self.board_colors, self.scalefactor)
    end
end

function ChessBoard:getSquare(id)
    for i, square in ipairs(self.squarelist) do
        if id[1] == square.id.column and id[2] == square.id.row or
            id.column == square.id.column and id.row == square.id.row then
            return square
        end
    end
    error('Square not found')
end

function ChessBoard:clearBrick(color)
    for i, square in ipairs(self.squarelist) do
        if square.enPassant and square.enPassant.color == color then
            square.enPassant = false
            break
        end
    end
end

-----------------------------------------------------------
-- Square
-----------------------------------------------------------
function Square:new(id, x, y, squareSize, color)
    -- set quad to draw color
    self.color = color
    self.image = love.graphics.newImage(string.format('images/chess_set/%s_square.png', self.color))
    self.scalingfactor = squareSize / self.image:getWidth()

    self.occupyingPeice = nil
    if id.row == 2 or id.row == 7 then
        self.enPassant = false
    end

    self.id = id
    self.x = x
    self.y = y
    self.size = squareSize

    -- Boundaries for interactions
    self.topLeft = { self.x, self.y }
    self.center = { x = self.x + self.size / 2, y = self.y + self.size / 2 }
    self.top = y
    self.bottom = y + squareSize
    self.left = x
    self.right = x + squareSize
end

function Square:draw(image, scale)
    love.graphics.draw(self.image, self.x, self.y, 0, self.scalingfactor)
end

return ChessBoard
