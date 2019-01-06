function [X,Y] = circle_positions(x_coord, y_coord, rad)
%% x_coord, y_coord are column vectors of circle centers in x and y coordinates
%% rad: column vector of radii of circles. 

theta = 0:0.1:(2*pi+0.1);
x_coord_circle = repmat(x_coord, 1, size(theta,2));
y_coord_circle = repmat(y_coord, 1, size(theta,2));
radius = repmat(rad, 1, size(theta,2));
X = x_coord_circle + cos(theta).*radius;
Y = y_coord_circle + sin(theta).*radius;


