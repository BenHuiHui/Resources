import cv2
import numpy as np

def drawFeatures(featureSet,image):
  color = (255, 0,0)
  for i in range(featureSet.shape[0]):
    p = (int(featureSet[i,0,0]) , int(featureSet[i,0,1]));
    text = "%d" % i
    cv2.circle(image,p,2,color)


fileLoc = "/Volumes/HDD/Dropbox/OnLearning/modules/current/CS4243/ProblemSet/A0077863N_SongYangyu_Lab4_Wed630pm/foreground.png"
colorImg = cv2.imread(fileLoc)
grayImg = cv2.imread(fileLoc,cv2.CV_LOAD_IMAGE_GRAYSCALE)

featureNumToFidn = 300; qualityLevel = 0.001; minDistance = 9.0

features = cv2.goodFeaturesToTrack(grayImg, featureNumToFidn, qualityLevel, minDistance)


drawFeatures(features,colorImg)
cv2.imwrite("minEigenVal.jpg",colorImg)
colorImg = cv2.imread(fileLoc)
T = True
features = cv2.goodFeaturesToTrack(grayImg, featureNumToFidn, qualityLevel, minDistance,useHarrisDetector=T)
drawFeatures(features,colorImg)
cv2.imwrite("harris.jpg",colorImg)
raw_input("Press Enter to Continue...")
