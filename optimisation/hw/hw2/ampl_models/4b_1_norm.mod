# set the company number as ordered ID
set NUM ordered;

# set the other variables
param comp {NUM}; # compensation
param years {NUM}; #yrs in position
param change_stock {NUM}; # % change stock prices
param change_sales {NUM}; # % change sales
param mba {NUM}; # yes/no [1/0]

data CEO_Comp.dat 
