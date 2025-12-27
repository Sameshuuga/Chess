-- shared functions to hide clutter

function check_collision(a, b)
    return a.right > b.left
        and a.left < b.right
        and a.bottom > b.top
        and a.top < b.bottom
end

function makeStartingPieces(ChessSet, squareSize)
    --[=[ contains table with all starting pieces. Interates
        through the table and constructs a pieces object for
        each piece.
        Idea: can alter function to accept a table, that way
        it constructs new pieces based on what is passed ]=]
    local startingPieces = {
        Pawn = {
            light = { { 'a', 2 }, { 'b', 2 }, { 'c', 2 }, { 'd', 2 }, { 'e', 2 }, { 'f', 2 }, { 'g', 2 }, { 'h', 2 } },
            dark = { { 'a', 7 }, { 'b', 7 }, { 'c', 7 }, { 'd', 7 }, { 'e', 7 }, { 'f', 7 }, { 'g', 7 }, { 'h', 7 } },
        },
        Rook = {
            light = { { 'a', 1 }, { 'h', 1 } },
            dark = { { 'a', 8 }, { 'h', 8 } },
        },
        Knight = {
            light = { { 'b', 1 }, { 'g', 1 } },
            dark = { { 'b', 8 }, { 'g', 8 } },
        },
        Bishop = {
            light = { { 'c', 1 }, { 'f', 1 } },
            dark = { { 'c', 8 }, { 'f', 8 } },
        },
        Queen = {
            light = { { 'd', 1 } },
            dark = { { 'd', 8 } },
        },
        King = {
            light = { { 'e', 1 } },
            dark = { { 'e', 8 } },
        },
    }
    -- Create pieces
    for piece, colors in pairs(startingPieces) do
        for color, locations in pairs(colors) do
            for i, location in ipairs(locations) do
                local piece = ChessSet[piece](color, 0, 0, squareSize, location)
                if color == "light" then
                    table.insert(Piecelist, piece)
                else
                    table.insert(Piecelist, piece)
                end
            end
        end
    end
end

function setupBoard()
    --[=[ interate through all pieces and squares and match piece
        location and square id. piece x,y = square x,y.
        square occupyingPeice = piece. ]=]

    for i, square in ipairs(board.squarelist) do
        square.occupyingPeice = 'none'
    end

    for p, peice in ipairs(Piecelist) do -- place peices
        for i, square in ipairs(board.squarelist) do
            if peice.location.column == square.id.column and
                peice.location.row == square.id.row then
                peice.x = square.x; peice.y = square.y
                peice.location = square.id --syncs table reference
                square.occupyingPeice = peice
            end
        end
    end
end

function drag(mx, my)
    --[=[ handles picking up pieces and checking if the pieces is valid based on
   player turn ]=]

    for i, peice in ipairs(Piecelist) do
        -- detect when a peice is clicked
        if mx >= peice.left and mx < peice.right and
            my >= peice.top and my < peice.bottom and
            peice.color == playerTurn then
            peice.moving = true
            peice.active = true
            print("Peice Clicked")
        else
            peice.active = false
        end
    end
end

function drop()
    --[=[  ]=]
    for p, piece in ipairs(Piecelist) do --find active peice
        if piece.active then
            piece.moving = false
            for i, square in ipairs(board.squarelist) do --find&link target square and then break
                if square.center.x >= piece.left and square.center.x < piece.right and
                    square.center.y >= piece.top and square.center.y < piece.bottom then
                    piece.target = square.id
                    break
                end
            end
            ----------------- under construction ----------------------
            if isMoveValid(piece) then --run move logic
                placePiece(piece)    
            end
            placePiece(piece)

            ----------------- under construction ----------------------
            break
        end
    end
end


function placePiece(piece)
    --[=[ check if target is valid and up date peice location accordingly ]=]

    ------------------ under construction (tempary code) -----------------------
    local currentSquare = board:getSquare(piece.location)
    local targetSquare = board:getSquare(piece.target)

    if isMoveValid(piece) then
        currentSquare = "none"
        targetSquare.occupyingPeice = piece
        piece.location = piece.target
        piece.x, piece.y = targetSquare.topLeft[1], targetSquare.topLeft[2]
        piece.active = false; piece.hasMoved = true
        playerTurn = (playerTurn == 'dark') and 'light' or 'dark'
    else
        piece.target = piece.location
        piece.x, piece.y = currentSquare.topLeft[1], currentSquare.topLeft[2]
    end
    ------------------ under construction (tempary code) -----------------------
    
end

function isMoveValid(piece)
    --[=[ check validity of target move by comparing to piece:validMoves() ]=]
    for i, move in ipairs(piece:validMoves()) do
        if piece.target.column == move.column and piece.target.row == move.row then
            return true
        end
    end
    return false
end
