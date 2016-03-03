%% 
% Set seed
rng(19891110); 

kernels = {'rbf', 'gaussian', 'linear'};

for i = 1:3
  % Fit the model
  fitSVM = fitcsvm(train_input, train_output, ...
                   'Standardize', true,...
                   'KernelFunction', kernels{i},...
                   'KernelScale', 'auto',...
                   'CrossVal', 'on');

  % Compute k-fold loss
  loss = kfoldLoss(fitSVM);

  loss
  
end  
%%
losses = [];
for i = 1:10
  fitknn = fitcknn(train_input, train_output, ...
                   'NumNeighbors', i,...
                   'CrossVal', 'on',...
                   'Standardize', 1);
  loss = kfoldLoss(fitknn);
  losses(i) = loss;
end