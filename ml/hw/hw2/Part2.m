%% Part Two - PCA of stock returns
%% Loading the data
% Firstly, the Matlab environment was cleared and then the data were
% loaded.
clc; clear;
load('./data/stockreturn2.mat')

%% Question 1
% Some simple descrptive statistics were calculated for the data, and are
% displayed below.
disp('Averages');
disp(mean(stockreturn));

disp('Standard Deviations');
disp(std(stockreturn));

disp('Skewness (third moment)');
disp(skewness(stockreturn));

disp('Excess kurtosis (fourth moment)');
disp(kurtosis(stockreturn));

disp('Minium returns');
disp(min(stockreturn));

disp('Maxium returns');
disp(max(stockreturn));

%% Question 2
% The null hypothesis that the mean of returns of each stock is zero was
% tested. The results are presented below. It can be seen that none of the p-values are below 0.05. Therefore we
% fail to reject the null hypothesis that the returns are 0.

[h,p] = ttest(stockreturn);
disp('p-values for each stock')
disp(p);

%% Question 3
% Firstly, the data were normalised to Z-scores using the normc function
% from the Neural Network toolbox. The covariance and correlation matrices were computed from the data and are displayed below. 
stock_norm = normc(stockreturn);

corre = corr(stock_norm);
covar = cov(stock_norm);

disp('Correlation matrix');
disp(corre);

disp('Covariance matrix');
disp(covar);

%% Question 4
% Using the sample covariance matrix computed in the previous question, a
% principal componenets analysis was performed. The eigenvectors and
% eigenvalues were computed fromt the covariance matrix and used to define
% the principal components. The first principal component was found, plotted and
% the proportion of variance that it explained is displayed below.

[eigVec, eigVal] = eig(covar);

% Get diagonal elements to extract eigenvalues
eigVal = diag(eigVal)'; 

% Find the index of max eigenVal
[~, maxEigValIndex] = max(eigVal);

% Multiply data by equivalent eiqenvector
firstPC = stock_norm * eigVec(:,maxEigValIndex);

plot(firstPC);
title('First principal component');
xlabel('Time')
ylabel('\Delta change')

varExplained = eigVal(maxEigValIndex)/sum(eigVal(:)) * 100;

disp('Percentage of variance explained by first PC')
disp(varExplained);

%% Question 5
% In order to assess how many principal components must be used to explain
% the data, it is necessary to understand how the proportion of variance
% explained increased with the addition of each PC added. This is has been
% done using the built in Matlab pca function, and some simple
% manipulations to chart the values (see below). It is seen that with just
% two principal components, the amount of variation explained is almost
% 75%. Increasing this to 3 principal components, almost 85% of the
% variation in the data can be explained. Therefore, it seems reasonable to
% conclude that, quantitatively, either 2 or 3 principal components can be
% used to explain the data (depending just _how much_ variability we would
% like to explain).

[eigenVec,~,eigenVal,~,VarExplained] = pca(stock_norm);

explained = cumsum(VarExplained);
disp('Percentage variance explained by each additional PC (cumulatively)');
disp(explained);

plot(explained ,'--o')
ylim([0 100])
set(gca,'XTick',1:length(VarExplained))
xlabel('No. of PCs')
ylabel('Variability Explained')

%% Question 6 (bonus)
% Qualitatively, there are 5 stocks in the data covering 2 major sectors:
% technology (IBM, Intel and HP) and banks (JPM and BoA). Given that
% returns of companies in the _same sector_ tend to be related, it seems
% reasonable to state that just two principal components can be used to
% explain the data (one for each sector). From the previous question it is known that the first two PCs
% explain almost 75% of the variation in the data and so this seems like a
% reasonable statement to make, given what we know about the data being
% analysed. 