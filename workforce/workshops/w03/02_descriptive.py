# -*- coding: utf-8 -*-
"""
Created on Fri Feb 05 11:29:08 2016

@author: Jleach1
"""
# %% load packages
import numpy as np
import pandas as pd
import scipy as sp
from scipy import stats

# %% Single-firmed inventors
single_firmed = d3_combined[d3_combined.num_unique_firms == 1]
single_firmed['unique_firm'] = [str(list(set(x))) for x in single_firmed.firm_list]
single_firm_counts = single_firmed.groupby('unique_firm')['num_unique_firms'].sum()

avg_single_count = np.mean(single_firm_counts)
std_single_count = np.std(single_firm_counts)
range_single_count = np.max(single_firm_counts) - np.min(single_firm_counts)

# %% Number projects
avg_projects = np.mean(d3_combined.num_projects)
std_projects = np.std(d3_combined.num_projects)
rng_projects = np.max(d3_combined.num_projects) - np.min(d3_combined.num_projects)


# %% firm competition to performance
avg_perfs = pd.DataFrame(d3_2_1.groupby('firm')[' performance'].mean())
avg_perfs.reset_index(level = 0, inplace = True)

performance_to_comp = pd.merge(avg_perfs,
                               mean_comps,
                               left_on = 'firm',
                               right_on = 'firm',)

cor = sp.stats.pearsonr(performance_to_comp.comp, performance_to_comp[' performance'])

# %% experience
avg_tenure = np.mean(d3_combined.year)
std_tenue = np.std(d3_combined.year)
max_tenure = np.max(d3_combined.year)

cor_exp = sp.stats.pearsonr(d3_combined.year, d3_combined.num_unique_firms)