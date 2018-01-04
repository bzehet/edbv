%Author: Bernhard Martin Aschl
%This function extracts the portion of an input picture where content is present.
%The input doesn't necessarily has to be black and white.
%Returns -1, if input is empty.
function[symbolPic]=getContentOfPic(input)
    %Find indices of all non-zero pixels
    indSubPic=find(input);
    
    %check for input
    if(~size(indSubPic)) 
        symbolPic=-1
        return;
    end
    
    widPic=size(input,2);
    heiPic=size(input,1);
    %first pixel
    xmin=floor(min(indSubPic)/heiPic)+1;
    ymin=min(mod(indSubPic,heiPic));
    %last pixel
    xmax=floor(max(indSubPic)/heiPic)+1;
    ymax=max(mod(indSubPic,heiPic));
    
    %Make rectangle corresponding to content
    subPicRect=[xmin,ymin,xmax-xmin,ymax-ymin];
    
    %return correctly cropped image
    symbolPic=imcrop(input,subPicRect);
end