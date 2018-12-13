% Colorizing Prokudin-Gorskii images of the Russian Empire

function mp0_v4

tic;
fullim = imread('01657u.tif');

% convert image to double matrix 
fullim = im2double(fullim);

% compute the height of each channel
height = floor(size(fullim,1)/3);
width = floor(size(fullim,2));

%Crops 10% off the borders of the image
new_height = floor(height/1.11);
new_width = floor(width/1.11);

% separate 3 channels
B = fullim(1:height,:);
G = fullim(height+1:height*2,:);
R = fullim(height*2+1:height*3,:);

B = B(height-new_height:new_height, width-new_width:new_width);
G = G(height-new_height:new_height, width-new_width:new_width);
R = R(height-new_height:new_height, width-new_width:new_width);

% Align the Red and Blue images to the Green channel
% bound = [10,10];
displacement_R = offset2(R,G);
displacement_B = offset2(B,G);
newR = align(R,displacement_R);
newB = align(B,displacement_B);
disp(displacement_R);
disp(displacement_B);

% recombine
colorim = cat(3, newR, G, newB);

% Auto crop the ugly borders
cropped_colorim = autocrop(colorim);

% show result and save
imshow(cropped_colorim);
imwrite(cropped_colorim,'mp0-output.jpg');

disp("run time = "+num2str(toc));
end

%% align img1 to img2
function [output] = align(img1, disp)
output = circshift(img1, disp);
end


%% find the minimum offset through ssd
function [displacement1] = offset(img1, img2, bound)
min = inf; % first result must be less than infinity
for x = bound(1)-15:bound(1)+15
    for y = bound(2)-15:bound(2)+15 
        tmp = circshift(img1, [x y]);
        ssd = sum(sum((img2-tmp).^2));
        if ssd < min
            min = ssd;
            displacement1 = [x y];
        end
    end
end
end

%% Image pyramid simple
function [displacement2] = offset2(img1, img2) 
    if size(img1, 1) > 200 
        I1 = impyramid(img1, 'reduce'); 
        I2 = impyramid(img2, 'reduce'); 
        coarse_offset = offset2(I1, I2); 
        displacement2 = offset(img1, img2, coarse_offset*2); 
    else 
        displacement2 = offset(img1, img2, [0, 0]); 
    end 
end

%% Autoly crop the ugly broders of the output
function [cropped_img] = autocrop(colorim)

    threshold = 0.5;
   
    width = size(colorim,2);
    height = size(colorim,1);
    
    top = 1;
    bottom =height;
    left = 1;
    right = width;


    % Get edge images 
    B_edge = edge(colorim(:,:,3), 'canny');
    G_edge = edge(colorim(:,:,2), 'canny');
    R_edge = edge(colorim(:,:,1), 'canny');

    % Calculate the averages
    B_ave_column = mean(B_edge, 1);
    B_ave_row = mean(B_edge, 2);
 
    G_ave_column = mean(G_edge, 1);
    G_ave_row = mean(G_edge, 2);
 
    R_ave_column = mean(R_edge, 1);
    R_ave_row = mean(R_edge, 2);
    
    % find top
    for i=1:floor(height*0.1)
        if B_ave_row(i,:) > threshold
            top = i;
        elseif G_ave_row(i,:) > threshold
            top = i;
        elseif R_ave_row(i,:) > threshold
            top = i;
        end  
    end  
 
    % find bottom
    for i=height:-1:floor(height*0.9)
        if B_ave_row(i,:) > threshold
            bottom = i;
        elseif G_ave_row(i,:) > threshold
            bottom = i;
        elseif R_ave_row(i,:) > threshold
            bottom = i;
        end  
    end 
 
    % find left
    for i=1:floor(width*0.1)
        if B_ave_column(:,i) > threshold
            left = i;
        elseif G_ave_column(:,i) > threshold
            left = i;
        elseif R_ave_column(:,i) > threshold
            left = i;
        end    
    end
    
    % find right
    for i=width:-1:floor(width*0.9)
        if B_ave_column(:,i) > threshold
            right = i;
        elseif G_ave_column(:,i) > threshold
            right = i;
        elseif R_ave_column(:,i) > threshold
            right = i;
        end  
 
    end
 
    % find top
    for i=1:floor(height*0.1)
        if B_ave_row(i,:) > threshold
            top = i;
        elseif G_ave_row(i,:) > threshold
            top = i;
        elseif R_ave_row(i,:) > threshold
            top = i;
        end  
    end  
 
    % find bottom
    for i=height:-1:floor(height*0.9)
        if B_ave_row(i,:) > threshold
            bottom = i;
        elseif G_ave_row(i,:) > threshold
            bottom = i;
        elseif R_ave_row(i,:) > threshold
            bottom = i;
        end  
    end  
 
    cropped_img = colorim(top:bottom,left:right, :);
end
 




