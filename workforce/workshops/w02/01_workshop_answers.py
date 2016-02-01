import codecs
import os.path
import csv


# create a list of years
years = [2000, 2001, 2002, 2003, 2004, 2005]

# create a list of firms
firms = []
with open('C:/Users/Tufool/Dropbox/Teaching/Business Analytics/Workforce Analytics 2016/BS1810-1516/published/Data/firm_tickers.csv', 'rb') as f:
    reader = csv.reader(f)
    for row in reader:
        firms=firms+row
              

import timeit

# STEP 1&2 CREATE A FIRM DICTIONARY PER YEAR, AND A GLOBAL DICTIONARY OF ALL TERMS
start_time = timeit.default_timer()
global_list=[]
firm_nouns={}
for firm in firms:
    firm_list=[] 
    for year in years:	
        fname1 = "C:/Users/Tufool/Dropbox/10-Kdata/10k_files/{}_{}.txt".format(firm, year)
        if os.path.isfile(fname1):
            with codecs.open(fname1, "r",encoding='utf-8', errors='ignore') as myfile:
                text=myfile.read().replace('\n', '')
                firm_yr_list= extract_nouns(text)
                global_list=global_list+firm_yr_list                
                firm_list= firm_list+firm_yr_list
                key = "{}_{}".format(firm,year)
                firm_nouns[key]=firm_yr_list
    firm_nouns[firm]=firm_list
    
          
          
# Update the global list such that it contains only unique values                                 
(global_list,stop_list) = stop_words(global_list)

# Remove all stop words from the global list
for word in global_list:
    if word in stop_list:
        global_list.remove(word)


# Replace firm_nouns with unique values that exist in global_list 
for key in firm_nouns:
    new_nouns = list(set(global_list)&set(firm_nouns[key]))
    firm_nouns[key]=new_nouns


#Create a dictionary firm_comp which calculates firm 
firm_comp={};
for firm1 in firms:
	# for each firm, start with an empty similarity list.
	sim_list=[]
	#define vect1 as the binary vector for firm1
	vect1= firm_nouns[firm1] 
	for firm2 in firms:  
	    if firm2<>firm1:
	       #define vect2 as the binary vector for firm2
	       vect2= firm_nouns[firm2]
	       # append similarity metric to the list. 
	       sim_list.append(similarity(vect1,vect2))
        firm_comp[firm1]=sim_list	
 
elapsed = timeit.default_timer() - start_time

# Read in firm data for additional analysis

firm_data={} #create a dictionary to include firm_data
with open('C:/Users/Tufool/Dropbox/Teaching/Business Analytics/Workforce Analytics 2016/BS1810-1516/published/Data/D2 firm_level_data.csv', 'rb') as f:
    next(f) # skip header line
    reader = csv.reader(f,delimiter=',')
    for row in reader:
            key1=row[0]+'_emp'
            key2 = row[0]+'_sales'
            key3=row[0]+'_invest'
            firm_data[key1]=float(row[1])
            firm_data[key2]=float(row[2])
            firm_data[key3]= float(row[3])
    f.close()

# Descriptive statistics
import numpy as np


# (1) What is the std and mean value for number of employees
results = [ (key,value) for key, value in firm_data.iteritems() if key.endswith("_emp")]
emp=[x[1] for x in results]
all_firms = [x[0] for x in results]


print("The average number of employees is", round(np.mean(emp),3),"and the standard deviation is", round(np.std(emp)))


# (2) How many firms have a high number (mean+1 std) of employees
large_firms = [names for (names,vals) in results if vals >= np.mean(emp)+np.std(emp)]

def remove_trail(s):  # a function to remove the _emp from our list.
    return s[0:-4]

large_firms = [remove_trail(s) for s in large_firms] 
print("There are", len(large_firms),"firms with a high number of employees in our list and these are",large_firms)


# (3) what is the average dictionary size of firms (over the five year period)? how many std. deviations away from this are large firms?
dict_sizes = [len(firm_nouns[ticker]) for ticker in firms]
lf_dict_sizes=[len(firm_nouns[ticker]) for ticker in large_firms]
dist_from_mean = (np.mean(lf_dict_sizes)-np.mean(dict_sizes))/np.std(dict_sizes)  # find the distance of large firms from the mean
dist_from_mean = round(dist_from_mean, 3)

print("There average dictionary contains", round(np.mean(dict_sizes),3),"words. Large firms have slightly smaller dictionaries. The average dict size for a large firm is", dist_from_mean, "standard deviations from the average value")

# (4) what is the average annual change in firm dictionary size? Is this different for large firms

annual_vals=[] # calculate annual dictionary size for all firms
for firm in firms:
    for year in years:	
        key = "{}_{}".format(firm, year)
        if key in firm_nouns:
          tmp = (firm,len(firm_nouns[key]))
          annual_vals.append(tmp)

avg_change={};                  
for firm in firms: # calculate avg. annual change for all firms 
    val = [vals for (names, vals) in annual_vals if names==firm]
    if len(val)>1:
        change=[abs(j-i) for i, j in zip(val[:-1], val[1:])]
        avg_change[firm]=round(np.mean(change),3)
        
all_dict_change = [avg_change[ticker] for ticker in avg_change.keys()]
std_dict_change = np.std([avg_change[ticker] for ticker in avg_change.keys()])
lf_dict_change=[avg_change[ticker] for ticker in large_firms]
dist_from_mean = (np.mean(lf_dict_change)-np.mean(all_dict_change))/std_dict_change

print("There average annual change in dictionary size is", round(np.mean(all_dict_change),3),". Large firms show more variation annually. The average annual change in dict size for a large firm is", round(dist_from_mean,3), "standard deviations from the average value")


# (5) what is the correlation between dictionary size and competition? dictionary change and competition?
all_firm_comp1 = [np.mean(firm_comp[ticker]) for ticker in firms] # we have to repeat this twice because list of firms in dict_change differs
all_firm_comp2 = [np.mean(firm_comp[ticker]) for ticker in avg_change.keys()]

from scipy.stats.stats import pearsonr  
print pearsonr(dict_sizes, all_firm_comp1)
print pearsonr(all_dict_change,all_firm_comp2)
