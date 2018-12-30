function [albedo_image, surface_normals] = photometric_stereo(imarray, light_dirs)
% imarray: h x w x Nimages array of Nimages no. of images
% light_dirs: Nimages x 3 array of light source directions
% albedo_image: h x w image
% surface_normals: h x w x 3 array of unit surface normals

%% <<< fill in your code below >>>

[h, w, num_imgs] = size(imarray);

% g: num_imgs * (h * w)
g = transpose(reshape(imarray, [(h*w), num_imgs]));

% g: 3 * (h * w)  %light_dir: num_imgs * 3
g = light_dirs \ g;

% g: 3 * h * w
g = reshape(g, 3, h, w);

% g: h * w * 3
g = permute(g, [2 3 1]);

gx = g(:, :, 1);
gy = g(:, :, 2);
gz = g(:, :, 3);

% albedo_image: h * w
albedo_image = sqrt(gx.^2 + gy.^2 + gz.^2);

%surface_normals: h * w * 3
surface_normals = bsxfun(@ldivide, albedo_image, g);

end

