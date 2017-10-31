image = imread('80.JPG');
b_image = 1-im2bw(image,0.4);

b_image_maj = bwmorph(b_image,'majority',Inf);

image_org = imrotate(b_image_maj,100);

image_rot = imalign(image_org,5);

figure
imshow(image_org)
figure
imshow(image_rot)