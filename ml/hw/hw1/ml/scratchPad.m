%% 
% Set seed
rng(19891110); 

kernels = char('rbf', 'gaussian', 'linear');

for i = 1:3
  % Fit the model
  fitSVM = fitcsvm(train_input, train_output, ...
                   'Standardize', true,...
                   'KernelFunction', 'rbf',...
                   'KernelScale', 'auto',...
                   'CrossVal', 'on');

  % Compute k-fold loss
  loss = kfoldLoss(fitSVM);

  loss
  
end  
%%
for i = 1:3
  char(kernels(i, :))
end

