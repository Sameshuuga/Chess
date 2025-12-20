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

    -- Top-left corner
    self.center     = center
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

    -- Build grid of Square objects
    self.squares = {}
    local y = self.topLeft.y
    local color = 'dark'

    for r, row in ipairs(self.rows) do
        local squarelist = {}
        local x = self.topLeft.x

        for c, column in ipairs(self.columns) do
            -- Toggle color each square
            color = (color == 'dark') and 'light' or 'dark'
            local id = { row = row, column = column }
            -- print(id.row,id.column)
            table.insert(squarelist, Square(id, x, y, self.squareSize, color))
            x = x + squareSize
        end

        -- Toggle again each row to ensure checkerboard pattern stays aligned
        color = (color == 'dark') and 'light' or 'dark'

        table.insert(self.squares, squarelist)
        y = y + squareSize
    end
end

function ChessBoard:draw()
    for r, row in ipairs(self.squares) do
        for i, square in ipairs(row) do
            square:draw(self.board_colors, self.scalefactor)
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

    self.id = id
    self.x = x
    self.y = y
    self.size = squareSize

    -- Boundaries for potential interactions
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
