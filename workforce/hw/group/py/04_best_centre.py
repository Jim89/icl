# -*- coding: utf-8 -*-
"""
Created on Mon Feb  8 08:50:23 2016

@author: jim
"""

# %% Setup - reset and load packages
import pandas as pd
import numpy as np

# %% Step 1 - get the data
similarities = pd.read_csv("../data/cleaned/03_similarities.csv")

# %% Step 2 - find highest similarity
best_match = pd.DataFrame(similarities.groupby('person')['sim'].max())

