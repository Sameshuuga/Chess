-- shared functions to hide clutter

function check_collision(a, b)
    return a.right > b.left
        and a.left < b.right
        and a.bottom > b.top
        and a.top < b.bottom
end

function placePieces()
    for i, list in ipairs(piecelist) do
        -- place peices on the assigned square
        for v, peice in ipairs(list) do
            for i, squarelist in ipairs(board.squares) do
                -- find correct square id
                for v, square in ipairs(squarelist) do
                    if peice.location == square.id then
                        peice.x = square.x; peice.y = square.y
                    end
                end
            end
        end
    end
end

function snapPiece(mx, my)
    for i, list in ipairs(piecelist) do
        -- detect when a peice is dropped
        for v, peice in ipairs(list) do
            if mx >= peice.left and mx < peice.right and
                my >= peice.top and my < peice.bottom then
                peice.moving = false
                for i, squarelist in ipairs(board.squares) do
                    -- snap to nearest square
                    for v, square in ipairs(squarelist) do
                        local margin = 0
                        if square.center.x >= peice.left + margin and square.center.x < peice.right - margin and
                            square.center.y >= peice.top and square.center.y + margin < peice.bottom - margin then
                            peice.x = square.x; peice.y = square.y
                            peice.location = square.id
                            -- peice.x = square.center.x - squareSize/2; peice.y = square.center.y - squareSize/2
                        end
                    end
                end
                print(peice.location.column, peice.location.row)
                print("Peice Released")
            end
        end
    end
end
