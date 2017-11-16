function ret = imalign(image, degree)
    verticalProfile = sum(image, 2);
    counter = max(verticalProfile);
    max_counter = counter;
    max_image = image;
    degree_counter = 0;
    while degree_counter <= 180
        degree_counter = degree_counter + degree;
        temp_image = imrotate(image,-degree_counter);
        verticalProfile = sum(temp_image, 2);
        counter = max(verticalProfile);
        
        if counter > max_counter
            max_image = temp_image;
            max_counter = counter;
        end
    end
    ret = max_image;
end