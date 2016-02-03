# -*- coding: utf-8 -*-
"""
Created on Thu Jan 21 08:44:40 2016

@author: jim
"""
# %% Setup - load packages
import pandas as pd
import numpy as np
                
# %% define untility functions


# %% step 6 - read in firm data and patent data
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