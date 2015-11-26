# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""


#%% create cell for hello world
print("Hello, World!")

#%%  test reading plain text
# set the file location
path = "/media/jim/Storage/Documents/gdrive/Imperial/course/networks/testing_code/data/testing.txt"

# open a connection to the file
test_file = open(path, "r")

# read the whole file in - note that once the file has been read, reading from it again
# will only produce ''
data= test_file.read()

# alternatively, lines can be read iteratively
test_file2 = open(path, "r")
print(test_file2.readline())
print(test_file2.readline())
print(test_file2.readline())
print(test_file2.readline())

# files can also be iterated over to read lines one by one
for line in test_file2:
    print line
    
# files can be written to using file.write("value to write"), but they must have 
# been opened in write mode open(file, "w")
    
# after using the file we should close it
test_file.close()    
test_file2.close()

#%% code to read structured text file
import pandas as pd

path2 = "/media/jim/Storage/Documents/gdrive/Imperial/course/networks/testing_code/data/station.txt"
data = pd.read_table(path2, sep = "\t")

#%% code to read csv file
path3 = "/media/jim/Storage/Documents/gdrive/Imperial/course/networks/testing_code/data/station.csv"
data2 = pd.read_csv(path3)

#%% generate and sort a list of 100 random numbers
import numpy as np # get the module
randoms = np.random.rand(100) # generate random numbers
randoms_int = np.random.randint(low = -50, high = 51, size = 100) # or integers, specifically
randoms.sort() # sort the object
randoms_int.sort()
