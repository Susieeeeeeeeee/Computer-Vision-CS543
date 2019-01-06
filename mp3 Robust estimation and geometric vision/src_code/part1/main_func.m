function [im,stat] = main_func(im1,im2,im1c,im2c,harris_t,d_size,TF,ransac_t)

% Feature Detection and Matching
[D1,D2] = get_descriptors(im1,im2,harris_t,d_size);
stat.matches = size(D1,2);

% Perform RANSAC
[H, inliers, inliers1_opt, inliers2_opt, average_residual] = ransac(D2,D1,ransac_t);
if (~TF)
    figure; axis off; showMatchedFeatures(im1c,im2c,inliers2_opt(:,1:2),inliers1_opt(:,1:2),'montage');
end

% Show final Image
stat.inliners = size(inliers,2);
stat.ir = stat.inliners/stat.matches;
stat.ar = average_residual;

T = maketform('projective',H');
[~,x_img,y_img] = imtransform(im2c,T,'XYScale',1); 

x_out = [min(1,x_img(1)) max(size(im1c,2),x_img(2))];
y_out = [min(1,y_img(1)) max(size(im1c,1),y_img(2))];

img1_trans = imtransform(im1c,maketform('affine',eye(3)),'XData',x_out,'YData',y_out,'XYScale',1);
img2_trans = imtransform(im2c,T,'XData',x_out,'YData',y_out,'XYScale',1);

ZeroM = zeros(1, 3);

x = size(img1_trans,1);
y = size(img1_trans,2);

im = zeros(x, y, 3);

for i=1:size(img1_trans,1)
    for j=1:size(img1_trans,2)
        v1 = reshape(img1_trans(i,j,1:3), 1, 3);
        v2 = reshape(img2_trans(i,j,1:3), 1, 3);
        bool1 = sum(v1==ZeroM) == 0 && sum(v2==ZeroM) == 3;
        bool2 = sum(v1==ZeroM) == 3 && sum(v2==ZeroM) == 0;
        if bool1 == 0 && bool2 == 0
            im(i,j,:) = (img1_trans(i,j,:)+img2_trans(i,j,:))/2;    
        else
            im(i,j,:) = bool1 * img1_trans(i,j,:) + bool2 * img2_trans(i,j,:);
        end
    end
end
end