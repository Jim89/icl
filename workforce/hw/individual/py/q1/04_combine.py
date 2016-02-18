# -*- coding: utf-8 -*-
"""
Created on Wed Feb 17 14:22:04 2016

@author: Jleach1
"""

# %%
import pandas as pd

# %%
d3_eth = pd.read_csv("../../../../data/D3_patents_to_eth.csv")
collab1 = pd.read_csv("../../../../data/outputs/collab1.csv")
collab2 = pd.read_csv("../../../../data/outputs/collab2.csv")
pat_inv_perf = pd.read_csv("../../../../data/outputs/paths_to_inv_perf.csv")

# %%
q1a = pd.merge(d3_eth, collab1)
q1a = pd.merge(q1a, collab2)
q1a = pd.merge(q1a, pat_inv_perf)
q1a.to_csv("../../../../data/outputs/q1a.csv", index = False)