%% Create Laplacian filter
function [filter] = create_filter_dog(img, sigma) 

%odd matrix size
filter_size = 2*ceil(2.5*sigma)+1;
filter1 = fspecial('gaussian', filter_size, sigma);
filtered_img1 = imfilter(img, filter1,'replicate');

sigma = sigma * 1.25;
filter2 = fspecial('gaussian', filter_size, sigma);
filtered_img2 = imfilter(img, filter2,'replicate');
        
filter = filtered_img1 - filtered_img2;

end
