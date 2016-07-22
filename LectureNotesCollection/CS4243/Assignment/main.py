import numpy as np
import numpy.linalg as la


def format_for_output(pre_str,res):
  return "%s = %8.4f %8.4f %8.4f\n" % (pre_str,res[0],res[1],res[2])

def format_for_output_single(pre_str, res):
  return "%s = %8.4f\n" % (pre_str, res)

def questionProc(A,include_3_4):
  # 1.1
  print "A = \n",A

  # 1.2
  print "A's rank = " , la.matrix_rank(A)

  if(include_3_4):
    # 1.3
    print "A's inverse = \n" , la.inv(A)

    # 1.4
    res = np.cross(A[0],A[1])
    print format_for_output(" cross product between first row and second row of A",res)

    res = np.cross(A[0],A[2])
    print format_for_output(" cross product between first row and third row of A",res)

    res = np.cross(A[1],A[2])
    print format_for_output(" cross product between second row and third row of A",res)

    res = np.cross(A[0],A[0])
    print format_for_output(" cross product between first row and first row of A",res)

    res = np.cross(A[1],A[1])
    print format_for_output(" cross product between second row and second row of A",res)

    res = np.cross(A[2],A[2])
    print format_for_output(" cross product between third row and third row of A",res)

    print "The first and second rows of A are orthogonal to each other."
    print "The first and third rows of A are orthogonal to each other."
    print "The second and third rows of A are orthogonal to each other."

  # 1.5
  (eigenValue,eigenVector) = la.eig(A)
  print "EigenValues of A:\n",eigenValue
  print "EigenVectors of A:\n",eigenVector

  # 1.6
  (U,s,V) = la.svd(A)
  print "Singular Values:"
  print s
  print "Matrix U:\n"
  print U
  print "Matrix V:\n"
  print V

  # 1.7
  res = np.dot(U[:,0],U[:,1])
  print format_for_output_single(" dot product between first column and second column of U",res)

  res = np.dot(U[:,0],U[:,2])
  print format_for_output_single(" dot product between first column and third column of U",res)

  res = np.dot(U[:,1],U[:,2])
  print format_for_output_single(" dot product between second column and third column of U",res)

  res = np.dot(U[:,0],U[:,0])
  print format_for_output_single(" dot product between first column and first column of U",res)

  res = np.dot(U[:,1],U[:,1])
  print format_for_output_single(" dot product between second column and second column of U",res)

  res = np.dot(U[:,2],U[:,2])
  print format_for_output_single(" dot product between third column and third column of U",res)

  res = np.dot(V[:,0],V[:,1])
  print format_for_output_single(" dot product between first column and second column of V",res)

  res = np.dot(V[:,0],V[:,2])
  print format_for_output_single(" dot product between first column and third column of V",res)

  res = np.dot(V[:,1],V[:,2])
  print format_for_output_single(" dot product between second column and third column of V",res)

  res = np.dot(V[:,0],V[:,0])
  print format_for_output_single(" dot product between first column and first column of V",res)

  res = np.dot(V[:,1],V[:,1])
  print format_for_output_single(" dot product between second column and second column of V",res)

  res = np.dot(V[:,2],V[:,2])
  print format_for_output_single(" dot product between third column and third column of V",res)

# Q1
print("\t\t\tOutput for question 1: \n")
A = np.eye(3)
questionProc(A,1)

# Q2.1
print("\n\n\t\t\tOutput for question 2: \n")
A = np.array([[1,0,0],[0,1,0],[1,1,0]])
questionProc(A,0)

# Q3
print("\n\n\t\t\tOutput for question 3: \n")
A = np.array([ [10,0,0],[0,10,0],[0,0,0.0001]])
# Q3.1
print "Determinate of A: ", la.det(A)
# Q3.2
print "Rank of A: ", la.matrix_rank(A)
# Q3.3
(U,s,V) = la.svd(A)
print "Singular values of A: ",s
# Q3.4
print "Practically, rank of A should be 2"
