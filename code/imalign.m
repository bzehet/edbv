%Author: Björn Zehetbauer
%
%Description:
%'imalign' rotates the input-image, which shows a one-line-string and aligns
%this string horizontally. The rotaion occurs in steps with the specified
%degrees till it reaches 180°. In each step we calculate the maximum of the 
%vertical-projection. For runtime-efficiency the input-image can be scaled.
%Finally we return the rotated input-image (original size) with the highest
%projection-sum and the consequentally best angle for alignment.
%(The aligned string could be upsidedown.)
%
%Parameter:
%image  ..... The input-image which should be aligned.
%degree ..... The degrees we rotate the image with in every step.
%             The smaller the number, the longer then runtime. 
%             (Steps: 180/degree)
%             'degree' could also be negative (direction of rotation).
%Return:
%The aligned image
%(Could be upsidedown; Could be bigger then the original)

function ret = imalign(image, degree, scale)
    image_align = image;
    if scale ~= 1.0
        image_align = imresize(image, scale);
    end
    verticalProfile = sum2(image_align, 2);
    counter = max(verticalProfile);
    max_counter = counter;
    degree_counter = 0;
    max_degree = 0;
    while abs(degree_counter) <= 180
        degree_counter = degree_counter + degree;
        temp_image = imrotate2(image_align, degree_counter);
        verticalProfile = sum2(temp_image, 2);
        counter = max(verticalProfile);
        
        if counter > max_counter
            max_degree = degree_counter;
            max_counter = counter;
        end
    end
    ret =  imrotate2(image, max_degree);
end