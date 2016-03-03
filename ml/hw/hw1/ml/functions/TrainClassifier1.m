function parameters = TrainClassifier1(input, output)
% Set up kernels and slack parameters to test
kernels = {'gaussian', 'polynomial', 'linear'};
slacks = [1e-5, 1e-4, 1e-3, 1e-2, 1e-1, 1, 1e1, 1e2, 1e3, 1e4, 1e5];

% Set up matrix to hold CV-loss values
losses_svm = zeros(size(slacks, 2), size(kernels, 2));

% Loop over slack values
for i = 1:length(slacks)
  % Loop over kernels
  for j = 1:3
    fitSVM = fitcsvm(input, output, ...
                     'Standardize', 1,...
                     'BoxConstraint', slacks(i),...
                     'KernelFunction', kernels{j},...
                     'CrossVal', 'on');

    % Compute avgerage CV-loss
    loss = kfoldLoss(fitSVM);
    
    % Fill in the matrix of loss values
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

% Fit and return optimal model
parameters = fitcsvm(input, output, ...
                     'Standardize', 1,...
                     'BoxConstraint', slack,...
                     'KernelFunction', kernels{I_col});