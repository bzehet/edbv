%Author: Oskar Perl
%
%Description:
%'otsu' converts the input image into a binaray image using otsus method
%to determin the optimal threschold
%returns a binary image
%
function[img] = otsu(image)

%% pre-processing   
I1 = image;

I2  = imcomplement(rgb2gray(I1)); % invert image and convert to grayscale

background = imopen(I2,strel('disk',15));%approximate background

I3 = I2 - background; % subtract background from image

I4 = imadjust(I3); % increasing contrast

%% OTSU thresholding

histValues = imhist(I4,256)/ numel(I4); %normalized histogram

mK = 0;
w0 = 0;
max = 0.0;
mT = dot( (0:255) , histValues ); %total mean level

for i = 1:256
    
    %probabilities of class occurrence
    w0 = w0 + histValues(i);    
    w1 = 1 - w0;                
    
    % prevent division by zero
    if (w0 == 0 || w1 == 0) 
        continue;
    end
    
    mK = mK + ( (i-1) * histValues(i) );
    
    %class mean levels
    m0 = (mK / w0);
    m1 = (mT - mK) / w1;
    
    %between class variance
    between = w0 * w1 * (m0 - m1) ^ 2;
    
    %checking if current between class variance is a maximum
    if ( between >= max ) 
        level = i; %Setting the threshold level to the current value of i
        max = between;
        
    end
end
%% post-processing   

im = im2bw(I4,level/256); % convert to binary image using the threschold

im = bwareaopen(im, 50); % remove noise

im_r = imcomplement(im);

img = im_r ;


end 