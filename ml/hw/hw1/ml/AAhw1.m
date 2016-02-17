% Step 0 - Get the data ---------------------------------------------------
load('../data/cancer.mat');

input = cancer.inputs;
output = cancer.outputs;
data = horzcat(input, output);

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
%%
% Set up test and train ------------------------------------------
% Find number of rows
rows = size(input, 1);

% Randomly permute rows
elems = randperm(rows)';

% Find half of data size
half = floor(rows/2)';

train_idx = elems(1:half);
test_idx = elems((half+1):end);

train_input = input(train_idx, :);
train_output = output(train_idx, :);

model = fitcknn(train_input, train_output);
svm = fitcsvm(train_input, train_output);

