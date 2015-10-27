# -*- coding: utf-8 -*-
"""
Created on Tue Oct 06 11:51:31 2015

@author: Jleach1
"""

#%% set up packages
import numpy as np

#%% multiplication - the dot product; "an algebraic operation that takes two 
# equal-length sequences of numbers (usually coordinate vectors) and returns a 
# single number. "
# A . B = sum(Ai * Bi)

np.dot([2, 3], [2, 3]) 

# arrays:
a = np.array([2, 3])
np.dot(a, a)

# we can use this to check for linear independance:
# consider vectors v1, v2, v3,... and scalars a1, a2, a3,...
# the vectors are linearly independant if
# a1v1 + a2v2 + a3v3 + ... = 0 can only be satisfied by ai = 0 for i = 1, ...,m
# where '0' indicates a vector of 0's

#%% mutliplication - matrix-matrix multiplicaton
A = np.matrix([[2, 3], [2, 3]])
B = np.matrix([[1, 0 ], [1, 1]])

A*B

C = np.array([[2, 3], [2, 3]])
D = np.array([[1, 0 ], [1, 1]])

np.dot(C, D) # also check scipy.sparse for sparse matrices

C*D # as C and D are arrays, this returns element-wise multiplication

#%% basic opn - rank: the number of independant rows/columns of a matrix
# n.b. the number of independant columns will always equal the number of
# independant rows!

A = np.eye(4) # set up identity matrix

np.linalg.matrix_rank(A) # find the matrix rank (linaly a sub-module of numpy)

import numpy.linalg as npLA
npLA.matrix_rank(A)

#%% basic opn - matrix transposition

A = np.matrix([[1, 2, 3], [4, 5, 6]])
print(A)
A.T # T is the operator for matrix transposition


#%% matrix trace - the sum of diagonal elements on a nxn matrix
np.trace(np.eye(3))

A = np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
np.trace(A)

A = np.matrix([[1, 2, 3], [4, 5, 6], [7, 8, 9]])
np.trace(A)


#%% determinant of a square matrix
A = np.matrix('2, 3; 2, 3')
np.linalg.det(A)

#%% matrix inversion, eigen values and eigen vectors
# n.b. not every matrix has an inverse
# only a square matrix has an inverse
# the inverse is unique
# if a matrix has an inverse we call it invertible

A = np.matrix('1, 2, 3; 4, 5, 6; 7, 8, 9')
[w, v] = npLA.eig(A)            # first value (w) is eigenvalues (Lambda),
                                # second value (v) is eigenvectors

A*v[:,0]-w[0]*v[:,0] # i.e. plug in to formula: A * v = v * Lambda
                    # don't get exact values back due to floating point error
                    # (but close enough)

#%% dimensionality reduction - PCA
# dataset x w/ n normalised variables with covariance matrix S
# compute eigenvalues (Lambda) an eigenvectors (v) and use these to reduce the
# dimensions:
# v[1:k] T * x = principal_components - chose k (the number of princomps we want)


#%% solving A*x = b   (A = matrix and b is a vector - e.g. solving for theta)
# basic solution is x = A-1 b - however this is computationally expensive
# instead:
A = np.matrix('5,1;2,8')
b = np.array([[1],[1]])
np.linalg.solve(A, b)   # can use solver present in the equation
# however remember that Ax=b is not solvable for every A

#%% invertible matrices
# an nxn matrix is invertible if:
    # det(A) != 0
    # A does not have eigenvalue 0
    # rank(A) = n
# easy to check in python!

#%% matrix symmetry - check with python:
A - A.T # a symmetrix matrix has A = A^T therefore this does a quick check









