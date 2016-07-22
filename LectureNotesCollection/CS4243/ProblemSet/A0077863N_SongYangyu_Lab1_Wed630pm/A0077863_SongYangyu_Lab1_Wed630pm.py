import numpy as np
import numpy.linalg as la

file = open("data.txt")
data = np.genfromtxt(file, delimiter=",")
file.close()

length = data.shape[0]
M = np.zeros([length * 2,6])
b = np.empty([length * 2,1])

for i in range(length):
  dl = data[i]
  M[2 * i][0] = dl[0]
  M[2 * i][1] = dl[1]
  M[2 * i][2] = 1
  b[2 * i] = dl[2]
  M[2 * i + 1][3] = dl[0]
  M[2 * i + 1][4] = dl[1]
  M[2 * i + 1][5] = 1
  b[2 * i + 1] = dl[3]
M = np.matrix(M)
b = np.matrix(b)

print "Data:\n",data
print "M matrix:\n",M
print "b matrix:\n",b

Mt = M.transpose()
MtM = Mt * M
MtMInv = la.inv(MtM)

a_viaInv = MtMInv * Mt * b
a_viaLstsq,e,r,s = la.lstsq(M,b)
print "Value of a: \n",a_viaLstsq
normalErr = la.norm(M * a_viaLstsq - b)
subsq = normalErr ** 2
print "Normal Error:\n",normalErr
print "Sum-squared error:\n",subsq
print "Residue computed by la.lstsq: ",e
