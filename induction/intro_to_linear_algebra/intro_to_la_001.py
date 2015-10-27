# -*- coding: utf-8 -*-
"""
Created on Tue Oct 06 11:51:31 2015

@author: Jleach1
"""

#%%
d = "Welcome to Imperial"
# string indexing:
d[0]
d[1:7]
d[-4]

#%%
# watch out for integer division
print(1/2)
print(1.0/2)

# this is a comment 


#%%
# arrays
# vector
a = [2,4,5,6,7]

# matrix
B= [[4,1,3], [2,2,2]]


#%% for loops
for i in range(10, 0, -1):       # range(a, b) gives seq from a to b-1
    five_times_i = 5 * i
    print('5 times %d equals %d' % (i, five_times_i))

#%% while loops
count = 0
while (count < 4):              # also <= >, ==
    print("The count is %d" % count)
    count = count + 1
 
print("Goodbye")


#%% if statements
for i in range(1, 6):
    if i<3:
        print("%d is less than 3" % i)
        
    elif i > 3:
        print("%d is greater than 3" % i)
        
    else:
       print("%d is equal to 3" % i)
 
 #%% creating functions
 # e.g. adding two functions
 a = [1, 2, 3, 4]
 b = [5, 6, 7, 8]
 c = []
 
 for i in range(0, len(a)):
     c.append( a[i] + b[i])
     
# print c

# define a function (bad example but this is how it does)
def addVec(x, y):
    z = []
    for i in range(0, len(x)):
        z.append( x[i] + y[i])
    return(z)

# run the function
addVec(a, b)

#%% use multiple arguments
def lotsofArgs(a, b, c, d, e):
    return(a+b, c+d, e)
    
lotsofArgs(1, 2, 3, 4, 5)

# collect answers
(r, s, t) = lotsofArgs(1, 2, 3, 4, 5)    
