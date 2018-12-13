% Colorizing Prokudin-Gorskii images of the Russian Empire


function mp0

tic;
fullim = imread('01112v.jpg');

% convert image to double matrix 
fullim = im2double(fullim);

% compute the height of each channel
height = floor(size(fullim,1)/3);

% separate 3 channels
B = fullim(1:height,:);
G = fullim(height+1:height*2,:);
R = fullim(height*2+1:height*3,:);

% Align the Red and Blue images to the Green channel
bound = [15,15];
displacement_R = offset(R,G,bound);
displacement_B = offset(B,G,bound);
newR = align(R,displacement_R);
newB = align(B,displacement_B);
disp(displacement_R);
disp(displacement_B);

% recombine
colorim = cat(3, newR, G, newB);

% show result and save
imshow(colorim);
imwrite(colorim,'mp0-output.jpg');

disp("run time = "+num2str(toc));
end

%% align img1 to img2
function [output] = align(img1, disp)
output = circshift(img1, disp);
end


%% find the minimum offset through ssd
function [displacement1] = offset(img1, img2, bound)
min = inf; % first result must be less than infinity
for x = -bound(1):bound(1)
    for y = -bound(2):bound(2) 
        tmp = circshift(img1, [x y]);
        ssd = sum(sum((img2-tmp).^2));
        if ssd < min
            min = ssd;
            displacement1 = [x y];
        end
    end
end
end




