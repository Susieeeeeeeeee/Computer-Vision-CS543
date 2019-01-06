input = imread('CSL.jpg');


%  vp_z = getVanishingPoint_shell(input);
%  vp_x = getVanishingPoint_shell(input);
%  vp_y = getVanishingPoint_shell(input);


% vertical vanishing point as the Y-direction
% right-most vanishing point as the X-direction
% the left-most vanishing point as the Z-direction.
vp_z = [-215 204 1]
vp_x = [1287 214 1]
vp_y = [506 6496 1]

% display the vanishing points on the original image
figure();
imagesc(input);
hold on;
plot(vp_x(1), vp_x(2), 'r*');
plot(vp_y(1), vp_y(2), 'r*');
plot(vp_z(1), vp_z(2), 'r*');
axis image;

% line passing through two points: l = x1 * x2
horizon_line = cross(vp_z', vp_x');
horizon = real(horizon_line);

% normalize the parameters so that: a^2 + b^2 = 1
length = sqrt(horizon(1)^2 + horizon(2)^2);
horizon = horizon / length

% calibration from vanishing points
% find principal point
syms f px py;
K = [f, 0, px; 0, f, py; 0, 0, 1];
eqn = [vp_x; vp_y; vp_x] * transpose(inv(K)) * inv(K) * transpose([vp_y; vp_z; vp_z]);
eqn = diag(eqn) == 0;
solx = solve(eqn, f, px, py); 

f = double(solx.f(2))
p_x = double(solx.px(1))
p_y = double(solx.py(1))

K = [f, 0, p_x; 0, f, p_y; 0, 0, 1]

% find rotation matrix 
r_x = inv(K) * vp_x';
r_y = inv(K) * vp_y';
r_z = inv(K) * vp_z';

% normalization 
r_x = r_x / sqrt(sumsqr(r_x));
r_y = r_y / sqrt(sumsqr(r_y));
r_z = r_z / sqrt(sumsqr(r_z));

R = [r_x r_y r_z]

%measure height
person_f = [628 513 1]; % person head position
person_h = [628 467 1]; % person feet position
H = 66; % 5.5feet = 66inch
% H = 72; % 6feet = 72inch

object_positions = [599 317 1 599 50 1; % CSL position
                   601 474 1 601 187 1; % the spike position
                   997 475 1 997 363 1]; % right most lamp position
               
               
% object_positions_extra = [320 420 1 320 374 1; % left most person
%                           453 564 1 453 515 1; % person in the middle
%                           471 580 1 471 519 1; % right most person
%                           310 304 1 310 228 1; % tree
%                           795 177 1 795 156 1]% window
                          
    

height = [];
for i = 1 : 3
%     bottom = object_positions_extra(i, 1:3);
%     top = object_positions_extra(i, 4:6);
    bottom = object_positions(i, 1:3);
    top = object_positions(i, 4:6);
    
    line1 = real(cross(person_f', bottom'));
    v = real(cross(line1, horizon));
    v = v / v(3);

    line2 = real(cross(v', person_h'));
    vertical_line = real(cross(top', bottom'));
    t = real(cross(line2', vertical_line'));
    t = t / t(3);
    
    %draw pictures
    figure();
    imagesc(input);
    hold on;
    plot([vp_z(1) vp_x(1)], [vp_z(2) vp_x(2)]); % horizion
    plot([v(1) person_f(1)], [v(2) person_f(2)], 'r'); 
    plot([person_h(1) person_f(1)], [person_h(2) person_f(2)], 'r');
    plot([v(1) person_h(1)], [v(2) person_h(2)], 'r');
    plot([v(1) t(1)], [v(2) t(2)], 'g');
    plot([bottom(1) t(1)], [bottom(2) t(2)], 'g');
    plot([bottom(1) v(1)], [bottom(2) v(2)], 'g');
    plot([bottom(1) top(1)], [bottom(2) top(2)], 'y');
    axis equal;
    axis image;
    
    % calculate height
    r_b = sqrt(sumsqr(top - bottom));
    vz_t = sqrt(sumsqr(vp_z - t));
    t_b = sqrt(sumsqr(t - bottom));
    vz_r = sqrt(sumsqr(vp_z - top));
    height = [height;H* r_b * vz_t/ (t_b * vz_r)]
end