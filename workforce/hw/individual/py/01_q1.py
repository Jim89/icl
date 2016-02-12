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
teams_sets = [set(x.split(';')) for x in teams]

collabs = []
for team1 in teams_sets:
    #print team1
    for team2 in teams_sets:
        intersect = len(team1 & team2)
        collabs.append(intersect)