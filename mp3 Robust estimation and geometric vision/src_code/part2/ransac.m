function [F,inlier_pairs, Average_Residual] = ransac(D1, D2, ransac_t)
% settings
matches_new = [D1(1:2,:)' D2(1:2,:)'];
D = [D1;D2];
n = size(D,2);
avg_residual = 0;
Max_inliers = 0;

% perform ransac
for count = 0:1500
    s = randperm(n,8);
    x1 = D(1:3,s);
    x2 = D(4:6,s);
    temp_F = fit_fundamental(x1,x2,2);
    
    % count inliers
    avg_residual = 0;

    inliers1 = []; % store coordinates of inliers of pic1
    inliers2 = []; % store coordinates of inliers of pic2
    
    N = size(matches_new,1);
    L = (temp_F * [matches_new(:,1:2) ones(N,1)]')'; 
    L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); 
    pt_line_dist = sum(L .* [matches_new(:,3:4) ones(N,1)],2);
    closest_pt = matches_new(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
    
    for i = 1:size(matches_new, 1)  
        matches_r = matches_new(i,3:4);
        new_left = closest_pt(i,1:2);
        sqrt_distance(i) = dist2(new_left, matches_r);
    end

    % find inliers coordinates
    inliers = find(sqrt_distance < ransac_t^2);  
    num_inliers = length(inliers);
    
    for i = 1: num_inliers
        avg_residual = sqrt_distance(inliers(i)) + avg_residual;
    end
    avg_residual = avg_residual / num_inliers;

    for i=1 : num_inliers
        inliers1 = [inliers1; D1(1:2, inliers(i))'];
        inliers2 = [inliers2; D2(1:2, inliers(i))'];
    end
    
    inlier_pairs = [inliers1, inliers2];
      
    if num_inliers > Max_inliers
        Max_inliers = num_inliers;
        bestinliers = inlier_pairs;
        optimal_f = temp_F;
        temp_residual = avg_residual;
    end    
end
inlier_pairs = bestinliers;
Average_Residual = temp_residual;
F = optimal_f;
end 



