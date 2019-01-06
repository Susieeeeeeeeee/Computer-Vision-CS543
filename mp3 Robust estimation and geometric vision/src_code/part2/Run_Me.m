% Comuper Vision Assignment 3 Part2                                    
function Run_Me

% user input
fprintf('1-unnormalized\n2-normalized\n');
nor = input('Please select normalized or not: ');
fprintf('1-GroundTruth\n2-RANSAC\n3-Triangulation\n');
method = input('Please choose the method above: ');

% optimized settings
harris_t = 0.01; % Harris Threshold
d_size = 40; % Descriptor Size (d x d)
ransac_t = 4 ; % RANSAC Threshold

% load the image pair and matching points file
img_names = {'house', 'library'};
for idx=1:2
    img1 = sprintf('./assignment3_part2_data/%s1.JPG', img_names{idx});
    img2 = sprintf('./assignment3_part2_data/%s2.JPG', img_names{idx});
    match = sprintf('./assignment3_part2_data/%s_matches.txt', img_names{idx});
    I1 = imread(img1);
    I2 = imread(img2);
    matches = load(match);

    N = size(matches,1);
    x1 = [matches(:,1:2)';ones(1,N)]; % matches(i,1:2) is a point in the first image
    x2 = [matches(:,3:4)';ones(1,N)]; % matches(i,3:4) is a corresponding point in the second image

% first, fit fundamental matrix to the matches
    if (method == 1)
        F_matrix = fit_fundamental(x1,x2,nor); 
        Residual = squared_d(F_matrix, matches);
        fprintf('The Residual for %s is %f\n',img_names{idx}, Residual);
        display_img(F_matrix, matches, N, I2);
    end

    if (method == 2)
        im1 = rgb2gray(im2double(I1));
        im2 = rgb2gray(im2double(I2));

        [D1,D2] = get_descriptors(im1,im2,harris_t,d_size);
        Num_of_Matches = size(D1,2);


        % perform RANSAC
        [F_matrix, inliers, Average_Residual] = ransac(D1,D2,ransac_t);
        Num_of_Inliers = size(inliers,1);
        fprintf('The Number of Matches for %s is %d\n',img_names{idx}, Num_of_Matches);
        fprintf('The Number of Inliers for %s is %d\n',img_names{idx}, Num_of_Inliers);
        Inlier_ratio = Num_of_Inliers/Num_of_Matches;
        fprintf('The Inlier Ratio for %s is %f\n',img_names{idx}, Inlier_ratio);   
        N = size(inliers,1);
        display_img(F_matrix, inliers, N, I2);
        fprintf('The Average Residual for %s is %f\n',img_names{idx}, Average_Residual);   
        
    end

    if (method == 3)
        camera1 = sprintf('./assignment3_part2_data/%s1_camera.txt', img_names{idx});
        camera2 = sprintf('./assignment3_part2_data/%s2_camera.txt', img_names{idx});
        p1 = load(camera1);
        p2 = load(camera2);

        % camera Centers
        c1 = get_camera_centers(p1);
        c2 = get_camera_centers(p2);

        % triangulation: linear approach
        X = zeros(4,N);
        for i = 1 : N
        cross1 = [];
        cross2 = [];
        for j=1:4
            cross1 = [cross1; cross([matches(i,1) matches(i,2) 1],p1(:,j))];
            cross2 = [cross2; cross([matches(i,3) matches(i,4) 1],p2(:,j))];
        end
        A = [cross1'; cross2'];
        
        [~,~,V] = svd(A,0);
        X(:,i) = V(:,end);
        X(:,i) = X(:,i)./X(4,i);
        end

        % calculate residual
        res1 = get_residual_3D(x1,p1,X,I1);
        res2 = get_residual_3D(x2,p2,X,I2);
        Total_Residual = res1 + res2;
        fprintf('The Total Residual for %s is %f\n',img_names{idx}, Total_Residual);


        % 3D reconstruction
        if (idx == 1)
            X(2,:) = -1 * X(2,:);
            c1(2) = -1 * c1(2);
            c2(2) = -1 * c2(2);
        end

        figure, plot3(X(1,:),X(2,:),X(3,:),'b.','MarkerSize',5);
        hold on
        plot3(c1(1),c1(2),c1(3),'r.','MarkerSize',15);
        plot3(c2(1),c2(2),c2(3),'g.','MarkerSize',15);
        grid on
        legend('Pixel','Camera 1','Camera 2')
        axis equal
    end
end