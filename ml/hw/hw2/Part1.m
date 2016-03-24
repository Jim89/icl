%% Clustering of Bond Data
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

for j = 1:2
  for i = 2:3
    clusters = kmeans([MunicipalBond.Coupon, MunicipalBond.YTM], i, ...
      'Distance', distances{j});
    figure;
    bubbleplot(MunicipalBond.RatingX, MunicipalBond.Coupon, MunicipalBond.YTM, ...
      [], clusters);
    xlabel('Rating');
    ylabel('Coupon');
    zlabel('YTM');
    title(strcat('Municipal bond with k =', num2str(i), 'and distance = ',...
      distances{j}));
  end
end;

%% Q2 - Determining k
% Simple loops were implemented to calcualte the silhouette values for each
% cluster when using k ranging from 1 to 10. 

max_k = 10;

% Set up matrices to fill in with silhouette values
sil_means_corp = zeros(max_k, size(distances, 2));
sil_means_muni = zeros(max_k, size(distances, 2));

% Iterate over distance metrics and k for Coporate bonds
for j = 1:2
  for i = 1:max_k
    clusters = kmeans([CorporateBond.Coupon, CorporateBond.YTM], i, 'Distance', distances{j});
    sils = silhouette([CorporateBond.Coupon, CorporateBond.YTM], clusters);
    avg_sil = mean(sils);
    sil_means_corp(i, j) = avg_sil;
  end
end;

% Iterate over distance metrics and k for Municipal bonds
for j = 1:2
  for i = 1:max_k
    clusters = kmeans([MunicipalBond.Coupon, MunicipalBond.YTM], i, 'Distance', distances{j});
    sils = silhouette([MunicipalBond.Coupon, MunicipalBond.YTM], clusters);
    avg_sil = mean(sils);
    sil_means_muni(i, j) = avg_sil;
  end
end;

%% Q3 - Plotting silhouette with varied k
% Individual plots were then made of how the average silhouette value
% varied with k for each data set and distance metric. A higher silhouette
% value is better and it is seen that the squared Euclidean distance
% measure produces higher values, with an optimal value of k being 3 for
% corporate bonds and 2 for municipal bonds.

for j = 1:2
  main = strcat('Coporate bonds: silhouette vs. k for ', distances{j});
  figure;
  plot(1:10, sil_means_corp(:, j),'o-')
  xlabel('Number of Clusters')
  ylabel('Mean Silhouette Value')
  title(main)
end 

for j = 1:2
  main = strcat('Municipal bonds: silhouette vs. k for ', distances{j});
  figure;
  plot(1:10, sil_means_muni(:, j),'o-')
  xlabel('Number of Clusters')
  ylabel('Mean Silhouette Value')
  title(main)
end 

%% Q4 (bonus)
% Using the evalclusters function is another way to evaluate the clusters.
% The optimal value of k found for each data set is presented below. Note
% the the sqeuclidean distance metric _only_ was used as this had resulted in
% higher (i.e. better) silhouette values in Q3. The results are the same as
% those found via manual inspection of the visualisations produced in
% questions 3 (not particularly suprising as a very similar method was
% used!).

eva_corp = evalclusters([CorporateBond.Coupon, CorporateBond.YTM], ...
  'kmeans','silhouette','KList',[1:10], 'Distance' , 'sqeuclidean');

eva_muni = evalclusters([MunicipalBond.Coupon, MunicipalBond.YTM], ...
  'kmeans','silhouette','KList',[1:10], 'Distance' , 'sqeuclidean');

disp('Corporate bonds optimal k:');
disp(eva_corp.OptimalK);

disp('Municipal bonds optimal k:');
disp(eva_muni.OptimalK);

%% Q5
% I consider the correct number of clusters to be either 2 or 3. This is
% because of the data that are being used in the clustering solution. Bonds
% can typically be grouped by their rating into categories such as
% "investment grade" (low risk, low return), "speculative" (medium risk,
% medium return) and "junk/high speculative" bonds (high risk, high return). It seems
% appropriate, therefore, that when considering simple bond data (such as this) clustered by YTM
% and coupon (very simple measures of risk and return), an appropriate
% number of clusters is 2 or 3 (i.e. one for each of the broad investment
% categories outlined above). Furthermore, the analytical results
% presented in questions 3 and 4 help to support this view when assessing
% the "goodness" of the clustering solution using silhouette values. 

%% Heirarchical clustering
%% Q1 Bubble plots
% The average and single linkage methods were selected, along with the
% squared Euclidean and CityBlock distance measures.
linkages = {'average', 'single'};
distances_h = {'seuclidean', 'cityblock'};

for j = 1:2
  for i = 1:2
    Y = pdist([CorporateBond.Coupon, CorporateBond.YTM], distances_h{i});
    Z = linkage(Y, linkages{j});
    T = cluster(Z, 'maxclust', 3);
    figure;
    bubbleplot(CorporateBond.RatingX, CorporateBond.Coupon,...
      CorporateBond.YTM, [], T);
    xlabel('Rating');
    ylabel('Coupon');
    zlabel('YTM');
    title(strcat('Corporate bond with link: ', linkages{j}, ' and distance: ',...
        distances_h{i}));
  end
end;

for j = 1:2
  for i = 1:2
    Y = pdist([MunicipalBond.Coupon, MunicipalBond.YTM], distances_h{i});
    Z = linkage(Y, linkages{j});
    T = cluster(Z, 'maxclust', 3);
    figure;
    bubbleplot(MunicipalBond.RatingX, MunicipalBond.Coupon,...
      MunicipalBond.YTM, [], T);
    xlabel('Rating');
    ylabel('Coupon');
    zlabel('YTM');
    title(strcat('Municipal bond with link: ', linkages{j}, ' and distance: ',...
        distances_h{i}));
  end
end;



%% Q2 Dendrogams
% Simple dendrograms have been produced for each combination of linage and
% distance metric outlined above.

for j = 1:2
  for i = 1:2
    Y = pdist([CorporateBond.Coupon, CorporateBond.YTM], distances_h{i});
    Z = linkage(Y, linkages{j});
    figure;
    dendrogram(Z);
    title(strcat('Corporate bond with link: ', linkages{j}, ' and distance: ',...
        distances_h{i}));
  end
end;

for j = 1:2
  for i = 1:2
    Y = pdist([MunicipalBond.Coupon, MunicipalBond.YTM], distances_h{i});
    Z = linkage(Y, linkages{j});
    figure;
    dendrogram(Z);
    title(strcat('Municipal bond with link: ', linkages{j}, ' and distance: ',...
        distances_h{i}));
  end
end;

%% Q3
% Different combinations of linkage and distance metric _do_ produce
% different clustering results. Within a specific linkage type, the different distance
% metrics tetsted here do not appear to have a single impact. This is
% probably due to the fact that the two metrics used (i.e. CityBlock and
% squared-Euclidean) do not produce highly different results on the data
% being used, as there are few extreme outlier values which would alter the
% squared-Euclidean results. Differences _are_ seen, however, in terms of
% the linkage type. Single linkage seems much less able to separate the
% data into similarly-sized clusters than does average linkage. This is
% because the single linkage method accounts only for the distance between
% the closest pair of data points in each cluster. As there is not a lot of
% separation in the data (as seen in the scatter plots in section 1 and the
% bubble plots in sections 2 and 3) then many of the data points are close
% together, and so the single-linkage method fails to separate the data.
% The average-linkage performs better, separating the data in to 2
% similarly-sized clusters. This occurs as this method averages the
% distance between all pairwise combinations in each cluster. As such, the it strikes a good compromise between the 
% outlier-sensitivity of other methods (e.g. complete-linkage) and the
% problems of "chaining" that can occur with single-linkage when the data
% are very close together (as they are in this situation). 

%% Q4
% Of the methods tested, it appears the combination of squared-Euclidean
% distance and average-linkage methods give a reasonable clustering. This
% occurs as (as noted above), in the dimensions analysed (i.e. YTM and
% Coupon) there is not an obvious separation in the data into many clusters
% (see figures in section 1). For both data-sets, there are some outliers,
% but the majority of the data lie close together. As such, using a
% distance metric which is sensitive to the presence of some outliers can
% help to tease apart the data in to separate clusters. Squared-Euclidean
% _is_ sensitive to outliers and so is appropriate in this case. The
% average linkage method also helps to deal with the closeness of the data,
% balancing the outlier sensitivity of complete-linkage with the
% over-simplification obtained with single-linkage. Furthermore, as
% discussed in section 2 (k-Means), it is appropriate to split the bond
% data in to at most 3 clusters, with 2 being an appropriate number. One
% cluster covers the safer, "investment-grade" bonds (i.e. low yield, low
% coupon) and the other contains the more speculative "junk" bonds (high
% yields and coupons, but higher risk). Given that squared-Euclidean
% distance and average-linkage achieves this separation, makes it a
% reasonable combination of methods to use when clustering the bond data. 
