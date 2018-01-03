%Author: Björn Zehetbauer
%
%Description:
%'imrotate2' rotates the input-image with the specified angle. The origin
%is the center of the image. First we calculate the coordinates of the
%rotated corner-pixels. Consequentally we get an offset and the new
%image-size. Now each pixel-value will be set to its new position.
%Given that the rotation could return non-integer-coordinates the rotated
%image could have holes (unmapped pixels). To counteract on this problem
%the rotation function gives us the floor- as well as the ceil-value of the
%pixel-coordinate to set the new position. Finally we return the rotated
%image.
%
%Parameter:
%image  ..... The input-image which should be rotated.
%degree ..... The degrees we rotate the image with.
%
%Return:
%The rotated image

function ret = imrotate2(image, degree)
    
    image_size = size(image);
    
    center = [round(image_size(1)/2), round(image_size(2)/2)];

    tl = rotatePixel(1, center(1), 1, center(2), degree);
    tr = rotatePixel(1, center(1), image_size(2), center(2), degree);
    bl = rotatePixel(image_size(1), center(1), 1, center(2), degree);
    br = rotatePixel(image_size(1), center(1), image_size(2), center(2), degree);
    
    offset = [min([tl(1), tr(1), bl(1), br(1)]) - 1, min([tl(2), tr(2), bl(2), br(2)]) - 1];
    new_size = [max([tl(3), tr(3), bl(3), br(3)]) - offset(1), max([tl(4), tr(4), bl(4), br(4)]) - offset(2)];
    
    image_rot = zeros(new_size(1),new_size(2));
    
    for row = 1:image_size(1)
        for col = 1:image_size(2)
            pixel = rotatePixel(row, center(1), col, center(2), degree);
            image_rot(pixel(1) - offset(1), pixel(2) - offset(2)) = image(row,col);
            image_rot(pixel(3) - offset(1), pixel(4) - offset(2)) = image(row,col);
        end
    end
    
    ret = image_rot;  
end

%Author: Björn Zehetbauer
%
%Description:
%'rotatePixel' rotates a pixel-coordinate with the specified angle and
%origin. Given that the rotation could return non-integer-coordinates, this
%function returns an array of floor- and ceil-values of the 
%pixel-coordinate.
%
%Parameter:
%x1  ..... x-coordinate of the pixel.
%x0  ..... x-coordinate of the origin.
%y1  ..... y-coordinate of the pixel.
%y0  ..... y-coordinate of the origin.
%degree ..... The degrees we rotate the image with.
%
%Return:
%Array of floor- and ceil-values of the pixel-coordinate.

function ret = rotatePixel(x1, x0, y1, y0, degree)
    ret = [floor(cosd(degree) * (x1 - x0) - sind(degree) * (y1 - y0) + x0), ...
           floor(sind(degree) * (x1 - x0) + cosd(degree) * (y1 - y0) + x0), ...
           ceil(cosd(degree) * (x1 - x0) - sind(degree) * (y1 - y0) + x0), ...
           ceil(sind(degree) * (x1 - x0) + cosd(degree) * (y1 - y0) + x0)];
end

