clc
%Read in the data
data = importdata('logistic.txt');

%Split the data into X and Y arrays
X = data(:,1);
Y = data(:,2);

%Do logistic regression to get the betas and output them to the screen
[b,dev,stats] = glmfit(X,Y,'binomial','link','logit');
fprintf(1,'\nIntercept: %.4f\n', b(1));
fprintf(1,'p: : %.4f\n', b(2));

%create X values to plug into the predicted logistic model.
xx = linspace(25, max(X)+ 10);

%get predicted probabilities for the xx values
ypred = glmval(b,xx,'logit');

%get the probability of failure for a temperature of 28 degrees
fail_prob = glmval(b,28, 'logit');
fprintf('Predicted probability of failure at 28 degrees: %.2f%%\n', fail_prob * 100);

%plot the original binary response variables and the predicted regression
hold on;
figure(1);
plot(X,Y,'blacko',...
    xx,ypred,'b-', 'MarkerFace', 'black');
plot(28, fail_prob, 'r*', 'MarkerSize', 12);
axis([25 90 -.15 1.15]);
ylabel('Probability of O-ring failure');
xlabel('Temperature (F)');
title('Logistic Regression of O-ring Failures vs. Temperature');

