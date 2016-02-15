# -*- coding: utf-8 -*-
"""
Created on Mon Feb 15 16:32:38 2016

@author: Jleach1
"""

# %% Step 0 - import packages
import pandas as pd
import numpy as np

# %% Step 1 - Get the data
sims = pd.read_csv("../../../../data/outputs/sims.csv")

# %% Step 2 - Aggregate similarity data
# 1. calculate mean competition for all firms in D1 data
mean_comps = pd.DataFrame(sims.groupby('firm1')['sim'].aggregate(np.mean))
mean_comps.reset_index(level = 0, inplace = True)
mean_comps.columns = ['firm', 'comp']

# 2. find closest competitors
closest_comps = sims[(sims.sim != 1) & (sims.sim > .24)]

# 3. put closest competitors in to single field
closest_comps_grouped = pd.DataFrame(closest_comps.groupby('firm1')['firm2'].apply(lambda x: ', '.join(x)))
closest_comps_grouped.reset_index(level = 0, inplace = True)
closest_comps_grouped.columns = ['firm', 'comps']

# 4. find number of competitors
closest_comps_grouped['n_comp'] = closest_comps_grouped.comps.apply(lambda x: len(x.split(',')))