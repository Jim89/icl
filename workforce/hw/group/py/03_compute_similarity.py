# -*- coding: utf-8 -*-
"""
Created on Mon Feb  8 08:23:46 2016

@author: jim
"""

# %% Setup - reset and load packages
%reset
import pandas as pd
import numpy as np

# %% Step 1 - read in the data
centers_df = pd.read_csv("./data/cleaned/01_centres_to_nouns.csv")
people_df = pd.read_csv("./data/cleaned/02_people_to_nouns.csv")