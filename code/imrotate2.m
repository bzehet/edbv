function ret = imrotate2(image, degree)
%IMROTATE2 Summary of this function goes here
%   Detailed explanation goes here
    
    image_size = size(image);
    
    center = [round(image_size(1)/2), round(image_size(2)/2)];

    tl = rotatePixel(1, center(1), 1, center(2), degree);
    tr = rotatePixel(1, center(1), image_size(2), center(2), degree);
    bl = rotatePixel(image_size(1), center(1), 1, center(2), degree);
    br = rotatePixel(image_size(1), center(1), image_size(2), center(2), degree);
    
    offset = [min([tl(1), tr(1), bl(1), br(1)]) - 1, min([tl(2), tr(2), bl(2), br(2)]) - 1];
    new_size = [max([tl(1), tr(1), bl(1), br(1)]) - offset(1), max([tl(2), tr(2), bl(2), br(2)]) - offset(2)];
    
    image_rot = false(new_size(1),new_size(2));
    
    for row = 1:image_size(1)
        for col = 1:image_size(2)
            pixel = rotatePixel(row, center(1), col, center(2), degree);
            image_rot(pixel(1) - offset(1), pixel(2) - offset(2)) = image(row,col);
        end
    end
    
    ret = image_rot;  
end

function ret = rotatePixel(x1, x0, y1, y0, degree)
    ret = [round(cosd(degree) * (x1 - x0) - sind(degree) * (y1 - y0) + x0), ...
           round(sind(degree) * (x1 - x0) + cosd(degree) * (y1 - y0) + x0)];
end

