%
%Connected Component Labeling
%
function [result] = labeling(input)
%input: binary file

%Delete Later:
    image = imread('60.JPG');
    b_image = 1-im2bw(image,0.6);
    imshow(b_image);
%end

%CLEANING
%input = cleaning(input)
b_image = changeSize(b_image);
b_image = Cleaning(b_image);
%CLEANING /END

%CONNECTED COMPONENT LABELING
%sizeOf=(size(input));
%[labels, num]=bwlabel(1-input,8);
%[labels, num]=lab(b_image); //1-?

sizeOf=size(b_image);
[labels, num] = bwlabel(b_image,8);
%CONNECTED COMPONENT LABELING /END

check = zeros(num,sizeOf(1,2));
for i=1:sizeOf(1,1)
    for j=1:sizeOf(1,2)
        for k=1:num
            if(labels(i,j)==k)
                check(k,j)=1;
                break;
            end
        end
    end
end

toMerge=zeros(1,2);
newNum=num;
for i=1:num
    [~,c1]=find(labels==i);
    span1=max(c1)-min(c1)+1;
    if (span1<5)
        continue;
    end
    for j=(i+1):num
        [~,c2]=find(labels==j);
        span2=max(c2)-min(c2)+1;
        if (span2<5)
            continue;
        end
        v = and(check(i,:),check(j,:));
        s = sum(v);
        if ((s/span1)>=0.60 && (s/span2)>=0.60)
               toMerge(1,1)=i;
               toMerge(1,2)=j;
               newNum= newNum-1;
               break;
        end
    end
end
labels(labels==max(toMerge(1,1),toMerge(1,2))) = min(toMerge(1,1),toMerge(1,2));

result=zeros(sizeOf(1,1),sizeOf(1,2),newNum);
for i=1:newNum
    helper = zeros(sizeOf(1,1),sizeOf(1,2));
    logic(:,:)=(labels(:,:)==i);
    helper(logic==1)=i;
    result(:,:,i)=helper;
end

%DEBUG: showing single signs:
for z=1:newNum
    forimshow = result(:,:,z);
    imshow(forimshow);
end
end

function [finImage, num]=C_C_L(image,n)
%image = changeSize(image);
sizeOf = size(image);
checked = zeros(sizeOf(1,1),sizeOf(1,2));
label = 0;
labeledImage = zeros(sizeOf(1,1),sizeOf(1,2));
for j=2:sizeOf(1,2)-1
   for i=2:sizeOf(1,1)-1
       if (checked(i,j)==0 && image(i,j)==1)
          label = label + 1;
          [labeledImage, checked]=recursiveLabel(image, labeledImage, checked,label, i, j);
       elseif (image(i,j)==0)
           checked(i,j)=1;
       end   
   end
end
%resize Image
finImage=labeledImage(2:sizeOf(1,1)-1,2:sizeOf(1,2)-1);
num = label;
end

function [im, ch]=recursiveLabel(image, lImage, checked, label, r, c)
checked(r,c)=1;
lImage(r,c)=label;
for k = -1:1
    for l = -1:1
        if (checked(k+r,l+c)==0 && image(k+r,l+c)==1)
           [lImage, checked] = recursiveLabel(image, lImage,checked,label,r+k,l+c);
        elseif (checked (k+r,l+c)==0 && image(k+r,l+c)==0)
            checked(k+r,l+c)=1;
        end
    end
end
im = lImage;
ch = checked;
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
imshow(image);
end
