classdef BoardUtilities
    % Static method utility class to manipulate EightBoards
    
    properties
    end
    
    methods (Static)
        % Generates a Board n moves away from goal state
        function board = generateBoard_N_StepsAway(n)            
            
            board = EightBoard([1 2 3 4 5 6 7 8 9]);
            visitedBoards = {};
            count = 1;
            visitedBoards{count} = board;
            for i = 1:n               
                % fprintf('i = %d\n', i);
                moves = BoardUtilities.nextBoards(board);
                moves = moves(randperm(length(moves)));
                for x = 1: length(moves)
                    % fprintf('x = %d\n', x);
                    newBoard = moves{x};
                    if ( ~hasBeenVisited(visitedBoards, newBoard) )
                        count = count + 1;                      
                        board = newBoard;
                        visitedBoards{count} = board;                        
                        break;
                    end
                end
            end           
        end        
                
        %Generate a random, solvable EightBoard
        function board = generateBoard()
            tiles = randperm(9);
            while ( ~isValidArray(tiles) )                
                tiles = randperm(9);
            end
            board = EightBoard(tiles);
        end
        
        %Iterative depth-first search, returns the depth
        %at which the node was found
        function iterations = idfs(board)
            iterations = 0;
            found = false;
            while (found == false)                
                value = BoardUtilities.dls(board, iterations);
                iterations = iterations + abs(value);
                if (value > 0)
                    found = true;
                end
            end           
        end
                
        % Depth-Limited search for EightBoard at specified depth
        % Returns -(number of steps) if not found
        % Returns +(number of steps) if found
        function iterations = dls(board, depth)
            iterations = 1;
            found = false;
            if (isGoal(board))
                found = true;
            elseif (depth <= 0)
                found = false;
            else
                adjacentBoards = BoardUtilities.nextBoards(board);
                for i=1:length(adjacentBoards)
                    newBoard = adjacentBoards{i};
                    value = BoardUtilities.dls(newBoard, depth - 1);
                    iterations = iterations + abs(value);
                    if (value > 0)
                        found = true;
                        break;
                    end
                end
            end
            
            if (~found)
                iterations = -1 * iterations;
            end
        end 
                         
        %Breadth-First Search for the given EightBoard
        function iterations = bfs(board)
            
            %initialize the queue and the visited boards list
            q = CQueue;
            visitedBoards = {};
            q.push(board);
            count = 0;
            
            while ( ~q.isempty() )
                count = count + 1;
                currentBoard = q.pop();
                
                % disp('currently deliberating on: ');
                % disp(currentBoard);
                
                if isGoal(currentBoard)
                    iterations = length(visitedBoards);
                    % disp('###############FOUND A GOAL STATE###############');
                    return;
                end
                
                %Could possibly be optimized as it has to change length of
                %struct every iteration.  
                visitedBoards{length(visitedBoards) + 1} = currentBoard;
               
                %Get next possible boards
                adjacentBoards = BoardUtilities.nextBoards(currentBoard);
                
                %Check boards for goal state then push the boards into the
                %queue.  
                for i = 1: length(adjacentBoards)
                    newBoard = adjacentBoards{i};
                    if (~hasBeenVisited(visitedBoards, newBoard) )
                        q.push(newBoard);
                    end
                end                
            end            
        end    
               
        function cost = astar(start)
            open = {};
            closed = {};
            
            cost = 1;
            
            startNode = BoardNode(start);
            startNode.g = 1;
            startNode.h = manhattanDistance(start);
            startNode.f = startNode.g + startNode.h;
            
            open{end + 1} = startNode;
            
            while (~isempty(open))
                current = lowestScore(open);
                if (isGoal(current.board))
                    % disp('##############FOUND BOARD##############');
                    break;
                end
                
                for j=1:length(open)
                    if (isequal(open{j}.board.tiles, current.board.tiles))
                        if (open{j}.f == current.f)
                            open(j) = [];
                            break;
                        end
                    end
                end
                % open = open(open~=current);
                closed{end + 1} = current;
                
                neighbors = BoardUtilities.nextBoards(current.board);
                for i=1:length(neighbors)
                    neighbor = neighbors{i};
                    neighborNode = BoardNode(neighbor);                     
                    neighborNode.g = current.g + 1;
                    neighborNode.h = manhattanDistance(neighbor);
                    neighborNode.f = neighborNode.g + neighborNode.h;
                    
                    if (matchCount(neighborNode, closed) == 0)
                        if (matchCount(neighborNode, open) == 0)
                            cost = cost + 1;
                            open{end + 1} = neighborNode;
                        elseif (current.g + 1 >= neighborNode.g)
                            continue;
                        end
                       
                    end
                end 
            end
        end
               
        
        %Generates a struct of the 2-4 next possible boards from the one given
        function boardArray = nextBoards( board )
            boardArray = {};
            pos = board.blank_position;

            if (pos == 1 || pos == 4 || pos == 7)
                boardArray{length(boardArray) + 1} = swapRight(pos, board);
            end

            if (pos == 2 || pos == 5 || pos == 8)
                boardArray{length(boardArray) + 1} = swapLeft(pos, board);
                boardArray{length(boardArray) + 1} = swapRight(pos, board);
            end

            if (pos == 3 || pos == 6 || pos == 9)
                boardArray{length(boardArray) + 1} = swapLeft(pos, board);
            end

            if (pos == 1 || pos == 2 || pos == 3)
                boardArray{length(boardArray) + 1} = swapUp(pos, board);
            end

            if (pos == 4 || pos == 5 || pos == 6)
                boardArray{length(boardArray) + 1} = swapDown(pos, board);
                boardArray{length(boardArray) + 1} = swapUp(pos, board);
            end

            if (pos == 7 || pos == 8 || pos == 9)
                boardArray{length(boardArray) + 1} = swapDown(pos, board);
            end
        end    
    end
end

%###########################Private Methods########################%
 
%Returns the node with the lowest score in the list
function lowest = lowestScore(open)
    low = 10000;
    for i=1:length(open)
        if (open{i}.f < low)
            low = open{i}.f;
            lowest = open{i};
        end                    
    end
end

%Returns true if the list contains the same tile configuration as the node.
function count = matchCount(node, list)
    count = 0;
    for i=1:length(list)
        if (isequal(list{i}.board.tiles, node.board.tiles))
            count = count + 1;
            return;
        end
    end
end
%Returns the manhattan distance of the board from the goal state
function dist = manhattanDistance(board)
    dist = sum(abs(board.tiles - [1 2 3 4 5 6 7 8 9]));
end

%Given the struct of boards, this returns true if 'board' is in the
%structure and false if not
function hasBeen = hasBeenVisited(visitedBoards, board)

    tiles = board.tiles;

    for i = 1: length(visitedBoards)
        % disp('visitedBoards:\n');
        % disp(visitedBoards);
        if (isequal(visitedBoards{i}.tiles, tiles) )
            hasBeen = true;
            return;
        end
    end
    hasBeen = false;

end

%checks if the array of tiles is solvable (i.e. is in the proper 
function valid = isValidArray( tiles )    
    sum = 0;
    valid = false;
    for i=1:9        
        currentTile = tiles(i);
        if (currentTile ~= 9)
            for x=i:9
                if (tiles(x) ~= 9)
                    diff = currentTile - tiles(x);
                    if (diff > 0)
                        sum = sum + 1;
                    end
                end
            end
        end
    end
    if ( mod(sum, 2) == 0)
        valid = true;
    end
end

%Returns true is the board given matches the goal board
function finished = isGoal( board )
    finished = isequal(board.tiles, [1 2 3 4 5 6 7 8 9]);
end

%Swaps the blank tile with the tile to its left
function newBoard = swapLeft(blankPos, oldBoard)
    newBoard = swap(blankPos, oldBoard, -1);
end

%Swaps the blank tile with the tile to its right
function newBoard = swapRight(blankPos, oldBoard)
    newBoard = swap(blankPos, oldBoard, 1);
end

%Swaps the blank tile with the tile above it
function newBoard = swapUp(blankPos, oldBoard)
    newBoard = swap(blankPos, oldBoard, 3);
end

%Swaps the blank tile with the tile below it
function newBoard = swapDown(blankPos, oldBoard)
    newBoard = swap(blankPos, oldBoard, -3);
end

function newBoard = swap(blankPos, oldBoard, offset)
    swapTile = oldBoard.tiles(blankPos + offset);
    newBoard = EightBoard(oldBoard.tiles);    
    newBoard.blank_position = blankPos + offset;
    newBoard.tiles(blankPos + offset) = 9;
    newBoard.tiles(blankPos) = swapTile;
end
