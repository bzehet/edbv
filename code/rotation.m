image = imread('76.JPG');
b_image = 1- im2bw(image,0.4);

%image_small = imresize(b_image, 0.06);

b_image_maj = bwmorph(b_image,'majority',Inf);

% image_small = imresize(b_image, 0.1);

% image_org = imrotate(b_image,80);

image_rot = imalign(b_image, -5);

%sum([1 1 1; 0 0 0],2)

% figure
% imshow(image_small)

%image_rot = imrotate(b_image, 90);


figure
imshow(image_rot)