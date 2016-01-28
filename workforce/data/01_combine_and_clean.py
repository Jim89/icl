# -*- coding: utf-8 -*-
"""
Created on Thu Jan 21 08:44:40 2016

@author: jim
"""
# %% Setup - load packages
import pandas as pd
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


# %% import text files
# list all files in directory
files = os.listdir("./D1_10k_files")
if 'Noname25.txt' in files:
    files.remove('Noname25.txt')

# loop over files to read in whole content to single string
contents = []
for f in files:
    path = "./D1_10k_files/" + f
    content = open(path, 'r').read()
    contents.append(content)

# remove erroneous \r and \n characters
cleaned = []    
for f in contents:
    filtered = re.sub('\\r|\\n|--', ' ', f)
    cleaned.append(filtered)

# try to remove stopwords
# need to:
    # 1. get ith section of content
    # 2. split by spaces
    # 3. remove stopwords
    # 4. combine back into single string
stop = stopwords.words('english')
stops_removed = []
for i in range(len(cleaned)):
    text = cleaned[i].lower()
    words =  text.split(' ')
    filtered_words = [word for word in words if word not in stop]
    unstopped = ' '.join(filtered_words)
    stops_removed.append(unstopped)
    

# generate firm symbols and years
firms = []
years = []
for f in files:
    # get firm name
    firms.append(f.split('_')[0])
    # get year
    years.append((f.split('_')[1])[:4])

# combine in to tidy data frame
data_dict = {'firm': firms,
             'year': years,
             'content': cleaned}
             
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