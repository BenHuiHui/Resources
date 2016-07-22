import cv2
import cv2.cv as cv
import numpy as np

videoFilePath = "/Users/songyy/Documents/CV_Project_Files/LabVideos/Lab4/traffic.avi"
cap = cv2.VideoCapture(videoFilePath)

width = int(cap.get(cv.CV_CAP_PROP_FRAME_WIDTH))
height = int(cap.get(cv.CV_CAP_PROP_FRAME_HEIGHT))
fps = int(cap.get(cv.CV_CAP_PROP_FPS))
frameCount = int(cap.get(cv.CV_CAP_PROP_FRAME_COUNT))
print "Frame width  = " , width
print "Frame height = " , height
print "FPS  = " , fps
print "frameCount = ", frameCount

'''
_,img = cap.read()
avgImg = np.float32(img)

for fr in range(1,frameCount):
  _,img = cap.read()
  alpha = 1 / float(fr+1)
  cv2.accumulateWeighted(img,avgImg,alpha)
  normImg = cv2.convertScaleAbs(avgImg)
  # cv2.imshow("normImg",normImg)
  # cv2.imshow("img",img)
  print "fr = ",fr,", alpha = ",alpha

cv2.imwrite("background.jpg",normImg)
'''

# after get the background image, use it
normImg = cv2.imread("background.jpg")

grAvgImg = cv2.cvtColor(normImg, cv2.COLOR_RGB2GRAY)

for fr in range(frameCount):
  _,img = cap.read()
  grImg = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
  diffImg = cv2.absdiff(grImg,grAvgImg)
  thresh,biImg = cv2.threshold(diffImg, 0,266, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
  fg = cv2.dilate(biImg, None, iterations = 2)
  bgtemp = cv2.erode(biImg, None, iterations = 3)
  thresh2, bg = cv2.threshold(bgtemp, 2, 255, cv2.THRESH_BINARY_INV)
  res = cv2.bitwise_and(img, img, fg, fg)
  cv2.imshow("foreground",res)
  cv2.waitKey(100)

fg = res
cv2.imshow("Binarized Image",biImg)
cv2.waitKey(0)
cv2.imshow("Foreground Image",fg)
cv2.waitKey(0)
cv2.imshow("Background Image",bg)
cv2.waitKey(0)
cv2.destroyAllWindows()
cap.release()
