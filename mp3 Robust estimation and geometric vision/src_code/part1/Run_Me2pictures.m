% Comuper Vision Assignment 3 Part1 
function Run_Me2pictures
    tic

    % optimized Settings for the first group
    harris_t = 0.08; % harris Threshold
    d_size = 25; % descriptor size (d x d)
    ransac_t = 15; % ransac threshold

    % load images 

    im1c = im2double((imread('./assignment3_data/uttower/1.JPG')));
    im2c = im2double((imread('./assignment3_data/uttower/2.JPG')));

    % convert images into grayscales
    im1 = rgb2gray(im1c);
    im2 = rgb2gray(im2c);

    % making Panorama
    [im,stat] = main_func(im1,im2,im1c,im2c,harris_t,d_size,false,ransac_t);

    disp("Num_of_Matches: " + stat.matches);
    disp("Num_of_Inliers: " + stat.inliners);
    disp("Inlier_Ratio: " + stat.ir);
    disp("Average_Residual: " + stat.ar);

    figure;imshow(im);
    disp("run time: "+num2str(toc));
end

