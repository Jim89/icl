# -*- coding: utf-8 -*-
"""
Created on Wed Feb 17 14:22:04 2016

@author: Jleach1
"""

# %%
import pandas as pd

# %%
d3_eth = pd.read_csv("../../../../data/d3_patents_to_eth.csv")
collab = pd.read_csv("../../../../data/outputs/collab1.csv")

# %%
q1a = pd.merge(d3_eth, collab)
q1a.to_csv("../../../../data/outputs/q1a.csv", index = False)