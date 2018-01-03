image = imread('testset/80.JPG');

imageBin = otsu(image);
imageCl = cleaning(imageBin);
figure
imshow(imageCl);

%Geometrische Transformation
imageRot = imalign(1- imageCl, 5, 0.1);

%sum([1 1 1; 0 0 0],2)

% figure
% imshow(image_small)

%image_rot = imrotate(b_image, 90);

figure
imshow(imageRot)