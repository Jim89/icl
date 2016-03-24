%% Part 1 - Clustering of Bonds
%% Load the data
% The data were loaded, and the bubbleplot function imported from a
% sub-folder. The type and maturity dates were dropped (as they added no detail), and the rating converted to a
% numeric group.
clc; clear;

load('./data/CorporateBond.mat')
load('./data/MunicipalBond.mat')

addpath('.\functions');

CorporateBond.Maturity = [];
MunicipalBond.Maturity = [];

CorporateBond.Type = [];
MunicipalBond.Type = [];

CorporateBond.RatingX = findgroups(CorporateBond.Rating);
MunicipalBond.RatingX = findgroups(MunicipalBond.Rating);

%% Step 1 - preprocess bond data
%% Q1 - Selecting features
% In order to determine which features would be relevant for clustering
% each data set, the min, max and mean of each field was computed. These values are
% displayed below. Given the extreme range seen in bond price for both
% municipal and corporate bonds, it was not chosen for clustering (as it
% would have such a large effect compared to the other variables).
% Therefore, Coupon and YTM were chosen as the two features that would be
% used for clustering. 

corp_means = mean(double(CorporateBond(:, 1:4)));
corp_mins = min(double(CorporateBond(:, 1:4)));
corp_max = max(double(CorporateBond(:, 1:4)));

muni_means = mean(double(MunicipalBond(:, 1:4)));
muni_mins = min(double(MunicipalBond(:, 1:4)));
muni_max = max(double(MunicipalBond(:, 1:4)));

disp('Order of values is: Price, Coupon, YTM, Current Yield');

disp('Corporate bond mean values');
disp(corp_means);

disp('Corporate bond minumum values');
disp(corp_mins);

disp('Corporate bond maximum values');
disp(corp_max);


disp('Municipal bond mean values');
disp(muni_means);

disp('Municipal bond minumum values');
disp(muni_mins);

disp('Municipal bond maximum values');
disp(muni_max);

%% Q2 - Visualising the data
% The data were visualised for both corporate and municipal bonds and these
% visualisations can be seen below.

figure;
gscatter(CorporateBond.YTM, CorporateBond.Coupon, CorporateBond.Rating);
title('Corporate bonds');
xlabel('YTM');
ylabel('Coupon');

figure;
gscatter(MunicipalBond.YTM, MunicipalBond.Coupon, MunicipalBond.Rating);
title('Municpal bonds');
xlabel('YTM');
ylabel('Coupon');

%% Q3 (bonus)
% I chose these features as they showed variation in their values. However,
% such variation was not too extreme. Given that k-means can be very
% sensitive to outliers, I did not want to select features with extreme
% ranges relative to their means, as this would indicate the presence of
% outliers which may have negatively impacted the results of the
% clustering.

%% Q4 (bonus)
% As noted in question 1, I selected the same features for both corporate
% and municipal bonds as the data looked reasonably similar in terms of
% average values and ranges. As such it did not make sense to change the
% selection of features for the two sets of data.

%% K-means clustering
%% Q1 - Bubbleplots
% I chose to use Squared-Euclidean and CityBlock distance metrics, and
% present below the bubble plots generated for each distance metric when k
% was 2 and 3, for each data set.

distances = {'cityblock', 'sqeuclidean'};
for j = 1:2
  for i = 2:3
    clusters = kmeans([CorporateBond.Coupon, CorporateBond.YTM], i, ...
      'Distance', distances{j});
    figure;
    bubbleplot(CorporateBond.RatingX, CorporateBond.Coupon, CorporateBond.YTM, ...
      [], clusters);
    xlabel('Rating');
    ylabel('Coupon');
    zlabel('YTM');
    title(strcat('Corporate bond with k =', num2str(i), 'and distance = ',...
      distances{j}));
  end
end;

