function blob_detect(img, Sigma, n, threshold, mode)
%% img: raw image
%% sigma: initial value of sigma
%% n: number of levels in scale space
%% threshold: threshold on the squared Laplacian response above which to report region detections for squared response and absoulte values of imfilter 
%% mode: different methods. 
%% mode 0 stands for increasing filter size -- inefficient. 
%% mode 1 stands for downsampling the image -- efficient.
%% mode 2 stands for DoG

	
% convert image to gray scale
img = rgb2gray(img);
img = im2double(img);
[h,w] = size(img); 
    
scale_space = zeros(h,w,n);
Max_scale_space = zeros(size(scale_space));


k = 1.25;% scaling factor k

    
tic
% nonmaximum suppression in each 2D slice separately
% compare 49 neighbourhoods to find the maximum value
% Run direct Laplacian implementation
if mode == 0
	for i = 1:n
		sigma = Sigma*k^(i-1);
		filter = create_filter(sigma);
        filtered_img = imfilter(img, filter,'replicate');
		scale_space(:,:,i) = filtered_img.^2;
        % Max_scale_space(:,:,i) = ordfilt2(scale_space(:,:,i), 7^2 ,ones(7)); 
        Max_scale_space(:,:,i) = colfilt(scale_space(:,:,i), [7 7], 'sliding', @max);
    end
end
if mode == 1 
    for i = 1:n
		filter = create_filter(Sigma);
		downsampled_img = imresize(img, 1/k^(i-1), 'cubic');
		filtered_img = imfilter(downsampled_img, filter,'replicate');
		upsampled_img = imresize(filtered_img.^2, [h,w], 'cubic'); 
		scale_space(:,:,i) = upsampled_img;
        Max_scale_space(:,:,i) = ordfilt2(scale_space(:,:,i),7^2,ones(7)); 			
    end
end

% Run Difference of Gaussian 
if mode == 2
    for i = 1:n
		downsampled_img = imresize(img, 1/k^(i-1),'cubic');
		filtered_img = create_filter_dog(downsampled_img, Sigma);
        filtered_img = filtered_img / (k - 1); 
		upsampled_img = imresize(filtered_img.^2, [h,w], 'cubic'); 
		scale_space(:,:,i) = upsampled_img;
        Max_scale_space(:,:,i) = ordfilt2(scale_space(:,:,i),7^2,ones(7));		
    end 
end


% find maxima of squared Laplacian response in scale-space
% for pixel coordinate i and j, return the maximum pixel value and the cooresponding scale number 
% extract the final values which survived threshold(corresponding to detected regions)
Compare_scale_space = zeros(size(scale_space));
for i = 1:h
	for j = 1:w
		[l,p] = max(Max_scale_space(i,j,:),[],3);
        if (l >= threshold) && (l == scale_space(i,j,p))
            Compare_scale_space(i,j,p) = l;
        end   
    end
end



% X : matrix that stores x coordinates of circles
% Y : matrix that stores y coordinates of circles
X = []; 
Y = []; 
for i = 1:n
	[y,x] = find(Compare_scale_space(:,:,i));
	blob_radius = 1.414 * Sigma * k^(i-1);% sigma=radius/1.414
	[x_coor,y_coor] = circle_positions(x, y, blob_radius);
	X = [X; x_coor];
	Y = [Y; y_coor];
end 

disp("run time = "+num2str(toc));

imshow(img); 

line(X', Y', 'Color', 'r', 'LineWidth', 2.5);
title(sprintf('%d blobs detected',size(X,1)));
fprintf('%d Blobs detected\n', size(X,1));

end