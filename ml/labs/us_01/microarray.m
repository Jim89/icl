%% Load data
load('microarray.mat');

%% Run k-means

ss_s = [];

for k = 1:10
    [idx, C, sumd] = kmeans(microarray, k);
    ss = sum(sumd);
    ss_s(k) = ss;
end
%% Make the plot
plot(1:10, ss_s, '-o', 'linewidth', 2, 'markersize', 5, 'markerfacecolor', 'r')

%%


[idx, C, sumd] = kmeans(microarray, 3);
    
    
