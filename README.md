# Computer-Vision-CS543
# MP0
The goal of this assignment is to learn to work with images by taking the digitized Prokudin-Gorskii glass plate images and automatically producing a color image with as few visual artifacts as possible. In order to do this, you will need to extract the three color channel images, place them on top of each other, and align them so that they form a single RGB color image.  

# MP1
The goal of this assignment is to implement shape from shading.

# MP2
The goal of the assignment is to implement a Laplacian blob detector.
**Algorithm outline**
Generate a Laplacian of Gaussian filter.
Build a Laplacian scale space, starting with some initial scale and going for n iterations:
Filter image with scale-normalized Laplacian at current scale.
Save square of Laplacian response for current level of scale space.
Increase scale by a factor k.
Perform nonmaximum suppression in scale space.
Display resulting circles at their characteristic scales.

# MP3
The goal of this assignment is to implement robust homography and fundamental matrix estimation to register pairs of images, as well as attempt triangulation and single-view 3D measurements.

# MP4
A taste of machine learning and deep learning techniques in computer vision
