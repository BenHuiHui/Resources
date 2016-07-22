import cv2
import cv2.cv as cv
import numpy as np
import sys

image = cv2.imread("scene.jpg",cv2.CV_LOAD_IMAGE_COLOR)
print image
for i in xrange(1,31,2):
  gaussianImg = cv2.GaussianBlur(image,(i,i),0)
  txt = "Gaussian Filtered Image: kernel size = " + str(i)
  cv2.putText(gaussianImg, txt, (20,20),
              cv2.FONT_HERSHEY_COMPLEX_SMALL,1,(0,255,255))
  cv2.imshow("GaussianSmoothing", gaussianImg)
  cv2.waitKey(100)
cv2.imwrite("smooth.jpg",gaussianImg)
