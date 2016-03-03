%% 
clc;
% rng(19891110);
kernels = {'gaussian', 'polynomial', 'linear'};
slacks = [1e-5, 1e-4, 1e-3, 1e-2, 1e-1, 1, 1e1, 1e2, 1e3, 1e4, 1e5];



losses_svm = zeros(size(slacks, 2), size(kernels, 2));
for i = 1:length(slacks)
  for j = 1:3
    % Fit the model
    fitSVM = fitcsvm(train_input, train_output, ...
                     'Standardize', 1,...
                     'BoxConstraint', slacks(i),...
                     'KernelFunction', kernels{j},...
                     'CrossVal', 'on');

    % Compute k-fold loss
    loss = kfoldLoss(fitSVM);
    losses_svm(i, j) = loss;
  end  
end  
% Set up case for 0 losses
losses_svm(losses_svm == 0) = NaN;

% Find minimum loss in the array
[~, idx] = min(losses_svm(:));

% Find the index of the minimum loss
[I_row, I_col] = ind2sub(size(losses_svm), idx);

% Set optimal k and distance
slack = slacks(I_row);
kern = kernels{I_col};

loss_svm_cln = dataset({losses_svm 'gaussian', 'polynomial', 'linear'});
export(loss_svm_cln, 'File', '../data/created/svm_loss.csv', 'Delimiter', ',');

disp(slack)
disp(kern)

%%
% Set max k
max_k = 30;

% Set up distance metrics
distances = {'cityblock', 'chebychev', 'euclidean', 'minkowski'};

% Set up losses matrix to fill in
losses = zeros(max_k, size(distances, 2));

% Iterate over distance metrics
for j = 1:4
  % Iterate over values of k to find the best model
  for i = 1:max_k
    fitknn = fitcknn(train_input, train_output, ...
                     'NumNeighbors', i,...
                     'CrossVal', 'on',...
                     'Standardize', 1,...
                     'Distance', distances{j});
    loss = kfoldLoss(fitknn);
    losses(i, j) = loss;
  end
end;
% Set up case for 0 losses
losses(losses == 0) = NaN;

% Find minimum loss in the array
[~, idx] = min(losses(:));

% Find the index of the minimum loss
[I_row, I_col] = ind2sub(size(losses), idx);

% Set optimal k and distance
k = I_row;
dist = distances{I_col};

disp(k)
disp(dist)

% loss_cln = dataset({losses 'cityblock', 'chebychev', 'euclidean', 'minkowski'});
% export(loss_cln, 'File', '../data/created/knn_loss.csv', 'Delimiter', ',');


%% 
%% Create histograms
cols = size(input, 2);
for i = 1:cols
    filename = strcat('../images/input_hists/input_col_', num2str(i));
    histogram(input((output==0), i), 'facecolor', 'r');
    hold on;
    histogram(input((output==1), i), 'facecolor', 'b');
    hold off;
    legend('output0','output1')
    print(filename, '-dpng');
end    

%% Check data and assess class distributions
nan_input = sum(any( isnan(input), 2 )); % Rows with NaN
nan_output = sum(any( isnan(output), 2 )); % Rows with NaN

histogram(output); % Visualise class distributions






