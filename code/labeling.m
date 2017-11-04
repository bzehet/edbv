%
%Connected Component Labeling
%
function [result] = labeling(input)
%input: binary file

%Delete Later:
    %image = imread('76.JPG');
    %b_image = 1-im2bw(image,0.65);
    %imshow(b_image)
    
    %sizeOf=size(b_image);
    %[labels, num] = bwlabel(b_image,8);
%end

sizeOf=(size(input));

%CONNECTED COMPONENT LABELING
[labels, num]=bwlabel(input,8);
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
%for i=1:newNum
 %   forimshow = result(:,:,i);
  %  imshow(forimshow);
end