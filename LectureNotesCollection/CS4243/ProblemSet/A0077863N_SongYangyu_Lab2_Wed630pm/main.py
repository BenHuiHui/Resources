import cv2
import cv2.cv as cv
import numpy as np
import sys

image = cv2.imread("scene.jpg",cv2.CV_LOAD_IMAGE_GRAYSCALE)
features = cv2.goodFeaturesToTrack(image,100,0.01,9.0)
image = cv2.imread("scene.jpg",cv2.CV_LOAD_IMAGE_COLOR)

width = image.shape[1]
height = image.shape[0]

threshold = 0.001
radius = 3
thickness = -1
lineType = 8
shift = 0

for arr in features:
  center = arr[0]
  center = (center[0],center[1])
  cv2.circle(image, center, radius, (0,0,255,0), 
      thickness, lineType,shift)
cv2.imwrite("features.jpg",image)
