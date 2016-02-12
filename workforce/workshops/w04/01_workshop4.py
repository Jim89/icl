# -*- coding: utf-8 -*-
"""
Created on Thu Feb 11 06:59:08 2016

@author: jim
"""

# %% import packages
import pandas as pd
import jellyfish
import scipy as sp
from scipy import stats

# %% Define helper functions
# Herfindal Index
def herf(input_list):
    from collections import Counter
    counts = Counter(input_list)
    denom = sum(counts.values())
    ans = sum([(x/float(denom))**2 for x in counts.values()])
    return ans    

# %% Step 1 - Read in the data
d4 = pd.read_csv("../../data/D4_ethnic_surnames.csv")

# %% Step 2 - Convert names to metaphone representations
d4_long = pd.melt(d4)
d4_long.columns = ['ethnicity', 'name']
d4_long['meta'] = [jellyfish.metaphone(unicode(name)) for name in d4_long.name]
# d4_long = d4_long.drop_duplicates()

# %% Step 3 - Get patents data
d3 = pd.read_csv("../../data/D3_patent_data.csv")

# %% Step 4 - Patent lastname ethnicities
## 4.1 Reshape patents data
# inventor names
d3_inv_names = pd.concat([d3.pnum, 
                             d3.lastname.apply(lambda y: pd.Series(y.split(';')))], 
                             #d3.cntries.apply(lambda y: pd.Series(y.split(';')))],
                             axis = 1)
                             
d3_inv_names_melt = pd.melt(d3_inv_names, 
                             id_vars = 'pnum', 
                             value_vars = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,25,25],
                             value_name = 'lastname')
d3_inv_names = d3_inv_names_melt.drop('variable', axis = 1)

# inventor countries
d3_inv_country = pd.concat([d3.pnum, 
                             #d3.lastname.apply(lambda y: pd.Series(y.split(';')))], 
                             d3.cntries.apply(lambda y: pd.Series(y.split(';')))],
                             axis = 1)
                             
d3_inv_country_melt = pd.melt(d3_inv_country, 
                             id_vars = 'pnum', 
                             value_vars = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,25,25],
                             value_name = 'cntry')

d3_inv_country = d3_inv_country_melt.drop('variable', axis = 1)   
                             
d3_inv_country['name'] = d3_inv_names.lastname
d3_inv_country = d3_inv_country.drop_duplicates()
d3_inv_country['meta'] = [jellyfish.metaphone(unicode(name)) for name in d3_inv_country.name]

## 4.2 - Get ethnicity data
d4_eth = pd.read_csv("../../data/D4_cntrycode_ethnicity.csv")

## 4.3 Combine
# Join on ethnicity based on name
meta_eth = pd.merge(d3_inv_country, d4_long, how = "left")
meta_eth.columns = ['pnum', 'cntry', 'name', 'meta', 'eth_name']

# Join on ethnicity based on country
meta_eth = meta_eth.merge(d4_eth, how = "left")

# Replace missing values
meta_eth.loc[meta_eth.eth_name.isnull(), 'eth_name'] = meta_eth.ethnicity

meta_eth.drop('ethnicity', axis = 1, inplace = True)
meta_eth.columns = ['pnum', 'cntry', 'name', 'meta', 'ethnicity']
meta_eth.ethnicity = [str(x).lower() for x in meta_eth.ethnicity]

# %% Step 5 - Roll back up to patent level for ethnicities
patent_eth = pd.DataFrame(meta_eth.groupby('pnum')['ethnicity'].apply(lambda x: ', '.join(x)))
patent_eth.reset_index(level = 0, inplace = True)

d3 = pd.merge(d3, patent_eth, how = 'left')

eths = []
for i in range(len(d3)):
    team_size = len(d3.lastname[i].split(';'))
    eth2 = d3.ethnicity[i].split(',')[0:team_size]
    eths.append(eth2)
    
d3.ethnicity = eths    

# %% Step 7 and 8 - Calculate diversity and add team size and cross-cntry
d3['eth_div'] = [1-herf(x) for x in d3.ethnicity]
d3['cntry_div'] = [1-herf(x.split(';')) for x in d3.cntries]
d3['team_size'] = [len(x.split(';')) for x in d3.lastname]

cross_cntry = []
for i in range(len(d3)):
    n = len(pd.unique(d3.cntries[i].split(';')))
    if n > 1:
        cross_cntry.append(1)
    else:
        cross_cntry.append(0)
        
d3['cross_cntry'] = cross_cntry
d3['eth_div_2'] = d3.eth_div**2
d3['cntry_div_2'] = d3.cntry_div**2
d3.columns = ['pnum', 'firm','year', 'performance', 'inv_num', 'lastname',
       'cntries', 'ethnicity', 'eth_div', 'cntry_div', 'team_size',
       'cross_cntry','eth_div_2', 'cntry_div_2']

# d3.to_csv("../../data/D3_patents_to_eth.csv")

# %% Step 9 - Calculate correlations
inherant_cor = sp.stats.pearsonr(d3['performance'], d3.eth_div)
acquired_cor = sp.stats.pearsonr(d3['performance'], d3.cntry_div)
team_size_cor = sp.stats.pearsonr(d3['performance'], d3.team_size)


def team_perf(inherant, acquired, team, constant):
    import numpy as np
    perf = np.exp(-.135*inherant + .231*(inherant**2) + 1.289*acquired - 1.623*(acquired**2) + .078*team + constant)
    return perf

d3['predicted_perf'] = team_perf(inherant = d3.eth_div,
                                  acquired = d3.cntry_div,
                                  team = d3.team_size,
                                  constant = 2)

# %% Fit a simple Poisson regression to the model
import statsmodels.api as sm
import pandas
from patsy import dmatrices

y, X = dmatrices('performance ~ eth_div + eth_div_2 + cntry_div + cntry_div_2 + team_size', data=d3, return_type='dataframe')

pois = sm.Poisson(y, X)
pois_res = pois.fit()



