# set the company number as ordered ID
set NUM ordered;

# set the other parameters
param comp {NUM}; # compensation
param years {NUM}; #yrs in position
param change_stock {NUM}; # % change stock prices
param change_sales {NUM}; # % change sales
param mba {NUM}; # yes/no [1/0]

# load the data
data CEO_Comp.dat;

# set the underlying decision variables (i.e. the betas)
var beta_years;
var beta_change_stock;
var beta_change_sales;
var beta_mba;

# set the theta decision variable
var theta {NUM};

# set the objective function
minimize obj: sum{i in NUM} theta[i];

# set the constraints
subject to c1 {i in NUM}: theta[i]>= comp[i]-(beta_years*years[i] + beta_change_stock*change_stock[i] + beta_change_sales*change_sales[i] + beta_mba*mba[i]);
subject to c2 {i in NUM}: theta[i]>= (beta_years*years[i] + beta_change_stock*change_stock[i] + beta_change_sales*change_sales[i] + beta_mba*mba[i]) - comp[i];