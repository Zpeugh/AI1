% This is the script file to test bfs, astar, and iterative dfs algorithms
% implemented in BoardUtilities. This script generates 50 total
% random starting configurations. 
% Because DFS and BFS take extremely long when the number of steps
% required to finish them is over 15, we will keep the number of moves
% away from the goal state below 12.  So all 50 are between 3-12 moves
% away. 
% However, if you would like to test A_star, it has worked on any
% number of positions away with a maximum time to find the goal state of
% around 5 minutes.  Normally much lower.

MAX_MOVES_FROM_GOAL = 12;
NUMBER_OF_SAMPLES = 50;

%stepsAway = [3, 5, 7, 9, 11, 13, 15, 20, 25, 30];

stepsAway = randi(MAX_MOVES_FROM_GOAL - 3,NUMBER_OF_SAMPLES,1) + 3;
startingConfigs = {};

for i=1:length(stepsAway)    
    startingConfigs{end + 1} = BoardUtilities.generateBoard_N_StepsAway(stepsAway(i));
end


% Now we need performance data for BFS, IDS, and A*.
% Criteria needed per board case:
%   -Running time 
%   -Iterations 


% % A* Performance
disp('STARTING A* PROCESSING');
disp('----------------------');

aStarIterations = linspace(50,0,50);
aStarTimes = linspace(50,0,50);

for i=1:length(startingConfigs)
    tic;
    iterations = BoardUtilities.astar(startingConfigs{i});
    elapsed = toc;
    
    aStarIterations(i) = iterations;
    aStarTimes(i) = elapsed;
    
    fprintf('Case %d (%d steps away): iterations=%d and time=%f sec\n', i, stepsAway(i), iterations, elapsed);
end

% BFS Performance
disp('')
disp('STARTING BFS PROCESSING')
disp('-----------------------')

bfsIterations = linspace(50,0,50);
bfsTimes = linspace(50,0,50);

for i=1:length(stepsAway)
    tic;
    iterations = BoardUtilities.bfs(startingConfigs{i});
    elapsed = toc;
    
    bfsIterations(i) = iterations;
    bfsTimes(i) = elapsed;
    
    fprintf('Case %d (%d steps away): iterations=%d and time=%f sec\n', i, stepsAway(i), iterations, elapsed);
end



% DFS Performance
disp('')
disp('STARTING DFS PROCESSING')
disp('-----------------------')

dfsIterations = linspace(50,0,50);
dfsTimes = linspace(50,0,50);

for i=1:length(stepsAway)
    tic;
    iterations = BoardUtilities.idfs(startingConfigs{i});
    elapsed = toc;
    
    dfsIterations(i) = iterations;
    dfsTimes(i) = elapsed;
    
    fprintf('Case %d (%d steps away): iterations=%d and time=%f sec\n', i, stepsAway(i), iterations, elapsed);
end


%%%%%%%%%%%%%%%%%%%%%% Nodes %%%%%%%%%%%%%%%%%
figure(1);
hist(aStarIterations);
title('A* nodes visited');
xlabel('Number of Nodes');
ylabel('Frequency');
saveas(1, 'astar_nodes.png');

figure(2)
hist(bfsIterations);
title('BFS nodes visited');
xlabel('Number of Nodes');
ylabel('Frequency');
saveas(2, 'bfs_nodes.png');

figure(3);
hist(dfsIterations);
title('DFS nodes visited');
xlabel('Number of Nodes');
ylabel('Frequency');
saveas(3, 'dfs_nodes.png');

%%%%%%%%%%%%%%%%%%%%%% Times %%%%%%%%%%%%%%%%%
figure(4);
hist(aStarTimes);
title('A* time taken in seconds');
xlabel('time (s)');
ylabel('Frequency');
saveas(4, 'astar_times.png');

figure(5);
hist(bfsTimes);
title('BFS time taken in seconds.');
xlabel('time (s)');
ylabel('Frequency');
saveas(5, 'bfs_times.png');

figure(6);
hist(dfsTimes);
title('DFS time taken in seconds.');
xlabel('time (s)');
ylabel('Frequency');
saveas(6, 'dfs_times.png');


%%%%%%%%%%%%%%%%%%%%%%% Means and Variances %%%%%%%%%%%%%%%%%%%
fprintf(1,'\n\n######################### A* #########################');
fprintf(1,'\nAverage iterations: %g\t\tvariance: %g', mean(aStarIterations), var(aStarIterations));
fprintf(1,'\nAverage Time (s): %g\t\tvariance: %g', mean(aStarTimes), var(aStarTimes));

fprintf(1,'\n\n######################### BFS #########################');
fprintf(1,'\nAverage iterations: %g\t\tvariance: %g', mean(bfsIterations), var(bfsIterations) );
fprintf(1,'\nAverage Time (s): %g\t\tvariance: %g', mean(bfsTimes), var(bfsTimes));

fprintf(1,'\n\n######################### DFS #########################');
fprintf(1,'\nAverage iterations: %g\t\tvariance: %g', mean(dfsIterations), var(dfsIterations) );
fprintf(1,'\nAverage Time (s): %g\t\tvariance: %g', mean(dfsTimes), var(dfsTimes));


