% Step 0 - Get the data ---------------------------------------------------
load('../data/cancer.mat');

input = cancer.inputs;
output = cancer.outputs;

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


%% Set up test and train  
% Find number of rows
rows = size(input, 1);

% Randomly permute rows
elems = randperm(rows)';

% Find half of data size
half = floor(rows/2)';

% Set up test and train index
train_idx = elems(1:half);
test_idx = elems((half+1):end);

% Create train
train_input = input(train_idx, :);
train_output = output(train_idx, :);

% Create test
test_input = input(test_idx, :);
test_output = output(test_idx, :);

%% Test svm
svm = TrainClassifier1(train_input, train_output);

% Get predicted values 
predicted_svm = Classify1(test_input, svm);

% Compare with truth
matches_svm = (test_output == predicted_svm);

% Percent correct
correct_svm = sum(matches_svm)/length(test_output);

% Confusion matrix
[conf_svm, order_svm] = confusionmat(predicted_svm, test_output);
csvwrite('./data/conf_svm.csv', conf_svm)

%% Test k-NN
knn = TrainClassifier2(train_input, train_output);

% Get predicted values 
predicted_knn = Classify2(test_input, knn);

% Compare with truth
matches_knn = (test_output == predicted_knn);

% Percent correct
correct_knn = sum(matches_knn)/length(test_output);

% Confusion matrix
[conf_knn, order_knn] = confusionmat(predicted_knn, test_output);
csvwrite('./data/conf_knn.csv', conf_knn)
