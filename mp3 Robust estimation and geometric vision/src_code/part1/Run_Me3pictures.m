% Comuper Vision Assignment 3 Part1 

function Run_Me3pictures
    tic
    name = {'hill', 'ledge', 'pier'};
    
    % optimized settings for other 3 groups

    harris_t = [0.01 0.01 0.01]; % harris threshold
    d_size = [25 15 25]; % descriptor size (d x d)
    ransac_t = [0.5 0.5 0.5]; % ransac threshold
    
    for i = 1:3
        nam = name{i};
      
        pic1 = sprintf('./assignment3_data//%s//1.JPG',nam);
        pic2 = sprintf('./assignment3_data//%s//2.JPG',nam);
        pic3 = sprintf('./assignment3_data//%s//3.JPG',nam);
        
        % Load images 
        im1c = im2double((imread(pic1)));
        im2c = im2double((imread(pic2)));
        im3c = im2double((imread(pic3)));
 
        % Convert images into grayscales
        im1 = rgb2gray(im1c);
        im2 = rgb2gray(im2c);
        im3 = rgb2gray(im3c);
        
        disp('left and mid');
        [im12c, stat12] = main_func(im1,im2,im1c,im2c,harris_t(i),d_size(i),true,ransac_t(i));
        disp("Inlier_Ratio: " + stat12.ir);

        disp('mid and right');
        [im23c, stat23] = main_func(im2,im3,im2c,im3c,harris_t(i),d_size(i),true, ransac_t(i));
        disp("Inlier_Ratio: " + stat23.ir);

        if (stat12.ir >= stat23.ir)
            disp('left+mid and right');
            im12 = rgb2gray(im12c);
            [im123, stat123] = main_func(im12,im3,im12c,im3c,harris_t(i),d_size(i),true, ransac_t(i));
            disp("Inlier_Ratio: " + stat123.ir);
            figure;imshow(im123);    
        else
            disp('mid+right and left');
            im23 = rgb2gray(im23c);
            [im231, stat231] = main_func(im23,im1,im23c,im1c,harris_t(i),d_size(i),true, ransac_t(i));
            disp("Inlier_Ratio: " + stat231.ir);
            figure;imshow(im231);           
        end
    end
end

