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

% Display the Background Approximation as a Surface

figure
surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
ax = gca;
ax.YDir = 'reverse';

I3 = I2 - background; % hintergrund vom grauwertbild abziehen
%imshow(I3)

I4 = imadjust(I3); % kontrast erhöhen
%imshow(I4);

level = graythresh(I4); %otsu matlab standard funktion


im = im2bw(I4,level); % in binärbild umwandeln mit vorher ausgerechneten threshhold

im = bwareaopen(im, 50); % rauschen entfernen
im_r = imcomplement(im);

img = im_r ;


end 