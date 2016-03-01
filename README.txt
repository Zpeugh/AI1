Programming Assignment 1- Eight-Puzzle

Authors: Zach Peugh && Quinn McHugh

Here is everything you need to know about this repository.

ProblemFormulation.docx
    This is a word document outlining the problem presented.

CQueue
    Found this implementation of a queue online at:
    http://www.mathworks.com/matlabcentral/fileexchange/28922-list--queue--stack
    Credit goes to Zhiqiang Zhang.


EightBoard
    This class is a simple representation of an eight-puzzle board.
    The tiles are an array where [1 2 3 4 5 6 7 8 9] corresponds to the board
                                1 2 3
                                4 5 6
                                7 8
    9 is considered the blank tile.

BoardNode
    This is a class file representing a tree node with an Eightboard and the
    other necessary components for A* search.

BoardUtilities
    This class is used to manipulate the board.  The three main algorithms are located
    within this class and can be called on an EightBoard as such:
        BoardUtilities.bfs(board)
        BoardUtilities.idfs(board)
        BoardUtilities.astar(board)
    Each of these functions returns the number of nodes visited while building the tree
    to solve the eight-puzzle from the given starting point specified from the EightBoard.

    Additionally, there are convenience methods to generate boards.
    They create a random board, and a board n swaps from goal respectively
        BoardUtilities.generateBoard()
        BoardUtilities.generateBoard_N_StepsAway(n)


SearchTesting
    This is the actual script which runs all of the tests, plots and saves the histograms
    of the results as PNGS, and outputs the means and variances of for iterations and run times.
    To test all of this, we recommend setting MAX_MOVES_FROM_GOAL to 7 and waiting a minute for the results.


histograms/
    This folder contains all of the 6 histograms from running a trial of MAX_MOVES_FROM_GOAL = 12
    and NUMBER_OF_SAMPLES = 50.

pseudocode/
    This directory contains all of the pseudocode for the three algorithms.





Here are the results of the trial run which corresponds to the histograms seen in the histograms/ directory

######################### A* #########################
Average iterations: 52.4		variance: 4063.22
Average time (s): 0.28028		variance: 0.397348

######################### BFS #########################
Average iterations: 434.98		variance: 263910
Average time (s): 11.0299		variance: 425.273

######################### DFS #########################
Average iterations: 50559.5		variance: 1.64371e+10
Average time (s): 30.103		variance: 5636.88
