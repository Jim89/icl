load hospital
% test code from exercise doc
h1 = hospital(1:10,:)
h2 = hospital(:,{'LastName' 'Age' 'Sex' 'Smoker'})
hospital.Properties.Description

hospital.AtRisk = hospital.Smoker | (hospital.Age > 40)
boxplot(hospital.Age,hospital.Sex)
h3 = hospital(hospital.Age<30, {'LastName' 'Age' 'Sex' 'Smoker'})
h4 = sortrows(hospital,{'Sex','Age'})

% 1, descriptive stats on weight
wght = hospital.Weight;
avg_wght = mean(wght);
med_wght = median(wght);
std_wght = std(wght);

% predict a roughly normal distribution with a slight negative skew

% 2. wght dist
hist(wght);
% data are split in to two groups:
% 1 group at lower weight and another at higher wght
% did not predict split into two groups, however do see
% slight positive skew

% 3. change number of bins
hist(wght, 100);
% fewer bins: start to see bimodal but continuous dist
% more bins: more gaps but peaks much more obvious

% 4. to convert from values to probablity we take the values and divide by
% the sum of the values
data = hist(wght, 25);
p_weight = data/sum(data);





