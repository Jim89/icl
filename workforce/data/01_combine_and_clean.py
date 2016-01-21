# -*- coding: utf-8 -*-
"""
Created on Thu Jan 21 08:44:40 2016

@author: jim
"""
# %% Setup - load packages
import pandas as pd

# %% Read in the data
d1 = pd.read_excel("./D1_10k_files/semicon10k_2000_2005.xlsx")
d2 = pd.read_csv("D2_firm_level_data.csv")
d3 = pd.read_csv("D3_patent_data.csv")
d4 = pd.read_csv("D4_cntrycode_ethnicity.csv")
d5 = pd.read_csv("D4_ethnic_surnames.csv")

# %% Combine data
d1_2 = pd.merge(d1, d2,
                left_on = 'Ticker',
                right_on = 'firm_name',
                how = 'outer')
                
                
d2_3 = pd.merge(d2, d3, 
                left_on = 'firm_name', 
                right_on = 'firm', 
                how = 'outer')
                
# %% d3 cleaning
d3_firm_to_invs = pd.concat([d3.firm, 
                             d3.inv_num.apply(lambda y: pd.Series(y.split(';')))], 
                             axis = 1)

d3_firm_to_names = pd.concat([d3.firm, 
                             d3.lastname.apply(lambda y: pd.Series(y.split(';')))], 
                             axis = 1)                             

d3_firm_to_country = pd.concat([d3.firm, 
                             d3.cntries.apply(lambda y: pd.Series(y.split(';')))], 
                             axis = 1)                                

invs = ['inv%d' % i for i in range(1, len(d3_firm_to_invs.columns))]
d3_firm_to_invs.columns= ['firm'] + invs

