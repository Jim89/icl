# -*- coding: utf-8 -*-
"""
Created on Mon Feb 15 14:54:08 2016

@author: Jleach1
"""
# %%
import pandas as pd
import numpy as np

# %% read in firm data and patent data
d1 = pd.read_csv("../../../data/outputs/sims.csv")
d2 = pd.read_csv("../../../data/D2_firm_level_data.csv")
d3 = pd.read_csv("../../../data/D3_patent_data.csv")

# %% Find inventors moving firms
d3_firm_to_invs = pd.concat([d3.firm,
                             d3.pnum,
                             d3.year,
                             d3.inv_num.apply(lambda y: pd.Series(y.split(';')))], 
                             axis = 1)
                             
d3_firm_to_inv_melt = pd.melt(d3_firm_to_invs, 
                             id_vars = ['firm', 'pnum', 'year'], 
                             value_vars = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,25,25],
                             value_name = 'inv_num')
d3_reshaped_firms = d3_firm_to_inv_melt.drop('variable', axis = 1)
d3_reshaped_firms = d3_reshaped_firms.sort_values(['inv_num', 'pnum', 'firm'], ascending = [1, 1, 1])
d3_reshaped_firms['firm_list'] = [[x] for x in d3_reshaped_firms.firm]

# %% Find firms that inventors moved TO
    
d3_inventor_firms = pd.DataFrame(d3_reshaped_firms.groupby('inv_num')['firm_list'].sum())    
d3_inventor_firms.reset_index(level = 0, inplace = True)
d3_inventor_firms.columns = ['inv_num', 'firm_list']

d3_inventor_firms['num_unique_firms'] = [len(set(x)) for x in d3_inventor_firms.firm_list]
d3_inventor_firms['unique_firms'] = d3_inventor_firms.firm_list.apply(lambda x: pd.unique(x)).apply(lambda x: x[1:len(x)])


# %% Create set of inventor - firm moves
d3_moving_inv = d3_inventor_firms[(d3_inventor_firms.num_unique_firms > 1)].drop('firm_list', axis = 1)

invs = d3_moving_inv.inv_num
firms = d3_moving_inv.unique_firms

inventors = []
moved_to = []
for f in range(len(firms)):
    x = firms.iloc[f]
    inventor = invs.iloc[f]
    for y in x:
        inventors.append(inventor)
        moved_to.append(y)
        
movers = pd.DataFrame({'inv_num': inventors, 'firm': moved_to})        
        
        
# %% Create list of all firms to all inventors        
firms_distinct = pd.unique(d3_reshaped_firms.firm)        
inventors_distinct = pd.unique(d3_reshaped_firms.inv_num)

firm_list = []
inv_list = []

for firm in firms_distinct:
    for inventor in inventors_distinct:
        firm_list.append(firm)
        inv_list.append(inventor)
        
# %% Create base data frame of firm to inventor and binary moved status        
q1b_base = pd.DataFrame({'firm' : firm_list, 'inv': inv_list})
q1b_base = q1b_base.merge(movers, how = 'left', left_on = ['firm', 'inv'],
                          right_on = ['firm', 'inv_num'])
q1b_base['moved_to'] = pd.notnull(q1b_base.inv_num)
q1b_base.drop('inv_num', inplace = True)
        