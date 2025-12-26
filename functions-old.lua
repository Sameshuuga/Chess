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
        location and square id. piece x,y = square x,y ]=]


    for i, row in ipairs(board.squares) do
        for v, square in ipairs(row) do
            square.occupyingPeice = 'none'
        end
    end
    
    for i, peice in ipairs(Piecelist) do
        -- place peices on the assigned square
        for i, squarelist in ipairs(board.squares) do
            -- find correct square id
            for v, square in ipairs(squarelist) do
                if peice.location.column == square.id.column and
                    peice.location.row == square.id.row then
                    peice.x = square.x; peice.y = square.y


                    square.occupyingPeice = peice


                    print(square.id.column, square.id.row, square.occupyingPeice.type)
                end
            end
        end
    end
end

function pickUpPiece(mx, my)
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

function snapPiece(mx, my)
    --[=[ detects closest square and snaps peice to it's location.
        i.e it sets the peices x,y = to the squares x,y. It also
        sets the peice column, row location the the square id. ]=]
    local value
    for i, piece in ipairs(Piecelist) do
        -- detect when a peice is dropped
        if mx >= piece.left and mx < piece.right and
            my >= piece.top and my < piece.bottom and
            piece.active then
            piece.moving = false
            for i, squarelist in ipairs(board.squares) do
                -- snap to nearest square and set approprate active status
                for v, square in ipairs(squarelist) do
                    if square.center.x >= piece.left and square.center.x < piece.right and
                        square.center.y >= piece.top and square.center.y < piece.bottom then
                        piece.x = square.x; piece.y = square.y

                        if piece.location.column == square.id.column and
                            piece.location.row == square.id.row then
                            break
                        else
                            -------------------------------------- capture logic ---------------------------------------------------
                            print('list before cap:')
                            for i, piece in ipairs(Piecelist) do
                                print(piece.type, piece.color, i)
                            end

                            if square.occupyingPeice.color ~= piece.color then -- capture logic starts here
                                if square.occupyingPeice.color == 'light' then
                                    table.insert(capturedLight, square.occupyingPeice)
                                else
                                    table.insert(captruedDark, square.occupyingPeice)
                                end

                                for i = #Piecelist, 1, -1 do
                                    if Piecelist[i] == square.occupyingPeice then
                                        table.remove(Piecelist, i)
                                        break
                                    end
                                end
                            end -- capture logic ends here

                            print('list after cap: ')
                            for i, peice in ipairs(Piecelist) do
                                print(peice.type, peice.color, i)
                            end
                            -----------------------------------------------------------------------------------------

                            if piece.type == 'king' and
                                square.occupyingPeice.type == "rook" and
                                square.occupyingPeice.color == piece.color then
                                piece:castle(square.occupyingPeice)
                            else
                                piece.location = square.id
                            end

                            piece.active = false
                            piece.hasMoved = true
                            value = true
                        end
                    end
                end
            end

            print('dark cap: ')
            for i, peice in ipairs(captruedDark) do
                print(peice.type, peice.color)
            end
            print('light cap: ')
            for i, peice in ipairs(capturedLight) do
                print(peice.type, peice.color)
            end

            -- print('current location: ', peice.location.column, peice.location.row)
            -- print('Active = ', peice.active)
            print("Peice Released")
        end
    end
    return value
end

function capturePeice()

end
