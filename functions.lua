-- shared functions to hide clutter

function check_collision(a, b)
    return a.right > b.left
        and a.left < b.right
        and a.bottom > b.top
        and a.top < b.bottom
end

function placePieces()
    --[=[ interate through all pieces and squares and match piece
        location and square id. piece x,y = square x,y ]=]
    for i, list in ipairs(Piecelist) do
        -- place peices on the assigned square
        for v, peice in ipairs(list) do
            for i, squarelist in ipairs(board.squares) do
                -- find correct square id
                for v, square in ipairs(squarelist) do
                    if peice.location.column == square.id.column and
                        peice.location.row == square.id.row then
                        peice.x = square.x; peice.y = square.y
                    end
                end
            end
        end
    end
end

function snapPiece(mx, my)
    --[=[ detects closest square and snaps peice to it's location.
        i.e it sets the peices x,y = to the squares x,y. It also
        sets the peice column, row location the the square id. ]=]
    for i, list in ipairs(Piecelist) do
        -- detect when a peice is dropped
        for v, peice in ipairs(list) do
            if mx >= peice.left and mx < peice.right and
                my >= peice.top and my < peice.bottom then
                peice.moving = false
                for i, squarelist in ipairs(board.squares) do
                    -- snap to nearest square and set approprate active status
                    for v, square in ipairs(squarelist) do
                        local margin = 0
                        if square.center.x >= peice.left + margin and square.center.x < peice.right - margin and
                            square.center.y >= peice.top and square.center.y + margin < peice.bottom - margin then

                            peice.x = square.x; peice.y = square.y

                            if peice.location.column == square.id.column and
                                peice.location.row == square.id.row then
                                break
                            else
                                peice.location = square.id
                                peice.active = false
                            end
                        end
                    end
                end
                peice:getValidMoves()
                print('current location: ', peice.location.column, peice.location.row)
                print("Peice Released")
                print('Active = ', peice.active)
            end
        end
    end
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
                    table.insert(Lightpiecelist, piece)
                else
                    table.insert(Darkpeicelist, piece)
                end
            end
        end
    end
end
