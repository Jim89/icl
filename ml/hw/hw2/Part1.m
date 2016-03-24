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

CorporateBond.Rating = findgroups(CorporateBond.Rating);
MunicipalBond.Rating = findgroups(MunicipalBond.Rating);

%% Step 1 - preprocess bond data
%% Q1 - Selecting features
% In order to determine which features would be relevant for clustering
% each data set, the range of each field was computed. These values are
% displayed below

% Municpal bonds:
% For municpal bonds, I have selected the same features
gscatter(MunicipalBond.Price, MunicipalBond.YTM, MunicipalBond.Rating)

% Set up data matrices for ease of use
corp_mat = [CorporateBond.Price, CorporateBond.YTM];
muni_mat = [MunicipalBond.Price, MunicipalBond.YTM];

corp_rat = double(CorporateBond.Rating);
muni_rat = double(MunicipalBond.Rating);

%% Step 2 - K-means clustering - corporate bonds
% I will be using the cityblock and euclidean distance measures
% Set up distance metrics
distances = {'cityblock', 'sqeuclidean'};
max_k = 10;

% Simple loop to create bubble plots
for j = 1:2
  for i = 2:3
    filename = strcat('./images/corp/bubble_k', num2str(i), '_', distances{j});
    clusters = kmeans(corp_mat, i, 'Distance', distances{j});
    bubbleplot(corp_rat, corp_mat(:, 1), corp_mat(:, 2), [], clusters);
    print(filename, '-dpng');
  end
end;

% Set up matrix to fill in
sil_means_corp = zeros(max_k, size(distances, 2));

% Iterate over distance metrics and k for Coporate bonds
for j = 1:2
  for i = 1:max_k
    clusters = kmeans(corp_mat, i, 'Distance', distances{j});
    sils = silhouette(corp_mat, clusters);
    avg_sil = mean(sils);
    sil_means_corp(i, j) = avg_sil;
  end
end;

for j = 1:2
  filename = strcat('./images/corp/cluster_eval_', distances{j});
  main = strcat('Average Silhouette Values vs. Number of Clusters with ', distances{j});
  figure;
  plot(1:10,sil_means_corp(:, j),'o-')
  xlabel('Number of Clusters')
  ylabel('Mean Silhouette Value')
  title(main)
  print(filename, '-dpng');
end  


%% Step 2 - K-means clustering - corporate bonds
% Set up matrix to fill in
sil_means_muni = zeros(max_k, size(distances, 2));

% Simple loop to create bubble plots
for j = 1:2
  for i = 2:3
    filename = strcat('./images/muni/bubble_k', num2str(i), '_', distances{j});
    clusters = kmeans(muni_mat, i, 'Distance', distances{j});
    bubbleplot(muni_rat, muni_mat(:, 1), muni_mat(:, 2), [], clusters);
    print(filename, '-dpng');
  end
end;

% Iterate over distance metrics and k for Municipal bonds
for j = 1:2
  for i = 1:max_k
    clusters = kmeans(corp_mat, i, 'Distance', distances{j});
    sils = silhouette(corp_mat, clusters);
    avg_sil = mean(sils);
    sil_means_muni(i, j) = avg_sil;
  end
end;

for j = 1:2
  filename = strcat('./images/muni/cluster_eval_', distances{j});
  main = strcat('Average Silhouette Values vs. Number of Clusters with ', distances{j});
  figure;
  plot(1:10,sil_means_muni(:, j),'o-')
  xlabel('Number of Clusters')
  ylabel('Mean Silhouette Value')
  title(main)
  print(filename, '-dpng');
end  


