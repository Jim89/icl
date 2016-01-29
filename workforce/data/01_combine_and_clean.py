# -*- coding: utf-8 -*-
"""
Created on Thu Jan 21 08:44:40 2016

@author: jim
"""
# %% Setup - load packages
import pandas as pd
import codecs
import os
import re
import nltk
from nltk.corpus import stopwords


# %% Read in the data
d1 = pd.read_excel("D1_semicon10k_2000_2005.xlsx")
d2 = pd.read_csv("D2_firm_level_data.csv")
d3 = pd.read_csv("D3_patent_data.csv")
d4 = pd.read_csv("D4_cntrycode_ethnicity.csv")
d5 = pd.read_csv("D4_ethnic_surnames.csv")

                
# %% d3 cleaning
#d3_firm_to_invs = pd.concat([d3.firm, 
#                             d3.inv_num.apply(lambda y: pd.Series(y.split(';')))], 
#                             axis = 1)
#
#d3_firm_to_names = pd.concat([d3.firm, 
#                             d3.lastname.apply(lambda y: pd.Series(y.split(';')))], 
#                             axis = 1)                             
#
#d3_firm_to_country = pd.concat([d3.firm, 
#                             d3.cntries.apply(lambda y: pd.Series(y.split(';')))], 
#                             axis = 1)                                
#
#invs = ['inv%d' % i for i in range(1, len(d3_firm_to_invs.columns))]
#d3_firm_to_invs.columns= ['firm'] + invs


# %% step 1 - import text files
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

# clean up lists
global_list_cln = [item for item in sublist for sublist in global_list]

# generate data frame of nouns to firms
firms_to_nouns = {'firm': firms[:to_get],
                  'year': years[:to_get],
                  'nouns': global_list}
                  
d1_data = pd.DataFrame(firms_to_nouns)                  


# %% step 2 - create dictionary of words
def extract_nouns(text):
    nouns = []
    tokens = nltk.word_tokenize(text)
    tags = nltk.pos_tag(tokens)
    for item in tags:
        if item[1] == 'NN' or item[1] == 'NNP' or item[1] == 'NNS' or item[1] == 'NNPS':
            nouns.append(item)
    return nouns


# %%

# try to remove stopwords
# need to:
    # 1. get ith section of content
    # 2. split by spaces
    # 3. remove stopwords
    # 4. combine back into single string
stop = stopwords.words('english')
stops_removed = []
for i in range(len(contents)):
    text = contents[i].lower()
    words =  text.split(' ')
    filtered_words = [word for word in words if word not in stop]
    unstopped = ' '.join(filtered_words)
    stops_removed.append(unstopped)
    

# generate firm symbols and years
firms = [f.split('_')[0] for f in files]
years = [f.split('_')[1] for f in files]

# combine in to tidy data frame
data_dict = {'firm': firms,
             'year': years,
             'content': stops_removed}
             
d1_detail = pd.DataFrame(data_dict)             

    
    
# %% Combine data
d1_2 = pd.merge(d1_detail, d2,
                left_on = 'firm',
                right_on = 'firm_name',
                how = 'left')
                
                
d2_3 = pd.merge(d2, d3, 
                left_on = 'firm_name', 
                right_on = 'firm', 
                how = 'outer')    