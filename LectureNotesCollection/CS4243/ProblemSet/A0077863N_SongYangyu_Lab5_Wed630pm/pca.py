import numpy as np
import numpy.linalg as la
import matplotlib.pyplot as plt

infile = open("md-data.txt")
data = np.genfromtxt(infile, delimiter=",")
data = np.matrix(data).T
infile.close()

d = data.shape[0]
n = data.shape[1]

print "Shape of the data matrix: ",(d,n)

mean = np.mean(data,1)
print "The mean vector: "
print mean

sdata = data - mean
print "Mean of sdata: ", np.mean(sdata,1)

cov = np.cov(sdata, None, 1, 1)
print "Covariance Matrix: ", cov

eigvalues, eigvectors = la.eig(cov)
index = np.argsort(eigvalues)   # Sort the input and return index in inc order

print "Eigen Values: ", eigvalues
print "Indexs: ", index

eigenSum = np.sum(eigvalues)

for l in range(d):
  partialSum = 0
  for i in range(l):
    partialSum = eigvalues[index[i]] + partialSum
  ratio = partialSum / eigvalues
  print (l,ratio)
