clear all;
load stockreturn

%% Observe variables

open stockreturn

%% Visualise Data;

close all;
X = double(stockreturn(:,2:7));
plot(stockreturn(:,1),X,'.')
xlabel('Time')
ylabel('\Delta change')

%% Explore correlations between shares

close all;
corrplot(X)

%% See statistics

clc;

disp('Mean')
disp(mean(X))

disp('Var')
disp(var(X))

%% Correlation vs Covariance explanations
clc
% cov(A,B) = E([A?E(A)][B?E(B)])
disp('Covariance')
disp(cov(X))

% cor(A,B) = E([A?E(A)][B?E(B)]) / ( sd(A) * sd(B) )
disp('Correlation')
disp(corr(X))

%% Z Scoring 

% Subtract Mean
normX = bsxfun(@minus, X, mean(X));
% Divide by Standard Deviation
normX = bsxfun(@rdivide, normX, std(X));

disp('Mean')
disp(mean(normX)) % The non zero means is due to precision error 

disp('Var')
disp(var(normX))

%% Calulate eigenvalues and eigenvectors
close all; clc
[eigVec, eigVal] = eig(cov(X));

% get diagonal elements
eigVal = diag(eigVal)'; 

disp('eigenvalues')
disp(eigVal)

disp('eigenvectors')
disp(eigVec)


%% Estimete 1st PC
clc; 

% find the index of max eigenVal
[~, maxEigValIndex] = max(eigVal);

% Multiply data by equivalent eiqenvector
firstPC = X * eigVec(:,maxEigValIndex);

close all;
plot(firstPC)
disp(['Variability explained: ' num2str( eigVal(maxEigValIndex)/sum(eigVal(:)) * 100)])

%% 1st PC from cov and corr

close all;
[eigVec, eigVal] = eig(cov(X));
eigVal = diag(eigVal); 
[~, maxEigValIndex] = max(eigVal);
firstPCCov = X * eigVec(:,maxEigValIndex);
plot(firstPCCov,'b')
hold on;

[eigVec, eigVal] = eig(corr(X));
eigVal = diag(eigVal); 
[~, maxEigValIndex] = max(eigVal);
firstPCCorr = X * eigVec(:,maxEigValIndex);
plot(-firstPCCorr,'r')

legend('Covariance','Correlation')

%% Use matlab's PCA built-in function
clc;
[eigenVec,~,eigenVal,~,VarExplained] = pca(X)

close all; 
plot(VarExplained,'--o')
ylim([0 100])
set(gca,'XTick',1:length(VarExplained))
xlabel('No. of PCs')
ylabel('Variability Explained')

%% Test the null hypothesis that the mean of the log returns of each stock is zero
clc;

[h,p] = ttest(X)
