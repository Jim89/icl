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
    

#%% load the second network
# load data
data = open("./data/HW1_4.txt", "r")    
network4 = data.read()
data.close()

# split into list
network4 = network4.split("\r\n")

# create list of lists
n4_vals = []
for line in range(len(network4)):
    n4_vals.append(network4[line].split(" "))


