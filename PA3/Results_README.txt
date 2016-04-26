Quinn McHugh & Zach Peugh
PA3 Results Write-Up
Dr. Finn - Due 4/27

Using our MatLab program we generated 50 distinct input files,
each representing the n-coloring problem where 1<=n<=50 on the
given input matrix. We used the input matrix that was assigned
to Zach Peugh. After running MiniSat on these input files, we
were able to narrow the range to which the minimum n-coloring
belonged to [12, 15].

To run the MATLAB function in generate_file.m, there are 3
parameters: k, input_file, output_file.  They mean the following:

    K           The number of colors to test for
    input_file  The input file containing the adjacency matrix
    output_file The name of the file you wish to put the CNF
                formatted output into.
