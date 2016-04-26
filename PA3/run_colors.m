for i=3:50
    out_file = sprintf('k_colors/%d.txt', i);
    A = generate_file(i, 'matrix_25.txt', out_file);
end