image = imread('testset/66.JPG');

imageBin = otsu(image);
imageCl = cleaning(imageBin);
% figure
% imshow(imageCl);

%Geometrische Transformation
imageRot = imalign(1- imageCl, 5, 0.1);

%test = imresize(imageBin, 0.04);

a = sum([1 1 1; 0 0 0],1)
b = sum2([1 1 1; 0 0 0],1)

% a = sum(imageRot, 1)
% b = sum2(imageRot, 1)
% 
% for x = 1:size(imageRot, 2)
%    if a(x) ~= b(x)
%       rx = x
%       ra = a(x)
%       rb = b(x)
%       return
%    end
% end
%sum([1 1 1; 0 0 0],2)

% figure
% imshow(image_small)

%image_rot = imrotate(b_image, 90);

% figure
% imshow(imageRot)