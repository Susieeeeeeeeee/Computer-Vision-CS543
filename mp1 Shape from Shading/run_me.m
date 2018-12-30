%% Spring 2014 CS 543 Assignment 1
%% Arun Mallya and Svetlana Lazebnik

% subfolder names
subfolders = {'yaleB02','yaleB05','yaleB07','yaleB01'};
% path to the folder and subfolder
root_path = 'croppedyale/';

for x = 1:4
    
subject_name = subfolders(x);
subject_name = char(subject_name);

integration_method = 'random'; % 'column', 'row', 'average', 'random','extra'
save_flag = 1; % whether to save output images

%% load images
full_path = sprintf('%s%s/', root_path, subject_name);
[ambient_image, imarray, light_dirs] = LoadFaceImages(full_path, subject_name, 64);
image_size = size(ambient_image);


%% preprocess the data: 
%% subtract ambient_image from each image in imarray
imarray = bsxfun(@minus, imarray, ambient_image);

%% make sure no pixel is less than zero
imarray=(imarray>=0) .* imarray;

%% rescale values in imarray to be between 0 and 1

imarray = (imarray - min(imarray(:))) / (max(imarray(:))-min(imarray(:)));

%% <<< fill in your preprocessing code here >>>
%% get albedo and surface normals (you need to fill in photometric_stereo)
[albedo_image, surface_normals] = photometric_stereo(imarray, light_dirs);

%% reconstruct height map (you need to fill in get_surface for different integration methods)
tic
height_map = get_surface(surface_normals, image_size, integration_method);
disp("run time = "+num2str(toc));

%% display albedo and surface
display_output(albedo_image, height_map);

%% plot surface normal
plot_surface_normals(surface_normals);

%% save output (optional) -- note that negative values in the normal images will not save correctly!
if save_flag
    imwrite(albedo_image, sprintf('%s_albedo.jpg', subject_name), 'jpg');
    imwrite(surface_normals, sprintf('%s_normals_color.jpg', subject_name), 'jpg');
    imwrite(surface_normals(:,:,1), sprintf('%s_normals_x.jpg', subject_name), 'jpg');
    imwrite(surface_normals(:,:,2), sprintf('%s_normals_y.jpg', subject_name), 'jpg');
    imwrite(surface_normals(:,:,3), sprintf('%s_normals_z.jpg', subject_name), 'jpg');    
end
end

