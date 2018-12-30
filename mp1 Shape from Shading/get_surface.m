function  height_map = get_surface(surface_normals, image_size, method)
% surface_normals: 3 x num_pixels array of unit surface normals
% image_size: [h, w] of output height map/image
% height_map: height map of object
 
    
%% <<< fill in your code below >>>
 
h = image_size(:,1);
w = image_size(:,2);

height_map = zeros(h, w);
output = zeros(h,w);
 
g_y = surface_normals(:, :, 1);
g_x = surface_normals(:, :, 2);
g_z = surface_normals(:, :, 3);
 
g_y = g_y ./ g_z;
g_x = g_x ./ g_z;
 
    switch method
        case 'column'
          output(1,2:w) = cumsum(g_y(1,2:w),2);
          output(2:h,:) = g_x(2:h,:);
          height_map = cumsum(output);
       
        case 'row' 
          output(2:h,1) = cumsum(g_x(2:h,1));
          output(:,2:w) = g_y(:,2:w);
          height_map = cumsum(output,2);
             
        case 'average'
          col_height_map = get_surface(surface_normals, image_size, 'column');
          row_height_map = get_surface(surface_normals, image_size, 'row');
 
          height_map = bsxfun(@plus, col_height_map, row_height_map);
          height_map = height_map / 2;
 
        case 'random'
          height_map = average_of_random(15, image_size, g_x, g_y); 
          
        case 'extra'
          row = cumsum(g_y,2);
          column = cumsum(g_x);  
          height_map(2:h,1) = column(2:h,1);
          height_map(1,2:w) = row(1,2:w);
          for i = 2:h
              for j = 1:w
                  heightValue = 0;
                  path_count = 0;
                  for p = 1:i-1
                      if( j-p >= 1 )
                          heightValue = heightValue+column(1+p)+row(1+p,j-p)+column(i,j-p)-column(1+p,j-p)+row(i,j)-row(i,j-p);
                          path_count= path_count+1;
                      end
                  end
                  height_map(i,j) = heightValue/path_count;
              end
          end  
    end
 
end
 
% calculate the average height_map out of n trials
function  height_map = average_of_random(n, image_size, g_x, g_y)
    h = image_size(:,1);
    w = image_size(:,2);
    height_map = zeros(h, w);
    random_height_map = zeros(h, w);
    for  i = 1:n
        
        %random_height_map(1, 2:w) = cunsum(g_x(1,2:w),2);
        firstrow = [0 cumsum(g_y(1, 2:w),2)];
        firstcol = [0; cumsum(g_x(2:h, 1))];
        
        for  x = 1:h
        	 for  y = 1:w
            	  random_height_map(x,y) = single_pixel(x, y, g_x, g_y, firstrow, firstcol);
             end
        end
        height_map = height_map + random_height_map;
    end
    height_map = height_map / n;
end
 
% calculate single pixel point height value
function  single_height = single_pixel(x, y, g_x, g_y, firstrow, firstcol)

    if x == 1 && y == 1
        single_height = 0;
    elseif x == 1 && y > 1
        single_height = firstrow(1,y);
    elseif x > 1 && y == 1
        single_height = firstcol(x,1);
    else
        if rand >= 0.5
            single_height = g_x(x, y) + single_pixel(x-1, y, g_x, g_y, firstrow, firstcol);
        else
            single_height = g_y(x, y) + single_pixel(x, y-1, g_x, g_y, firstrow, firstcol);
        end
    end
end
