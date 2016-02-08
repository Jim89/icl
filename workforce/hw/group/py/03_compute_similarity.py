# -*- coding: utf-8 -*-
"""
Created on Mon Feb  8 08:23:46 2016

@author: jim
"""

# %% Setup - reset and load packages
import pandas as pd
import numpy as np

# %% Define utility functions

# Calculate the similarity of two vectors 
def similarity(vect1, vect2):
    a = set(vect1)         
    b = set(vect2)
    top = len(a & b)
    bottom = len(a | b)
    sim = top / float(bottom)
    return sim

# %% Step 1 - read in the data
centers_df = pd.read_csv("../data/cleaned/01_centres_to_nouns.csv")
people_df = pd.read_csv("../data/cleaned/02_people_to_nouns.csv", nrows = 1)

# %% Step 2 - calculate similarities for all staff to all centers
# set up list(s) to hold results
person = []
centre = []
sims = []

# loop over faculty and centres to calculate similarities
for faculty in people_df.person:
    # extract the individual's text and convert to lower case
    person_text = people_df[(people_df.person == faculty)]['nouns']
    person_text = [x.lower() for x in x for x in list(person_text)]
          
    for centre_name in centers_df.centre:
        # extract the centre's text and convert to lower case
        centre_text = centers_df[(centers_df.centre == centre_name)]['nouns']
        centre_text = [x.lower() for x in x for x in list(centre_text)]
                
        #centre_text = [x.lower() for x in centre_text]
        
        # compute the similarity
        sim = similarity(person_text, centre_text)
        
        # add results to lists to track        
        person.append(faculty)
        centre.append(centre_name)
        sims.append(sim)
        
# %% Step 3- tidy up
# combine in to dict and data frame
sims_dict = {'person': person,
             'centre': centre,
             'sim': sims}
# create data frame and write to csv
person_to_centre_sims = pd.DataFrame(sims_dict)
# person_to_centre_sims.to_csv("../data/cleaned/03_similarities.csv", index = False)

            
        
        
