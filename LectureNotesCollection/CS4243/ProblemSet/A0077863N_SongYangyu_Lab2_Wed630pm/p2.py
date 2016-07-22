import cv2
import cv2.cv as cv
import numpy as np
import sys

image = cv2.imread("scene.jpg",cv2.CV_LOAD_IMAGE_GRAYSCALE)
harris = cv2.cornerHarris(image,5,3,0.04)
image = cv2.imread("scene.jpg",cv2.CV_LOAD_IMAGE_COLOR)

width = image.shape[1]
height = image.shape[0]

threshold = 0.001
for x in range(width):
  for y in range(height):
    if harris[y,x] > threshold:
      center = (x,y)
      radius = 3
      thickness = -1
      lineType = 8
      shift = 0
      cv2.circle(image, center, radius, (0,0,255,0), 
          thickness, lineType,shift)
cv2.imwrite("harris.jpg",image)
