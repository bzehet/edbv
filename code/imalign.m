function ret = imalign(image, degree)
    image_small = imresize(image, 0.1);
    verticalProfile = sum2(image_small, 2);
    counter = max(verticalProfile);
    max_counter = counter;
    degree_counter = 0;
    max_degree = 0;
    while abs(degree_counter) <= 180
        degree_counter = degree_counter + degree;
        temp_image = imrotate2(image_small, degree_counter);
        verticalProfile = sum2(temp_image, 2);
        counter = max(verticalProfile);
        
        if counter > max_counter
            max_degree = degree_counter;
            max_counter = counter;
        end
    end
    ret =  imrotate2(image, max_degree);
end