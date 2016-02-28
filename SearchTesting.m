% Generate 50 total random starting configurations. 
% 
% Breakdown is as follows:
%   - 5 boards  3 steps away from goal
%   - 5 boards  5 steps away from goal
%   - 5 boards  7 steps away from goal
%   - 5 boards  9 steps away from goal
%   - 5 boards 11 steps away from goal
%   - 5 boards 13 steps away from goal
%   - 5 boards 15 steps away from goal
%   - 5 boards 20 steps away from goal
%   - 5 boards 25 steps away from goal
%   - 5 boards 30 steps away from goal

stepsAway = [3, 5, 7, 9, 11, 13, 15, 20, 25, 30];
startingConfigs = {};

for i=1:length(stepsAway)
    for j=1:5
        startingConfigs{end + 1} = BoardUtilities.generateBoard_N_StepsAway(stepsAway(i));
    end
end


% Now we need performance data for BFS, IDS, and A*.
% Criteria needed per board case:
%   -Running time 
%   -Iterations 


% % A* Performance
disp('STARTING A* PROCESSING');
disp('----------------------');

aStarIterations = {};
aStarTimes = {};

for i=1:length(startingConfigs)
    tic;
    iterations = BoardUtilities.A_STAR(startingConfigs{i});
    elapsed = toc;
    
    aStarIterations{end + 1} = iterations;
    aStarTimes{end + 1} = elapsed;
    
    fprintf('Case %d (%d steps away): iterations=%d and time=%f sec\n', i, stepsAway(floor((i-1) / 5) + 1), iterations, elapsed);
end

% DFS Performance
disp('')
disp('STARTING DFS PROCESSING')
disp('-----------------------')

dfsIterations = {};
dfsTimes = {};

for i=1:(5*find(stepsAway==13, 1))
    tic;
    iterations = BoardUtilities.idfs(startingConfigs{i});
    elapsed = toc;
    
    dfsIterations{end + 1} = iterations;
    dfsTimes{end + 1} = elapsed;
    
    fprintf('Case %d (%d steps away): iterations=%d and time=%f sec\n', i, stepsAway(floor((i-1) / 5) + 1), iterations, elapsed);
end


% BFS Performance
disp('')
disp('STARTING BFS PROCESSING')
disp('-----------------------')

bfsIterations = {};
bfsTimes = {};

for i=1:(5*find(stepsAway==13, 1))
    tic;
    iterations = BoardUtilities.bfs(startingConfigs{i});
    elapsed = toc;
    
    bfsIterations{end + 1} = iterations;
    bfsTimes{end + 1} = elapsed;
    
    fprintf('Case %d (%d steps away): iterations=%d and time=%f sec\n', i, stepsAway(floor((i-1) / 5) + 1), iterations, elapsed);
end





