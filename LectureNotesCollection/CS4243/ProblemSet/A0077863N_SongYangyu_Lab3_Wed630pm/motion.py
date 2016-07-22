import cv2
import cv2.cv as cv
import numpy as np

im = cv2.imread("motion0025.jpg", cv2.CV_LOAD_IMAGE_COLOR)
gr = cv2.imread("motion0025.jpg", cv2.CV_LOAD_IMAGE_GRAYSCALE)

winname = "imageWin"
win = cv.NamedWindow(winname , cv.CV_WINDOW_AUTOSIZE)
string = 'motion'
cv2.putText( im, string , (20,20) , cv2.FONT_HERSHEY_COMPLEX_SMALL, 1, (255,255,255) )

# show window
cv2.imshow("motion image" , im)
cv2.waitKey(100)

cv2.imwrite("colorImg.jpg",im)
cv2.imwrite("grayImg.jpg",gr)

videoPath = "/Users/songyy/Dropbox/OnLearning/modules/current/CS4243/Project/material/House/file11.m1v";
cap = cv2.VideoCapture(videoPath)

width = int(cap.get(cv.CV_CAP_PROP_FRAME_WIDTH))
height = int(cap.get(cv.CV_CAP_PROP_FRAME_HEIGHT))
fps = int(cap.get(cv.CV_CAP_PROP_FPS))
frameCount = int(cap.get(cv.CV_CAP_PROP_FRAME_COUNT))
print "Frame width  = " , width
print "Frame height = " , height
print "FPS  = " , fps
print "frameCount = ", cap.get(cv.CV_CAP_PROP_FRAME_COUNT)

for i in range(frameCount):
  _,im = cap.read()
  if( i % 3 == 0):
    cv2.imshow("fast forward", im)
    cv2.waitKey(100)

del cap
cv2.destroyAllWindows()
