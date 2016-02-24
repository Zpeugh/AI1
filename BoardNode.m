classdef BoardNode
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        board
        parent
        f
        g
        h
        successors = {}
    end    
    
    methods
        
        function obj = BoardNode(board)
            
            obj.board = board;        
            
        end
    end
    
end
