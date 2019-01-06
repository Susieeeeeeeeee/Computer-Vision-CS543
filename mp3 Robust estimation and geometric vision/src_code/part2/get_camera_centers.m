% get camera center
function c_center = get_camera_centers(p)
[~,~,V] = svd(p,0);
c = V(:,end);
c_center = c./c(4);
