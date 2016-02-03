 % 1 set up environment - clear and load data -----------------------------
clearvars;
close all;

load('rentRegressionData');


% 2 examine data - plot it ------------------------------------------------
% figure
% plot(Prices.rent_latLong(:,1), Prices.rent_latLong(:, 2),'x', 'MarkerSize', 10)
% xlabel('Lat [deg]');
% ylabel('Long [deg]');
% title('Location of prices');

% 3 clean data ------------------------------------------------------------
% set up area of interests
latMAX = 51.7; latMIN = 51.3;
longMAX = 0.3; longMIN = -0.6;
[rr,cc] = size(Prices.rent_latLong); % [#Rows, #Columns] 
filteredPrices = struct;
filteredPrices.location = [];
filteredPrices.price = [];
for ii = 1 : rr % loop over rows of rent_latLong matrix
    lat = Prices.rent_latLong(ii,1);
    long = Prices.rent_latLong(ii,2);
    if ( lat>=latMIN && lat<=latMAX && ...
            long>=longMIN && long<=longMAX )
        filteredPrices.location = [filteredPrices.location; ...
            lat, long];
        filteredPrices.price = [filteredPrices.price; ...
            Prices.prices(ii,1)];
    end
end

% create plot to re-examine the data
% figure
% plot3(filteredPrices.location(:, 1), filteredPrices.location(:, 2), ...
%         filteredPrices.price, 'x');
% axis tight;
% grid on;
% xlabel('Lat [deg]');
% ylabel('Long [deg]');
% zlabel('Price [GBP]');
% title('London rent prices vs. location');

% try to add my location to plot
myLat = 51.5142;
myLong = -0.0931;

figure
% plot3(filteredPrices.location(:, 1), filteredPrices.location(:, 2), ...
%         filteredPrices.price, 'x');
% hold on;
% plot3(myLat, myLong, 0, '*', 'MarkerEdgeColor', 'r', 'MarkerFaceColor', 'r');    

% Q1 try to add tube locations to the plot ---------------
plot3(filteredPrices.location(:, 1), filteredPrices.location(:, 2), ...
        filteredPrices.price, 'k.');
hold on;
plot3(Tube.latLong(:, 1), Tube.latLong(:, 2), ...
        zeros(size(Tube.latLong, 1), 1), 'r*');
axis tight;
grid on;
xlabel('Lat [deg]');
ylabel('Long [deg]');
zlabel('Price [GBP]');
title('London rent prices vs. location');    
    
% 4 - randomly shuffle data for supervised learning -----------------------
[numDataPts, temp] = size(filteredPrices.price);

elems = randperm(numDataPts)';
half = floor(numDataPts/2)';

train = elems(1:half);
test = elems((half+1):end);

train_Input = filteredPrices.location(train, :);
train_Output = filteredPrices.price(train, :);

test_Input = filteredPrices.location(test, :);
test_Output = filteredPrices.price(test, :);

% Q2 - try to set up n-fold cross validation
 % set up n for n-fold
n = 5; % split in to 5 blocks

% scatter row positions
pos = randperm(numDataPts)';

% bin rows in to n partitions
edges = round(linspace(1, numDataPts, n+1));

% partition
for i = 1:n
    if i < n
        test_idx = edges(i):edges(i+1)-1;
    else
        test_idx = edges(i):edges(i+1);
    end
    
    train_idx = setdiff(1:numDataPts, test_idx);
    
    test_Input = filteredPrices.location(test_idx, :);
    test_Output = filteredPrices.price(test_idx, :);
    
    train_Input = filteredPrices.location(train_idx, :);
    train_Output = filteredPrices.price(train_idx, :);
    
    param = trainRegressor(train_Input, train_Output);
end

    
