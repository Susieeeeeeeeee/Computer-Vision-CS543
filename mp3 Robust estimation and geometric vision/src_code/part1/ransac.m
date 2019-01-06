% Perform Ransac on C1, C2
function [h, inliers, inliers1_opt, inliers2_opt, average_residual] = ransac(C1, C2, ransac_t)

C = [C1;C2];
n = size(C,2);% number of total matches
Max_inliners =  0; % initialize the number of inliners


for count = 0 : 1000 % perform 1000 iterations
    s = randperm(n,4);% randomly pick 4 sample matches
    x_1 = C(1,s);
    y_1 = C(2,s);
    x_2 = C(4,s);
    y_2 = C(5,s);
    
    % fitting a homography
    A = [];
    for i=1:4
        temp = [x_1(i) y_1(i) 1];
        A = [A;zeros(1,3) temp -y_2(i)*temp;
            temp zeros(1,3) -x_2(i)*temp];
    end
    
    [~,~,V] = svd(A,0);
    h = transpose(reshape(V(:,end),3,3));
        
    if (rank(h) < 3)
        continue;
    end
    
    % calculate squared distance between the point coordinates in one image and the transformed coordinates of the matching point in the other image
    C1_N = h \ C2;
    C2_N = h * C1;
    for i=1:3
        C1_N(i,:) = C1_N(i,:)./C1_N(3,:);
        C2_N(i,:) = C2_N(i,:)./C2_N(3,:);
    end

    d1 = sum((C2_N - C2).^2);
    % d2 = sum((C1_N - C1).^2);
    % squared_d = d1 + d2;
    squared_d = d1;
    
    inliers1 = []; % store coordinates of inliers of pic1
    inliers2 = []; % store coordinates of inliers of pic2
    
    % get inliers with threshold 15
    inliers = find(abs(squared_d) < ransac_t); 
    inliers_size = size(inliers , 2);
    ave_residual = mean(squared_d(inliers));
    
    
    for i=1 : inliers_size
        inliers1 = [inliers1; C1_N(1:2, inliers(i))'];
        inliers2 = [inliers2; C2_N(1:2, inliers(i))'];
    end
    
    % find optimal h and inliers
    num_inliners = length(inliers);
    if num_inliners > Max_inliners
        Max_inliners = num_inliners;
        bestinliers = inliers;
        optimal_h = h;
        % samp_matches = C(:,s);
        inliers1_temp = inliers1;
        inliers2_temp = inliers2;
        temp_ar = ave_residual;
    end    
end

average_residual = temp_ar;
h = optimal_h;
inliers = bestinliers;
inliers1_opt = inliers1_temp;
inliers2_opt = inliers2_temp;
end
