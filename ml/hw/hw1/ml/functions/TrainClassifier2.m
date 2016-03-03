function parameters = TrainClassifier2(input, output)

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
    fitknn = fitcknn(input, output, ...
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

% Find minimum loss
[~, idx] = min(losses(:));
[I_row, I_col] = ind2sub(size(losses), idx);

% Find optimal parameters based on minimal loss
k = I_row;

parameters = fitcknn(input, output, 'NumNeighbors', k,...
                      'Standardize', 1,...
                      'Distance', distances{I_col});