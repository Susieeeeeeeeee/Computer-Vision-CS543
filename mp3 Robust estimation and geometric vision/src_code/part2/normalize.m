function [x_normalized,N_matrix] = normalize(x)

c_matrix = mean(x,2);
new_coor = (x - c_matrix);
new_coor = new_coor(1:2,:);

dist = mean(sqrt(sum(new_coor.^2)));
scale = sqrt(2)/dist;
 
N_matrix = [scale*[eye(2) -c_matrix(1:2)];zeros(1,2) 1];
x_normalized = N_matrix * x;

end