# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

#%% set working directory
# cd /media/jim/Storage/Documents/gdrive/Imperial/course/networks/hw/hw1


#%% load the first network
data = open("./data/HW1_3.txt", "r")
network3 = data.read()
data.close()

# split lines up
network3 = network3.split("\r\n")

# create list of lists
n3_vals = []
for line in range(len(network3)-1):
    n3_vals.append(network3[line].split(" "))
    

# Implementing max cost spanning tree steps:
# 0. read in the data - DONE
# 1. extract all edges with weights from network data - DONE
# 2. sort edges by weights (in decreasing order for max cost) - DONE
# 3. select edge 1 as first edge - DONE
# 4. select next edge, test and follow - DONE
#   i. does picking this edge create a cycle? - DONE
#   ii. if yes - ignore it - DONE
#   ii. if no, keep it - DONE
# 5. repeat until all edges are tested - DONE
# 6. find a way to format as edgelist again!

#%% reading in data
import pandas as pd
data = pd.read_table("./data/HW1_3.txt",
                     sep = " ",
                     header = None, 
                     names = ['vx', 'vy', 'weight'])

# sort by weights for iteration purposes                     
data = data.sort_values("weight", ascending = False)

# find number of rows in data (for iteration purposes)
rows = len(data.index)

# set up empty containers
edges = []
vertices = []


# iterate over rows of data
for row in range(rows):
    datum = data.iloc[row, ]
    if datum[0] and datum[1] in vertices:
        pass
    else:
        edges.append(datum[2])
        if datum[0] not in vertices:
            vertices.append(datum[0])
        if datum[1] not in vertices:
            vertices.append(datum[1])
 
    
    
                     
