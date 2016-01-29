# -*- coding: utf-8 -*-
"""
Created on Thu Jan 21 08:44:40 2016

@author: jim
"""
# %% Setup - load packages
import pandas as pd
import numpy as np
import codecs
import os
import re
import nltk
from collections import Counter
                
# %% define untility functions
def extract_nouns(text):
    nouns = []
    tokens = nltk.word_tokenize(text)
    tags = nltk.pos_tag(tokens)
    for item in tags:
        if item[1] == 'NN' or item[1] == 'NNP' or item[1] == 'NNS' or item[1] == 'NNPS':
            nouns.append(item)
    return nouns    
    
def stop_words(word_list):
    from collections import Counter
    counts = Counter(word_list)
    stop_list =[];
    new_word_list=[];
    for key in counts:
        new_word_list.append(key)
        freq=counts[key]/float(len(counts))
        if freq >0.1:
            stop_list.append(key)
    return (new_word_list, stop_list)    

  
# Calculate the similarity of two vectors 
def similarity(vect1, vect2):
    a = set(vect1)         
    b = set(vect2)
    top = len(a & b)
    bottom = len(a | b)
    sim = top / float(bottom)
    return sim


# %% step 1
# list all files in directory
files = os.listdir("./D1_10k_files")

# convenience subsetter for testing
to_get = len(files)

# generate firm symbols and years
firms = [f.split('_')[0] for f in files]
years = [f.split('_')[1].split('.')[0] for f in files]

# set up lists to store variables
global_list = []
firm_yr_list = []

# loop over files to extract nouns
for i in range(to_get):
    f = files[i]                    # get next file
    path = "./D1_10k_files/" + f    # set up the path
    content = codecs.open(path, 'r', # read the file
                          encoding = 'utf-8', 
                          errors = 'ignore').read()
    filtered = re.sub('\n', '', content)    # do a bit of cleaning
    nouns = extract_nouns(filtered)         # extract the nouns
    global_list = global_list + nouns       # update the global list of nouns
    firm_yr_list.append(nouns)              # 

# generate data frame of firm, year and nouns
firms_to_nouns = {'firm': firms[:to_get],
                  'year': years[:to_get],
                  'nouns': firm_yr_list}

d1_data = pd.DataFrame(firms_to_nouns)            

# %% step 2 - create dictionaries of firms
# firm_yr_list = list(d1_data['nouns'])

# strip firm nouns to just words
#rows = len(d1_data)
#for i in range(rows):
#    nouns = d1_data.loc[i, :]['nouns']              # get the nouns
#    nouns_cln = [item[0] for item in nouns]         # get just the word
#    d1_data.loc[i, :]['nouns'] = nouns_cln          # replace in df
    
# combine all years' data for each firm
d1_data_grouped = pd.DataFrame(d1_data.groupby('firm')['nouns'].sum())

firm_list = list(d1_data_grouped['nouns'])
# firm_list = [set(item) for item in firm_list]    


# %% step 3 - remove duplicates and stopwords from global list
# this remove duplicates and generates a list of stop words
(global_list, stop_list) = stop_words(global_list)

# this removes stop words
global_list = [word for word in global_list if word not in stop_list]

# %% step 4 - remove stop words and duplicates from individual firm dictionaries
# remove duplicates and stopwords from firm-level dictionaries
firm_list_deduped = []
for dic in firm_list:
    dic = Counter(dic).keys()
    dic = [word for word in dic if word not in stop_list]
    firm_list_deduped.append(dic)
    
# remove duplicates and stopwords from firm,year-level dictionaries
firm_yr_list_deduped = []
for dic in firm_yr_list:
    dic = Counter(dic).keys()
    dic = [word for word in dic if word not in stop_list]
    firm_yr_list_deduped.append(dic)
    
# %% step 5 - calculate similarites
firms_unique = sorted(Counter(firms).keys())
f1 = []
f2 = []
sims = []
i = 0   
for firm1 in firm_list_deduped:
    j = 0
    for firm2 in firm_list_deduped:
        f1.append(firms_unique[i])
        f2.append(firms_unique[j])
        sim = similarity(firm1, firm2)
        sims.append(sim)
        j += 1
    i += 1
    
sims_dict = {"firm1": f1,
             "firm2": f2,
             "sim": sims}    
             
sims_data = pd.DataFrame(sims_dict)             

# %% step 6 - read in firm data
d2 = pd.read_csv("D2_firm_level_data.csv")

# %% step 7 - descriptive statistics
# 1 - employee data
mean_empys = np.mean(d2['Employees'])
std_empys = np.std(d2['Employees'])

# 2 - large firms
large_firms = d2[d2['Employees'] >= mean_empys + std_empys]

# 3i - average dictionary size of firms
avg_dict = np.mean([len(item) for item in firm_list_deduped])
std_dict = np.std([len(item) for item in firm_list_deduped])

# 3ii - avg dict size of large firms, and distance from overall average in std's
large_firm_pos = large_firms['firm_name'].index.values
avg_dict_large = np.mean([len(firm_list_deduped[i]) for i in large_firm_pos])
std_aways = (avg_dict_large - avg_dict) / std_dict
    
# 4 - annual variation in dictionary size    
# i add length of yearly dict
d1_data['year_dict_len'] = [len(item) for item in firm_yr_list_deduped]

# ii group by firm and calcualte variance
variations = pd.DataFrame(d1_data.groupby('firm')['year_dict_len'].aggregate(np.var))

# iii averages
mean_var = np.mean(variations)
mean_var_large = np.mean(variations.loc[list(large_firms['firm_name']), :])

# 5 - correlation between dictionary size and competition
from scipy.stats import pearsonr
dict_size = [len(item) for item in firm_list_deduped]
change = np.array(variations['year_dict_len'])
change[np.isnan(change)] = 0
competition = list(sims_data.groupby('firm1')['sim'].aggregate(np.mean))

size_comp = pearsonr(dict_size, competition)
change_comp = pearsonr(change, competition)
