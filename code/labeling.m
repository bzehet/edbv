%
%Connected Component Labeling
%
%Function gets a binary picture where the background is black and the signs
%are white. Returns an array of pictures where each single letter is stored in one
%picture. 
function [result, boolRotate] = labeling(input)

%CONNECTED COMPONENT LABELING
[labels, num] = C_C_L(input);
%CONNECTED COMPONENT LABELING /END

%Method to combine the lines of equals sign:
%saving column numbers of each label (stored per column)
check = zeros(num,size(input,2));
for j=1:size(input,2)
    for k=1:num
        if(any(labels(:,j)==k))
           check(k,j)=1;
        end
    end
end

%Merging all labels which have the same column numbers to more than 60%:
toMerge=zeros(num,2);
k = 0;
%compare every label
for i=1:num 
    %calculate range of first label
    [~,c1]=find(labels==i); 
    span1=max(c1)-min(c1)+1;
    if (span1<5)
        continue;
    end
    for j=(i+1):num
        %calculate range of second label
        [~,c2]=find(labels==j);
        span2=max(c2)-min(c2)+1;
        if (span2<5)
            continue;
        end
        %calculate amount of identical column numbers for both labels
        s = sum(and(check(i,:),check(j,:)));
        if ((s/span1)>=0.60 && (s/span2)>=0.60) %store labels as "to merge" if amount is more than 60% of both ranges
            k=k+1;   
            toMerge(k,1:2)=[i,j];
            break;
        end
    end
end

%Merging labels by writing minimum of both labels where maximum of both exists 
for i=1:k
    labels(labels==max(toMerge(i,1),toMerge(i,2))) = min(toMerge(i,1),toMerge(i,2));
end

%Creating picture-array with every sign having an unique index
result=zeros(size(input,1),size(input,2),num);
for i=1:num
    result(:,:,i)=(labels(:,:)==i);
end
%checking if image needs to be rotated by 180 degrees
boolRotate = rotationCheck(result, num);
end

%Starts labeling process, finds not yet checked pixels and calls
%recursiveFindNeighbours
function [result, num]=C_C_L(image)
image = -image;
%image is expanded by four rows/columns for labeling process
image = expandImage(image);
label = 0;
for j=2:size(image,2)-1
    for i=2:size(image,1)-1
        %checks if pixel is white (foreground) and has not been checked
        %yet
        if (image(i,j)==-1)
            label = label + 1;
            image = recursiveFindNeighbours(image, label, i, j);
        end
    end
end
%result is image without additional rows/columns
result=image(2:end-1,2:end-1);
num = label;
end

%Labels given pixel and checks if neighbours of it are part of component
function[result]=recursiveFindNeighbours(image, label, r, c)
image(r,c)=label;
for x=-1:1
    for y =-1:1
        %if neighbour pixel is also white and has not been checked, method
        %is called with new pixel
        if (image(r+x,c+y)==-1)
            image = recursiveFindNeighbours(image, label, r+x,c+y);
        end
    end
end
result = image;
end

%Expands image by a one pixel black frame. Necessary for recursiveFindNeighbours
%method
function [image] = expandImage(input)
image = zeros(size(input,1)+2, size(input,2)+2);
image(2:end-1,2:end-1)=input(:,:);
end

%Checks if image needs to be rotated by 180°
function [r] = rotationCheck(input, num)
r = true;
for i = 1:num %every picture in the array is checked
    if (all(1-(input(:,:,i)))) 
        %if equalssign is on the left half of formula, image must be
        %rotated
        if (i<(num/2))
            r = false;
        end
        break;
    end
end
end
