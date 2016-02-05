# -*- coding: utf-8 -*-
"""
Created on Thu Jan 21 08:44:40 2016

@author: jim
"""
# %% Setup - load packages
import pandas as pd
import numpy as np
                
# %% define untility functions


# %% read in firm data and patent data
d1 = pd.read_csv("../../data/outputs/sims.csv")
d2 = pd.read_csv("../../data/D2_firm_level_data.csv")
d3 = pd.read_csv("../../data/D3_patent_data.csv")

# %% Pre workshop prep
# 1. calculate mean competition for all firms in D1 data
mean_comps = pd.DataFrame(d1.groupby('firm1')['sim'].aggregate(np.mean))
mean_comps.reset_index(level = 0, inplace = True)
mean_comps.columns = ['firm', 'comp']

# 2. find closest competitors
closest_comps = d1[(d1.sim != 1) & (d1.sim > .24)]

# 3. put closest competitors in to single field
closest_comps_grouped = pd.DataFrame(closest_comps.groupby('firm1')['firm2'].apply(lambda x: ', '.join(x)))
closest_comps_grouped.reset_index(level = 0, inplace = True)
closest_comps_grouped.columns = ['firm', 'comps']


# Join all data together
d3_2_1 = pd.merge(d3, d2, 
                  left_on = 'firm', 
                  right_on = 'firm_name', 
                  how = 'left').merge(closest_comps_grouped, 
                        left_on = 'firm',
                        right_on = 'firm',
                        how = 'left').merge(mean_comps,
                        left_on = 'firm',
                        right_on = 'firm',
                        how = 'left')


d3_2_1 = d3_2_1.drop('firm_name', axis = 1)

# %% Step 1 - reshape Data
d3_pat_to_invs = pd.concat([d3.pnum, 
                             d3.inv_num.apply(lambda y: pd.Series(y.split(';')))], 
                             axis = 1)
                             
d3_pat_to_inv_melt = pd.melt(d3_pat_to_invs, 
                             id_vars = 'pnum', 
                             value_vars = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,25,25],
                             value_name = 'inv_num')
d3_reshaped = d3_pat_to_inv_melt.drop('variable', axis = 1)
d3_reshaped = d3_reshaped.sort_values(['inv_num', 'pnum'], ascending = [1, 1])
pnum_list = [[x] for x in d3_reshaped.pnum]
d3_reshaped['pnum_list'] = pnum_list
                             

# %% Step 2 - create structure to track inventor projects
d3_inventor_projects = pd.DataFrame(d3_reshaped.groupby('inv_num')['pnum_list'].sum()
d3_inventor_projects.reset_index(level = 0, inplace = True)
d3_inventor_projects.columns = ['inv_num', 'pnum_list']

# %% Step 3 - Define all indices

# %% Step 4 - Get inventors on more than one project
d3_inventor_projects['num_projects'] = [len(x) for x in d3_inventor_projects.pnum_list]
multiproj_invs = d3_inventor_projects[d3_inventor_projects.num_projects > 1]
prop = len(multiproj_invs)/float(len(d3_inventor_projects))


    
    
    







