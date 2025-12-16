local ChessBoard = Object:extend()
local Square = Object:extend()

-----------------------------------------------------------
-- ChessBoard
-----------------------------------------------------------
function ChessBoard:new(w, h, center, squareSize)
    --[=[ ChessBoard object. Specify the width and height
            in squares. Specify the center coordinates of
            he board. Specify the square size as pixels 
            wide/tall.]=]
    self.board_colors = love.graphics.newImage('images/chess_set/board_colors.png')
    self.imageSquareSize = self.board_colors:getHeight()
    print('Board color image W x H: ',self.board_colors:getWidth(),self.imageSquareSize)
    self.width  = w
    self.height = h
    self.squareSize = squareSize

    -- Top-left corner (what you called "topRight")
    self.topLeft = {
        x = center.x - (w * squareSize) / 2,
        y = center.y - (h * squareSize) / 2
    }

    -- Build array
    self.rows = {}
    self.columns = {}
    for i = 1, w do -- row numbers
        self.rows[i] = i
    end
    for i = 0, h - 1 do -- column letters
        self.columns[i + 1] = string.char(string.byte("a") + i)
    end

    -- Build grid of Square objects
    self.squares = {}
    local y = self.topLeft.y
    local color = 1

    for r, row in ipairs(self.rows) do
        local squarelist = {}
        local x = self.topLeft.x

        for c, column in ipairs(self.columns) do
            -- Toggle color each square
            color = (color == 1) and 2 or 1
            local id = { row = row, column = column }
            -- print(id.row,id.column)
            table.insert(squarelist,Square(id, x, y, squareSize, color,self.board_colors))
            x = x + squareSize
        end

        -- Toggle again each row to ensure checkerboard pattern stays aligned
        color = (color == 1) and 2 or 1

        table.insert(self.squares,squarelist)
        y = y + squareSize
    end

end

function ChessBoard:draw()
    for r, row in ipairs(self.squares) do
        for i, square in ipairs(row) do
            square:draw(self.board_colors)
        end
    end
end


-----------------------------------------------------------
-- Square
-----------------------------------------------------------
function Square:new(id, x, y, size, color,image)

    -- set quad to draw color
    if color == 1 then
    self.quad = love.graphics.newQuad(0,0,size,size,image)
    else
    self.quad = love.graphics.newQuad(0+size,0,28,28,image)
    end

    self.id = id
    self.x = x
    self.y = y
    self.size = size
    self.color = color

    -- Boundaries for potential interactions
    self.top = y
    self.bottom = y + size
    self.left = x
    self.right = x + size

end

function Square:draw(image)
    love.graphics.draw(
        image, 
        self.quad,
        self.x,
        self.y,
        0

    )
end

return ChessBoard