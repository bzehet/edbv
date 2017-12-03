%
%Connected Component Labeling
%
%Function gets a binary picture where the background is black and the signs
%are white. Returns an array of pictures where each single letter is stored in one
%picture. 
function [result, bool] = labeling(input)

%CONNECTED COMPONENT LABELING
%[labels, num] = bwlabel(input,8);
[labels, num] = C_C_L(input);
%CONNECTED COMPONENT LABELING /END

%%Method to combine the lines of equals sign:
%saving column numbers of each label (stored per column)
check = zeros(num,size(input,2));
for j=1:size(input,2)
    for k=1:num
        if(any(labels(:,j)==k))
           check(k,j)=1;
        end
    end
end

%%Merging all labels which have the same column numbers to more than 60%:
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
        %calculate range of first label
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
bool = degreeCheck(result, num);
end

function [finImage, num]=C_C_L(image)
image = changeSize(image);
checked = zeros(size(image,1),size(image,2));
label = 0;
labeledImage = zeros(size(image,1),size(image,2));
for j=2:size(image,2)-1
   for i=2:size(image,1)-1
       if (checked(i,j)==0 && image(i,j)==1)
          label = label + 1;
          [labeledImage, checked]=recursiveLabel(image, labeledImage, checked, label, i, j);
       elseif (checked(i,j)==0 && image(i,j)==0)
          checked(i,j)=1;     
       end   
   end
end
finImage=labeledImage(2:size(image,1)-1,2:size(image,2)-1);
num = label;
end

function [im, ch]=recursiveLabel(image, lImage, checked, label, r, c)
checked(r,c)=1;
lImage(r,c)=label;
for k = -1:1
    for l = -1:1
        if (checked(k+r,l+c)==0 && image(k+r,l+c)==1)
            [lImage, checked]=recursiveLabel(image, lImage,checked,label,r+k,l+c);
        end
        if (checked(k+r,l+c)==0 && image(k+r,l+c)==0)
            checked(k+r,l+c)=1;
        end
    end
end
im = lImage;
ch = checked;
end

function [image] = changeSize(input)
image = zeros(size(input,1)+2, size(input,2)+2);
for i=1:size(input,1)
    for j=1:size(input,2)
        image(i+1,j+1)=input(i,j);
    end
end
end

function [r] = degreeCheck(input, num)
r = true;
for i = 1:num
    if (all(1-(input(:,:,i))))
        if (i<(num/2))
            r = false;
        end
        break;
    end
end
end


