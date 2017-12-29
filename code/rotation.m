image = imread('80.JPG');
b_image = 1- im2bw(image,0.4);

%image_small = imresize(b_image, 0.06);

b_image_maj = bwmorph(b_image,'majority',Inf);

image_org = imrotate(b_image_maj,80);

image_rot = imalign(image_org, -5);

%sum([1 1 1; 0 0 0],2)

figure
imshow(image_org)

%image_rot = imrotate2(b_image_maj, 90);


figure
imshow(image_rot)