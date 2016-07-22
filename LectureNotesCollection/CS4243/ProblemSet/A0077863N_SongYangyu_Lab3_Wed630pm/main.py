# part 2

import cv2
import cv2.cv as cv
import numpy as np

img1Filename = "motion0025.jpg"
img2Filename = "motion0026.jpg"

img1 = cv2.imread(img1Filename, cv2.CV_LOAD_IMAGE_COLOR)
img2 = cv2.imread(img2Filename, cv2.CV_LOAD_IMAGE_COLOR)

# Part 2.1 -- show the images
cv.NamedWindow(img1Filename , cv.CV_WINDOW_AUTOSIZE)
cv2.imshow(img1Filename , img1);
cv.NamedWindow(img2Filename , cv.CV_WINDOW_AUTOSIZE)
cv2.imshow(img2Filename , img2);
cv2.waitKey(10000)


# Part 2.2 -- print image dim
(height,width,depth)  = img1.shape
print "Image Dimension: (%d * %d)" % (width, height)

# Part 2.3 -- Convert to gray scale
grImg1 = cv2.cvtColor(img1 , cv2.COLOR_BGR2GRAY)
grImg2 = cv2.cvtColor(img2 , cv2.COLOR_BGR2GRAY)

# Part 2.4 -- Save Gray Scale Image
cv2.imwrite('grayImg1.jpg', grImg1)
cv2.imwrite('grayImg2.jpg', grImg2)

# Part 2.5
cornerCount = 100; qualityLevel = 0.001; minDistance = 9.0
feat1 = cv2.goodFeaturesToTrack(grImg1, cornerCount, qualityLevel, minDistance)

# Part 2.6
  # Refine the feature point location
criteria = (cv.CV_TERMCRIT_ITER | cv.CV_TERMCRIT_EPS , 30 , 0.01)
win = (3,3)
zero_zone  = (-1, -1)
corners = cv2.cornerSubPix(grImg1, feat1 , win, zero_zone, criteria)

feat2 = np.copy(feat1)
feat2, status, err = cv2.calcOpticalFlowPyrLK(grImg1, grImg2, feat1, feat2)
feat1 = cv2.goodFeaturesToTrack(grImg2, cornerCount, qualityLevel, minDistance)

# Part 2.7
  # Load Color images again
im1 = cv2.imread(img1Filename , cv2.CV_LOAD_IMAGE_COLOR)
windowName = "Picture 1"
cv2.namedWindow(windowName)

for feature in feat1:
  cv2.circle(im1, (int(feature[0,0]) , int(feature[0,1])) , 3, (255, 255, 255) , -1)

im2 = cv2.imread(img2Filename , cv2.CV_LOAD_IMAGE_COLOR)
windowName = "Picture 2"
cv2.namedWindow(windowName)

for feature in feat2:
  cv2.circle(im1, (int(feature[0,0]) , int(feature[0,1])) , 3, (255, 255, 255) , -1)

cv2.imshow(windowName , im1)

if cv2.waitKey(0) == 27:
  cv2.destroyAllWindows()
cv2.imwrite("track0025pyr.jpg",im1)
cv2.imwrite("track0026pyr.jpg",im2)

