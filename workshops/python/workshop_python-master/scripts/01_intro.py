# %% Load packages
import pandas as pd
import numpy as np
import scipy as sp
import sklearn
import matplotlib.pyplot as plt

%matplotlib inline

# %% Load example data
from sklearn import datasets
digits = datasets.load_digits()

# take a look at the data
digits.data
digits.target

# How one image looks as an array
digits.images[0]

# %% Learning and predicting with sk-l
from sklearn import svm

# Generally the sk-learn API is the same for all types of learning problems:
# 1 - Set up the model object (svm), setting any necessary parameters
clf = svm.SVC(gamma = .001, C = 100.)

# 2 - Fit the model using the data (here we leave one obs out for testing)
clf.fit(digits.data[:-1], digits.target[:-1])

# 3 - Predict using some unseen data
clf.predict(digits.data[-1:, :])

# Look at the image
plt.figure(figsize=(2, 2))
plt.imshow(digits.images[-1], interpolation='nearest', cmap=plt.cm.binary)

# Check the prediction
print(digits.target[-1])

