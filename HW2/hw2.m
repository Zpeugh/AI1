%Script for Lab2 question 2a

X = importdata('data/xdata.txt');
Y = importdata('data/ydata.txt');
w = importdata('data/wdata.txt');

% Add column of ones to X matrix
rows = size(X);
rows = rows(1);
X = [ones(rows, 1) X]; 


%%%%%%%%%%%%%%%%%%%%%%%%%% 2 (a) %%%%%%%%%%%%%%%%%%%%%%%%%%

%Use MATLABS built in regression function
betas = regress(Y, X);

disp('The unweighted betas are:');
disp(betas);

%%%%%%%%%%%%%%%%%%%%%%%%%% 2 (b) %%%%%%%%%%%%%%%%%%%%%%%%%%

%Some quick linear algebra for the weighted betas
W = diag(w); %Get the diagonal weights
x_T = transpose(X);
w_betas = inv(x_T * W * X) * x_T * W * Y;

disp('The weighted betas are:');
disp(w_betas);