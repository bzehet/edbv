%
%Treshold nach Otsu
%
function[img] = otsu(image)
    I0 = image;
    
    I1 = I0;
%imshow(I)

I2  = imcomplement(rgb2gray(I1)); % invertieren und in grauwerte umwandeln
%imshow(I2)

background = imopen(I2,strel('disk',15));%approzimiert den hintergrung 

I3 = I2 - background; % hintergrund vom grauwertbild abziehen
%imshow(I3)

I4 = imadjust(I3); % kontrast erh�hen
%imshow(I4);

level = graythresh(I4); %otsu matlab standard funktion


im = im2bw(I4,level); % in bin�rbild umwandeln mit vorher ausgerechneten threshhold

im = bwareaopen(im, 50); % rauschen entfernen
im_r = imcomplement(im);

img = im_r ;


end 