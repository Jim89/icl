# -*- coding: utf-8 -*-
"""
Created on Fri Jan 29 12:24:02 2016

@author: Jleach1
"""

import codecs
import os.path
import csv


# create a list of years
years = [2000, 2001, 2002, 2003, 2004, 2005]

# create a list of firms
firms = []
with open('C:/Users/Jleach1/Documents/icl/workforce/data/Data/firm_tickers.csv', 'rb') as f:
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
        fname1 = "C:/Users/Jleach1/Documents/icl/workforce/data/Data/D1 10k_files/{}_{}.txt".format(firm, year)
        if os.path.isfile(fname1):
            with codecs.open(fname1, "r",encoding='utf-8', errors='ignore') as myfile:
                text=myfile.read().replace('\n', '')
                firm_yr_list= extract_nouns(text)
                global_list=global_list+firm_yr_list                
                firm_list= firm_list+firm_yr_list
                key = "{}_{}".format(firm,year)
                firm_nouns[key]=firm_yr_list
    firm_nouns[firm]=firm_list
    

# STEP 3 Update the global list such that it contains only unique values                                 
(global_list,stop_list) = stop_words(global_list)

# Remove all stop words from the global list
for word in global_list:
    if word in stop_list:
        global_list.remove(word)
        
# STEP 4        
for key in firm_nouns:
    new_nouns = list(set(global_list)&set(firm_nouns[key]))
    firm_nouns[key]=new_nouns
    
    
# STEP 5 Create a dictionary firm_comp which calculates firm 
firm_comp={};
for firm1 in firms:
	# for each firm, start with an empty similarity list.
	sim_list=[]
	#define vect1 as the binary vector for firm1
	vect1= firm_nouns[firm1] 
	for firm2 in firms: 
	       #define vect2 as the binary vector for firm2
	       vect2= firm_nouns[firm2]
	       # append similarity metric to the list. 
	       sim_list.append(similarity(vect1,vect2))
        firm_comp[firm1]=sim_list
               