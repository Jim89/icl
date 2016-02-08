# -*- coding: utf-8 -*-
"""
Created on Mon Feb  8 07:46:43 2016

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
    
# %% step 1 - get the data for the centers
# list all files in directory
files = os.listdir("../data/researchers_scraped")

# convenience subsetter for testing
to_get = len(files)

# generate list of names
people = [f.split('.')[0] for f in files]


# set up lists to store variables
global_list = []
person_list = []

# loop over files to extract nouns
for i in range(to_get):
    f = files[i]                    # get next file
    path = "../data/researchers_scraped/" + f    # set up the path
    content = codecs.open(path, 'r', # read the file
                          encoding = 'utf-8', 
                          errors = 'ignore').read()
    # filtered = re.sub('\n', '', content)    # do a bit of cleaning
    nouns = extract_nouns(content)            # extract the nouns
    global_list = global_list + nouns         # update the global list of nouns
    person_list.append(nouns)                 # add person nouns to list              


# %% step 2 - remove duplicates and stopwords from global list
# this remove duplicates and generates a list of stop words
(global_list, stop_list) = stop_words(global_list)

# this removes stop words
global_list = [word for word in global_list if word not in stop_list]

# %% step 3 - remove stop words and duplicates from individual firm dictionaries
# remove duplicates and stopwords from firm-level dictionaries
person_list_deduped = []
for dic in person_list:
    dic = Counter(dic).keys()
    dic = [word for word in dic if word not in stop_list]
    person_list_deduped.append(dic)
    
# %% step 4 - create and write data frame 
# generate data frame of centre and deduped nouns
people_to_nouns = {'centre': people[:to_get],
                    'nouns': person_list_deduped}

people_df = pd.DataFrame(people_to_nouns)
people_df.to_csv("../data/cleaned/02_people_to_nouns.csv", index = False)
    
    
    
    