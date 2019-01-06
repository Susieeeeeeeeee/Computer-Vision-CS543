img = imread('sunflowers.jpg'); %'fishes.jpg', 'sunflowers.jpg', 'einstein.jpg', 'disneyland.jpg', 'universal studio.jpg', 'heart.jpg', 'colosse.jpg' 
n = 12;
Sigma = 2.0;
threshold = 0.001;
mode = 0; %mode 1: downsampling the image -- efficient ; mode 0: increasing filter size -- inefficient; mode 2: DoG
blob_detect(img, Sigma, n, threshold, mode);

