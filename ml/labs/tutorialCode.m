% Predict cars' origin: US (label 1) or Other (label 0) using the following 6 predictors: 
% MPG, Acceleration, Cylinders, Displacement, Weight, Horsepower

%% Plot Histograms
close all; clear; clc;
load tutorialData
for i = 1:6             % we have 6 predictors
    subplot(2,3,i)      % creates a 2 x 3 figure
    class1 = class==0;  % index for class 1;
    class2 = class==1;  % index for class 2;
    histogram( data( class1, i ), 'facecolor', 'b' )
    hold on;
    histogram( data( class2 ,i ), 'facecolor', 'r' )
    title( labels{i} )
    ylabel( 'Frequency' )
end
legend('Class 1','Class 2')


%% Make sure data are ok
% e.g. Treat the missing values appropriately
% Think about removing, interpolating etc. 
close all; clear; clc;
load tutorialData

okIndex = ~ any( isnan(data), 2 ); % Rows without NaN
class = class(okIndex);
data = data(okIndex,:);

%% Problem with Labels
% We have 245 American & 147 Other cars. 
% Observe class variable -> classes are sorted
% What is the problem with this situation? 

randomisedIndex = randperm( length( class ) );
data = data( randomisedIndex, : );
class = class( randomisedIndex );

%% Split Training vs Testing Data
% Use a 3-Fold Cross Validation

foldIndex = crossvalind( 'Kfold', length(class), 3 );
for i = 1:3
    TestData = data( foldIndex==i, : );
    TestLabels = class( foldIndex==i );
    TrainData = data( foldIndex~=i, : );
    TrainLabels = class( foldIndex~=i );
    
    % *************************************************************
    % Here you have to add the code for your classification method.
    % Store the prediction accuracy for each fold
    % At the end of the loop, report the average performance
    % *************************************************************
end


%% Simple K-NN classification
% Important: Remember to check different values of K
clc;
knnModel = fitcknn( TrainData , TrainLabels , 'NumNeighbors', 3); % 'NumNeighbors' is the K
predictedLabel = predict( knnModel, TestData );
performance = sum( predictedLabel == TestLabels ) / length( TestLabels ) * 100; % correctly predicted / all predictions
display( [ 'Prediction Performance: ' num2str( performance, 3) '%' ] );

% You can also use weights based on distance using: 'DistanceWeight','inverse'


%% Naive Bayesian Classifier 
clc;
bayesModel = fitcnb( TrainData , TrainLabels );
predictedLabel = predict( bayesModel, TestData );
performance = sum( predictedLabel == TestLabels ) / length( TestLabels ) * 100;
display( [ 'Prediction Performance: ' num2str( performance, 3) '%' ] );


%% Support Vector Machines
clc;
bayesModel = fitcsvm( TrainData , TrainLabels , 'KernelFunction', 'linear'); 
predictedLabel = predict( bayesModel, TestData );
performance = sum( predictedLabel == TestLabels ) / length( TestLabels ) * 100;
display( [ 'Prediction Performance: ' num2str( performance, 3) '%' ] );

% Alternatively, you can use 'rbf' or 'polynomial' kernels

%% Other Considerations: Normalise Data 

normData = bsxfun( @minus, data, nanmean(data) ); % subtract mean
normData = bsxfun( @rdivide, normData, nanstd(normData) ); % divide by standard deviation

%% Other Considerations: Use PCA for dimensionality reduction
close all; clc;
pcaData = normData*pca(normData);
gscatter(pcaData(:,1),pcaData(:,2),class)
xlabel('Principle Component 1')
ylabel('Principle Component 2')
legend('Non-US','US')
