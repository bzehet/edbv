%
%Connected Component Labeling
%
function [result] = labeling(input)
%input: binary file

input=1-input();

%CLEANING
input = changeSize(input);
input = cleaning(input);
%CLEANING /END

%CONNECTED COMPONENT LABELING
sizeOf=size(input);
[labels, num] = bwlabel(b_image,8);
%CONNECTED COMPONENT LABELING /END

for i = 1:sizeOf(1,1)
    for j=1:sizeOf(1,2)
        if (labels(i,j)==num)
            labels(i,j)=num-1;
        end
    end
end

result=zeros(sizeOf(1,1),sizeOf(1,2),num-1);
for i=1:num-1
    helper = zeros(sizeOf(1,1),sizeOf(1,2));
    logic(:,:)=(labels(:,:)==i);
    helper(logic==1)=i;
    result(:,:,i)=helper;
end

%DEBUG: showing single signs:
%for z=1:num-1
%    forimshow = result(:,:,z);
%    imshow(forimshow);
%end
end

function [image] = changeSize(input)
sizeOfInp = size(input);
image = zeros(sizeOfInp(1,1)+2, sizeOfInp(1,2)+2);
sizeOfIm = size(image);
for i = 2:sizeOfIm(1,1)-1
    for j = 2:sizeOfIm(1,2)-1
        image(i,j)=input(i-1,j-1);
    end
end
end
