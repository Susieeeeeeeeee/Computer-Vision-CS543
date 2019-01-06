% compute the mean squared distance in pixels between points in both images and the corresponding epipolar lines
function avg_residual = squared_d(F_matrix, matches)
    N = size(matches,1);
    L = (F_matrix * [matches(:,1:2) ones(N,1)]')'; 
    L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); 
    pt_line_dist = sum(L .* [matches(:,3:4) ones(N,1)],2);
    closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);
    
    for i = 1:N
        matches_r = matches(i,3:4);
        new_left = closest_pt(i,1:2);
        sqrt_distance(i) = dist2(new_left, matches_r);
    end

    avg_residual = 0;
    for i = 1: N
        avg_residual = sqrt_distance(i) + avg_residual;
    end
    avg_residual = avg_residual / N;
end     

    

