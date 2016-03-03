function parameters = TrainClassifier2(input, output)

% Set up distance metrics
distances = {'cityblock', 'chebychev', 'euclidean', 'minkowski'};

% Iterate over distance metrics
for j = 1:4
  % Iterate over values of k to find the best model
  for i = 1:30
    fitknn = fitcknn(input, output, ...
                     'NumNeighbors', i,...
                     'CrossVal', 'on',...
                     'Standardize', 1,...
                     'Distance', distances{j});
    loss = kfoldLoss(fitknn);
    losses(i, j) = loss;
  end
end;

[min, idx] = min(losses(:));
[I_row, I_col] = ind2sub(size(losses), idx);

k = I_row;
dist = distances{I_col};

parameters = fitcknn(input, output, 'NumNeighbors', k,...
                      'Standardize', 1,...
                      'Distance', distances{I_col});