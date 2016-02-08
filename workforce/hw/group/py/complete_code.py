# -*- coding: utf-8 -*-
"""
Created on Mon Feb  8 09:33:06 2016

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

# %% step 1 - get the data for 
# list all files in directory
centre_files = os.listdir("../data/center_summaries")
person_files =  os.listdir("../data/researchers_scraped")

# convenience subsetter for testing
centers_to_get = len(centre_files)
people_to_get = len(person_files)

# generate firm symbols and years
centres = [f.split('.')[0] for f in centre_files]
people = [f.split('.')[0] for f in person_files]


# set up lists to store variables
global_list = []
centre_list = []
person_list = []

# loop over centre files to extract nouns
for i in range(centers_to_get):
    f = centre_files[i]                    # get next file
    path = "../data/center_summaries/" + f    # set up the path
    content = codecs.open(path, 'r', # read the file
                          encoding = 'utf-8', 
                          errors = 'ignore').read()
    # filtered = re.sub('\n', '', content)    # do a bit of cleaning
    nouns = extract_nouns(content)            # extract the nouns
    global_list = global_list + nouns         # update the global list of nouns
    centre_list.append(nouns)                 # add centre nouns to list              
    
    
# loop over person files to extract nouns
for i in range(people_to_get):
    f = person_files[i]                    # get next file
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

# %% step 3 - remove stop words and duplicates from individual dictionaries
# remove duplicates and stopwords from centre dictionaries
centre_list_deduped = []
for dic in centre_list:
    dic = Counter(dic).keys()
    dic = [word for word in dic if word not in stop_list]
    centre_list_deduped.append(dic)    
    
# remove duplicates and stopwords from people dictionaries
person_list_deduped = []
for dic in person_list:
    dic = Counter(dic).keys()
    dic = [word for word in dic if word not in stop_list]
    person_list_deduped.append(dic)
    
# %% step 4 - calculate similarites
person = []
centre = []
sims = []
i = 0   
for faculty in person_list_deduped:
    j = 0
    for centre_name in centre_list_deduped:
        person.append(people[i])
        centre.append(centres[j])
        sim = similarity(faculty, centre_name)
        sims.append(sim)
        j += 1
    i += 1

# %% Step 5 - Tidy up and write to data frame
sims_dict = {"person": person,
             "centre": centre,
             "sim": sims}    
             
sims_data = pd.DataFrame(sims_dict)      

# %% Step 6 - Find maximum similarity per person per centre
max_sim = pd.DataFrame(sims_data.groupby('person')['sim'].max())
max_sim.reset_index(level = 0, inplace = True)

staff_to_centres = pd.merge(sims_data, max_sim, how = "inner")
    
    
    
    
    
    