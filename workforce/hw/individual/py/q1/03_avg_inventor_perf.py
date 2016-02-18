# -*- coding: utf-8 -*-
"""
Created on Thu Feb 18 08:34:07 2016

@author: jim
"""

# %%
import pandas as pd
import numpy as np

# %%
d3_inv = pd.read_csv('../../../../data/outputs/d3_inv.csv')
d3_inv.dropna(inplace = True)
d3 = pd.read_csv("../../../../data/D3_patent_data.csv")

d3_inv = pd.merge(d3_inv, d3, 
                  left_on = 'pnum',
                  right_on = 'pnum',
                  how = "left")
                  
d3_inv.drop(['firm', 'year', 'inv_num_y', 'lastname', 'cntries'], axis = 1, inplace = True)
d3_inv.columns = ['pnum', 'inv_num', 'perf']

# %% Get average performance for inventors
avg_perf = pd.DataFrame(d3_inv.groupby('inv_num')['perf'].aggregate(np.mean))
avg_perf.reset_index(level = 0, inplace = True)
avg_perf.columns = ["inv_num", "avg_perf"]

d3_inv = pd.merge(d3_inv,
                  avg_perf,
                  left_on = "inv_num",
                  right_on = "inv_num",
                  how = "left")
                  
# %% Get median of average inventor performance for each patent
pats_to_inv_perf = pd.DataFrame(d3_inv.groupby("pnum")["avg_perf"].aggregate(np.median))
pats_to_inv_perf.reset_index(level = 0, inplace = True)
pats_to_inv_perf.columns = ["pnum", "med_inv_perf"]

pats_to_inv_perf.to_csv("../../../../data/outputs/paths_to_inv_perf.csv", index = False)

