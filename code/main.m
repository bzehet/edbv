image = imread('bild1.JPG');
% b_image = imcomplement(im2bw(image,0.2));
b_image = 1-im2bw(image,0.2);
imshow(b_image)

b_image_maj = bwmorph(b_image,'majority',Inf);
% figure
% imshow(b_image_maj)

b_image_thin = bwmorph(b_image_maj,'thin',Inf);
figure
imshow(b_image_thin)

%verticalProfile = sum(b_image_thin, 2);
horizontalProfile = sum(b_image_thin, 1);

figure
plot(1:size(b_image_thin,2), horizontalProfile);

% figure
% plot(verticalProfile, 1:size(b_image_thin,1));