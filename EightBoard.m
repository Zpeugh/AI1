classdef EightBoard
    %An Eight-Puzzle board object.
    %Takes an array of tiles as the constructor
    
    properties
        tiles
        blank_position 
    end
          
    methods
        function obj = EightBoard(t)
                  
            obj.tiles = t;
            obj.blank_position = find(ismember(t, 9));          
        
        end
    end
    
end
