# -*- coding: utf-8 -*-
"""
Created on Mon Feb 15 15:59:58 2016

@author: Jleach1
"""

# %% Step 0 - Load packages
import pandas as pd
import jellyfish

# %% Step 1 - Define helper function
def herf(input_list):
    from collections import Counter
    counts = Counter(input_list)
    denom = sum(counts.values())
    ans = sum([(x/float(denom))**2 for x in counts.values()])
    return ans   
    
# %% Step 1 - Read in the data
d4 = pd.read_csv("../../../../data/D4_ethnic_surnames.csv")

# %% Step 2 - Convert names to metaphone representations
d4_long = pd.melt(d4)
d4_long.columns = ['ethnicity', 'name']
d4_long['meta'] = [jellyfish.metaphone(unicode(name)) for name in d4_long.name]
# d4_long = d4_long.drop_duplicates()

# %% Step 3 - Get patents and ethnicity data
d3 = pd.read_csv("../../../../data/D3_patent_data.csv")
d4_eth = pd.read_csv("../../../../data/D4_cntrycode_ethnicity.csv")

# %% Step 4 - Reshape patents data
# Firm inventor names
d3_inv_names = pd.concat([d3.firm,
                          d3.lastname.apply(lambda y: pd.Series(y.split(';')))], 
                          axis = 1)
                             
d3_inv_names = pd.melt(d3_inv_names, 
                       id_vars = ['firm'], 
                       value_vars = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,25,25],
                       value_name = 'lastname')
d3_inv_names = d3_inv_names.drop('variable', axis = 1)

                        
# Firm inventor countries
d3_inv_country = pd.concat([d3.firm, 
                            d3.cntries.apply(lambda y: pd.Series(y.split(';')))],
                            axis = 1)
                             
d3_inv_country = pd.melt(d3_inv_country, 
                             id_vars = 'firm', 
                             value_vars = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,25,25],
                             value_name = 'cntry')

d3_inv_country = d3_inv_country.drop('variable', axis = 1)   
                             
d3_inv_country['name'] = d3_inv_names.lastname
d3_inv_country = d3_inv_country.drop_duplicates()
d3_inv_country['meta'] = [jellyfish.metaphone(unicode(name)) for name in d3_inv_country.name]

# Find all countries for a firm
d3_inv_country.fillna('unknown', inplace = True)
d3_firm_countries = pd.DataFrame(d3_inv_country.groupby('firm')['cntry'].apply(lambda x: ', '.join(x)))
d3_firm_countries.reset_index(level = 0, inplace = True)

# %% Step 5 - Combine
# Join on ethnicity based on name
meta_eth = pd.merge(d3_inv_country, d4_long, how = "left")
meta_eth.columns = ['firm', 'cntry', 'name', 'meta', 'eth_name']

# Join on ethnicity based on country
meta_eth = meta_eth.merge(d4_eth, how = "left")

# Replace missing values
meta_eth.loc[meta_eth.eth_name.isnull(), 'eth_name'] = meta_eth.ethnicity

meta_eth.drop('ethnicity', axis = 1, inplace = True)
meta_eth.columns = ['firm', 'cntry', 'name', 'meta', 'ethnicity']
meta_eth.ethnicity = [str(x).lower() for x in meta_eth.ethnicity]

# %% Step 6 - Roll back up to firm level for ethnicities
firm_eth = pd.DataFrame(meta_eth.groupby('firm')['ethnicity'].apply(lambda x: ', '.join(x)))
firm_eth.reset_index(level = 0, inplace = True)

# Add back firm country lists
firm_eth = pd.merge(firm_eth, d3_firm_countries)

# %% Step 7 Calculate diversity and cross-cntry
firm_eth['eth_div'] = firm_eth.ethnicity.apply(lambda x: 1-herf(pd.unique(x.split(','))))
firm_eth['cntry_div'] = firm_eth.cntry.apply(lambda x: 1-herf(pd.unique(x.split(','))))

# Write to csv
firm_eth.to_csv("../../../../data/outputs/firm_eth.csv", index = False)




