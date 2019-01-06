%% Create Laplacian filter
function [filter] = create_filter(sigma) 

%odd matrix size
filter = sigma^2*fspecial('log', 2*ceil(sigma*2.5)+1, sigma);

end
