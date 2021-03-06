function generate_file( k, input_file, output_file )
% Creates all of the cnf expressions for a graph coloring of
% k colors for the input file adjacency matrix given and outputs them 
% to the output file given.

    %Read in the data
    adj_mat = importdata(input_file);

    num_nodes = length(adj_mat);
    
    % The matrix of CNF clauses for each vertex being 
    % colored one of k colors
    all_vert_colored = [];
    
    for i = 1:num_nodes
        start_k = ( (i-1)*k + 1 );
        end_k = (i*k);
        all_vert_colored(i,:) = [start_k:end_k 0];
    end
    
    % The matrix to hold the CNF clauses for each adjacenct vertex
    % not being the same color
    no_edges_same = [];
    row = 1;
    for i=1:num_nodes        
       for j=i:num_nodes           
           %check if (i, j) in adj mat == 1
           if adj_mat(i, j) == 1
              for x=1:k                
                no_edges_same(row,:) = [-all_vert_colored(i,x) -all_vert_colored(j,x) 0]; 
                row = row + 1;
              end
           end
       end        
    end
    
    fid = fopen(output_file, 'w');
    
    % Write the header of the CNF file
    fprintf(fid, 'p cnf %d %d\n', k*num_nodes, row + num_nodes - 1);
    
    %Append the CNF clauses indicatating all vertex must be colored
    dlmwrite(output_file, all_vert_colored, '-append',...
        'delimiter', ' ');
    
    % Append the CNF clauses indicating no adjacent vertexes may 
    % have the same color
    dlmwrite(output_file, no_edges_same, '-append',...
        'delimiter', ' ');
    
    % close the file
    fclose(fid);

end

