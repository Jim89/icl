% Unsupervised learning tutorial - Matlab

clear all; close all; clc;
load IrisData

%% Observe the data

open IrisData

%% Covert Species Class to Binary
% (Convert to factor)
IrisData.SpeciesGroup = findgroups(IrisData.Species);

%% Visualise Data
close all;

subplot(1,2,1)
gscatter(IrisData.PetalLength, IrisData.PetalWidth, IrisData.Species)
xlabel('Petal Length')
ylabel('Petal Width')

subplot(1,2,2)
gscatter(IrisData.SepalLength, IrisData.SepalWidth, IrisData.Species)
xlabel('Sepal Length')
ylabel('Sepal Width')



%% Visualise K-Means Algorithm
close all; clc;
X = [IrisData.PetalLength, IrisData.PetalWidth];
k = 3;
n = size(X,1);

% plot the data
gscatter(X(:,1),X(:,2));
xlabel('Petal Length'); ylabel('Petal Width'); title('Iteration 1')
waitforbuttonpress

% random label initialization
estLabel = randi(k, n, 1); 

% Visualise data
gscatter(X(:,1),X(:,2),estLabel);
xlabel('Petal Length'); ylabel('Petal Width'); title('Iteration 1')
waitforbuttonpress

% Estimate cluster center
centroids = cell2mat(arrayfun(@(x) mean(X(estLabel==x,:)), unique(estLabel),'UniformOutput',0));

% Visualise cluster center
clf; gscatter(X(:,1),X(:,2),estLabel); hold on;
h = gscatter(centroids(:,1),centroids(:,2),unique(estLabel),[],'x',30);
set(h, 'LineWidth',5)
xlabel('Petal Length'); ylabel('Petal Width'); title('Iteration 1')
waitforbuttonpress

for i = 2:10
    
    % Assign new cluster to each observation
    for j = 1:length(X)
        % Calculate distance from each cluster
        D = [];
        for z = 1:k;
            D = [D pdist([X(j,:); centroids(z,:)],'euclidean')];
            % You can apply other distance metrics euclidean, cityblock, etc.
        end
        [~,idx] = min(D);
        estLabel(j) = idx;
    end
    
    % Visualise new cluster assignments
    clf; gscatter(X(:,1),X(:,2),estLabel); hold on;
    h = gscatter(centroids(:,1),centroids(:,2),unique(estLabel),[],'x',30);
    set(h, 'LineWidth',5)
    xlabel('Petal Length'); ylabel('Petal Width'); title(['Iteration ' num2str(i)])
    waitforbuttonpress
    
    % Estimate & Visualise new cluster centroids
    centroids = cell2mat(arrayfun(@(x) mean(X(estLabel==x,:),1), unique(estLabel),'UniformOutput',0));
    clf; gscatter(X(:,1),X(:,2),estLabel); hold on;
    h = gscatter(centroids(:,1),centroids(:,2),unique(estLabel),[],'x',30);
    set(h, 'LineWidth',5)
    xlabel('Petal Length'); ylabel('Petal Width'); title(['Iteration ' num2str(i)])
    waitforbuttonpress
end

%% Use Matlab's built in function
estLabel = kmeans(X, 3);

close all;
gscatter(X(:,1),X(:,2),estLabel);

%% Use all features in kmeans

X = IrisData{:,1:4};
estLabel = kmeans(X, 3);

close all;
subplot(1,2,1)
gscatter(X(:,1),X(:,2),estLabel);
xlabel(IrisData.Properties.VariableNames(1))
ylabel(IrisData.Properties.VariableNames(2))

subplot(1,2,2)
gscatter(X(:,3),X(:,4),estLabel);
xlabel(IrisData.Properties.VariableNames(3))
ylabel(IrisData.Properties.VariableNames(4))

%% Equivalen heatmap from Tuesday's tutorial

close all; 
imagesc(X)
ylabel('Observations')
xlabel('Features')
set(gca,'XTick',1:4,'XTickLabel',IrisData.Properties.VariableNames(1:4))
colorbar

%% Sum of Squares
ssq = [];
maxk = 10;
for k = 1:maxk
    [labels,centroids,sumd] = kmeans(X, k);
    ssq = [ssq sum(sumd)];
end
close all;
plot(1:maxk,ssq,'r--.','Markersize',20)

%%
% Notes: 
% 1) Remember k-means is a density based clustering technique so it is 
% extremely sensitive to outliers 
% 2) User needs to specify k
% 3) Your features must have the same unit otherwise you have to zscore





%%                Hierarchical Clustering 

close all;
X = [IrisData.PetalLength, IrisData.PetalWidth];
Z = linkage(X,'average','euclidean');

% You can apply other distance computation methods like: 
% 'single' (two closest), 'complete' (two furthest), 'average' etc. 

% You can apply other distance metrics like: 
% 'euclidean', 'cityblock', 'minkowski', 'chebychev' etc. 

dendrogram(Z, length(X));
waitforbuttonpress

% You can cut the tree at cetrain heights to form clusters
thres = 1.3;
dendrogram(Z, length(X), 'ColorThreshold', thres)
hold on;
line(xlim, [thres thres],'linestyle','--','color','k')

%% Use dendrogram to estimate class labels 
estLabels = cluster(Z,'maxclust',3);

close all;
gscatter(X(:,1),X(:,2),estLabels);
xlabel('Petal Length'); ylabel('Petal Width');