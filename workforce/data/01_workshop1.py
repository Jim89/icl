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
from nltk.corpus import stopwords
from collections import defaultdict
                
# %% define untility functions
def extract_nouns(text):
    nouns = []
    tokens = nltk.word_tokenize(text)
    tags = nltk.pos_tag(tokens)
    for item in tags:
        if item[1] == 'NN' or item[1] == 'NNP' or item[1] == 'NNS' or item[1] == 'NNPS':
            nouns.append(item)
    return nouns       

  
# Calculate the cosine similarity of two vectors 
def similarity(vect1, vect2):
    numerator =  len(list(set(vect1) & set(vect2)))
    denom = len(list(set(vect1) | set(vect2)))
    if not denom:
        sim = 0
    else:
        sim = round(float(numerator)/denom,3)
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
contents = []
global_list = []
firm_yr_list = []
firm_list = []



for i in range(to_get):
    f = files[i]
    path = "./D1_10k_files/" + f
    content = codecs.open(path, 'r', encoding = 'utf-8', errors = 'ignore').read()
    filtered = re.sub('\\r|\\n|--', ' ', content)
    contents.append(filtered)
    nouns = extract_nouns(filtered)
    global_list.append(nouns)

# generate data frame of nouns to firms
firms_to_nouns = {'firm': firms[:to_get],
                  'year': years[:to_get],
                  'nouns': global_list}
                  
d1_data = pd.DataFrame(firms_to_nouns)            

# collapse global list to single list
global_list = [item for item in sublist for sublist in global_list]

# %% step 2 - create dictionaries of firms
# strip global list down to just words
global_list_words = [item[0] for item in global_list]
firm_yr_list = list(d1_data['nouns'])

# strip firm nouns to just words
rows = len(d1_data)
for i in range(rows):
    nouns = d1_data.loc[i, :]['nouns']              # get the nouns
    nouns_cln = [item[0] for item in nouns]         # get just the word
    d1_data.loc[i, :]['nouns'] = nouns_cln          # replace in df
    
# get unique list of firms
firms = d1_data['firm'].unique()

# create firm list
d1_data_grouped = pd.DataFrame(d1_data.groupby('firm')['nouns'].sum())

firm_list = list(d1_data_grouped['nouns'])
firm_list = [set(item) for item in firm_list]    


# %% step 3 - remove duplicates from global list
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
    
(global_list_words,stop_list) = stop_words(global_list_words)





# %% step 6 - read in firm data
d2 = pd.read_csv("D2_firm_level_data.csv")


# employee level
mean_empys = np.mean(d2['Employees'])
std_empys = np.std(d2['Employees'])

large_firms = d2[d2['Employees'] >= std_empys]



    
    

