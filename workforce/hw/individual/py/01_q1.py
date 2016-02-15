# -*- coding: utf-8 -*-
"""
Created on Fri Feb 12 12:28:53 2016

@author: Jleach1
"""

# %% import packages
import pandas as pd

# %%
d2 = pd.read_csv('../../../data/d2_firm_level_data.csv')
d3 = pd.read_csv('../../../data/d3_patent_data.csv')

# %% Compute collaboration
teams = d3.inv_num
teams_sets = [x.split(';') for x in teams]
invs = pd.unique([y for x in teams_sets for y in x])

# %% Reshape d3 to inventor level
d3_inv = pd.concat([d3.pnum, 
                    d3.inv_num.apply(lambda y: pd.Series(y.split(';')))], 
                    axis = 1)
                    
d3_inv = pd.melt(d3_inv, 
                 id_vars = 'pnum', 
                 value_vars = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,25,25],
                 value_name = 'inv_num')
d3_inv = d3_inv.drop('variable', axis = 1)

# %%
inv_list = pd.unique([inv for inv in d3_inv.inv_num])

patent = []
inv1 = []
inv2 = [] 
import timeit               
start_time = timeit.default_timer()
for inv in inv_list:
    pats_dat = d3_inv[(d3_inv.inv_num == inv)].dropna()
    pats = [pat for pat in pats_dat.pnum]
    for pat in pats:
        collab_dat = d3_inv[(d3_inv.pnum == pat)].dropna()
        collabs = [collab for collab in collab_dat.inv_num]
        for collabor in collabs:
            inv1.append(inv)
            inv2.extend([collabor])
            patent.append(pat)
            
collaborators = pd.DataFrame(inv1, inv2)
collaborators.reset_index(level = 0, inplace = True)
collaborators.columns = ['inv2', 'inv1']
collaborators = collaborators.sort_values(['inv1', 'inv2'], ascending = [1, 1])        
elapsed = timeit.default_timer() - start_time   

# collapse to unique values and write to csv
collaborators.drop_duplicates(inplace = True)
collaborators.to_csv('../../../data/outputs/collaborators.csv', index = False)
                
                
                