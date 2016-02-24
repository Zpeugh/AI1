classdef BoardUtilities
    % Static method utility class to manipulate EightBoards
    
    properties
    end
    
    methods (Static)
        
        %Generate a random, solvable EightBoard
        function board = generateBoard()
            tiles = randperm(9);       
            moves = numMoves(tiles);
            % This measure is not smart
            while ( ~isValidArray(tiles) || moves > 3 )                
                tiles = randperm(9);
                moves = numMoves(tiles);                
                disp(moves);
            end
            board = EightBoard(tiles);
        end
        
        %Iterative depth-first search, returns the depth
        %at which the node was found
        function iterations = idfs(board)
            iterations = 1;
            found = false;
            while (found == false)                
                found = BoardUtilities.dls(board, iterations);
                iterations = iterations + 1;
                disp(iterations);
            end           
        end
                
        %Depth-Limited search for EightBoard at specified depth
        function found = dls(board, depth)
            
            if (depth == 0 && isGoal(board) )   
                found = true;
                disp('###############FOUND A GOAL STATE###############');
                return;
            elseif( depth > 0)
                adjacentBoards = BoardUtilities.nextBoards(board);           
                for i = 1: length(adjacentBoards)
                    newBoard = adjacentBoards{i};
                    found = BoardUtilities.dls(newBoard, depth - 1);
                    if (found)
                        return;
                    end
                end
            end  
            found = false;
            return;
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
                
                %Could possibly be optimized as it has to change length of
                %struct every iteration.  
                visitedBoards{length(visitedBoards) + 1} = currentBoard.tiles;
               
                %Get next possible boards
                adjacentBoards = BoardUtilities.nextBoards(currentBoard);
                
                %Check boards for goal state then push the boards into the
                %queue.  
                for i = 1: length(adjacentBoards)
                    newBoard = adjacentBoards{i};
                    if isGoal(currentBoard)
                        iterations = length(visitedBoards);
                        disp('###############FOUND A GOAL STATE###############');
                        return;
                    end
                    if (~hasBeenVisited(visitedBoards, newBoard) )
                        q.push(newBoard);
                    end
                end                
            end            
        end    
        
        %A* search algorithm that uses manhattenDistance as the heuristic
        function time = astar(board)
            
            openList = {}; 
            closedList = {};
            
            %initialize the openList with the first BoardNode
            b = BoardNode(board);
            b.g = 1;
            b.f = b.g + b.h;
            openList{1} = b;
            
            
            while (length(openList) ~=0)
                
                %remove the node, this needs to pop() and destroy the
                %element
                parentNode = openList{1};                
               
                disp(parentNode.g);
                parentNode.successors = BoardUtilities.nextBoards(board);
                nextNodes = parentNode.successors;
                
                %set the next nodes' parent to the parent node
                for i=1:length(nextNodes)
                    node = BoardNode(nextNodes{i});
                    disp(node);
                    node.parent = parentNode;
                    
                    if (isGoal(node.board))
                        disp('###############FOUND A GOAL STATE###############');
                        return;
                    end
                                       
                    node.g = parentNode.g + 1;
                    node.h = manhattenDistance(node.board);
                    node.f = node.g + node.h;
                    
                    %TODO: modify open and closed list to be able to check
                    %if values of f are lower and tiles are the same
                    skip = false;
                    if (containsBetterNode(openList, node))
                        %skip node if node.f is > the f for the one in list
                        skip = true;
                    elseif (containsBetterNode(closedList, node) || skip)
                        %skip node if node.f is > the f for the one in list                    
                    else
                        openList{length(openList) + 1} = node;
                    end
                end
                closedList{length(openList) + 1} = parentNode;     
                
                
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


function alreadyBeen = containsBetterNode(list, node)

    for i=1: length(list)
        someNode = list{i};
        if (isequal(someNode.board.tiles, node.board.tiles) )
            if ( someNode.f < node.f )
                alreadyBeen = true;
                return;
            end
        end
    end
    
    alreadyBeen = false;
        

end

%Returns the manhatten distance of the board from the goal state
function dist = manhattenDistance(board)
    dist = sum(abs(board.tiles - [1 2 3 4 5 6 7 8 9]));
end

%Given the struct of boards, this returns true if 'board' is in the
%structure and false if not
function hasBeen = hasBeenVisited(visitedBoards, board)

    tiles = board.tiles;

    for i = 1: length(visitedBoards)
        if (isequal(visitedBoards{i}, tiles) )
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


