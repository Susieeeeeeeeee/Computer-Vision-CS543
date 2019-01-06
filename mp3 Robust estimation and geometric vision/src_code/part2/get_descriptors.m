% Compute d*d descriptors in im1 and im2 and return coordinates of the matches
% t: threhold of finding the matches
% harris_t: Harris threshold
% d_size: descriptors size 

function [D1,D2] = get_descriptors(im1,im2,harris_t,d_size)

% detect corners
[~, r1, c1] = harris(im1,3,harris_t,3,0);
[~, r2, c2] = harris(im2,3,harris_t,3,0);

s1 = size(r1, 1);
s2 = size(r2, 1);

% form index
d_size = floor(d_size/2);

l11 = r1-d_size;
l21 = r1+d_size;
l31 = c1-d_size;
l41 = c1+d_size;

l12 = r2-d_size;
l22 = r2+d_size;
l32 = c2-d_size;
l42 = c2+d_size;

% find putative matches with Normalized Correlation
X = zeros(s1, s2);
for i=1:s1
    temp1 = im1(l11(i):l21(i),l31(i):l41(i));
    descriptor1 = temp1(:);
    for j=1:s2
        temp2 = im2(l12(j):l22(j),l32(j):l42(j));
        descriptor2 = temp2(:);
        u_mean = diag(mean(descriptor1));
        v_mean = diag(mean(descriptor2));
        sqrt_1 = sqrt(sum((descriptor1-u_mean).^2));
        sqrt_2 = sqrt(sum((descriptor2-v_mean).^2));
        X(i,j) = sum((descriptor1-u_mean).*(descriptor2-v_mean))/(sqrt_1 * sqrt_2);
    end
end

% generate coordinates of matched pixels
[d1,d2] = find(X > 0.7);
len = size(d1, 1);
D1 = [c1(d1)';r1(d1)';ones(1, len)];
D2 = [c2(d2)';r2(d2)';ones(1, len)];

end
