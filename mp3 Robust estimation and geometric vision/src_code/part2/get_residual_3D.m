% calculate s between the observed 2D points and the projected 3D points in the two images
function r = get_residual_3D(x,P,X,I)
% x = P * X 
x_new = (P * X);

for i = 1 : 3
    x_new(i,:) = x_new(i,:)./x_new(3,:);
end
r = sum(mean(sum((x - x_new).^2)));

figure, imshow(I)
hold on
plot(x(1,:),x(2,:),'b.','MarkerSize',10);
plot(x_new(1,:),x_new(2,:),'r.','MarkerSize',10);
end

