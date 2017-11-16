%
%Connected Component Labeling
%
function [result] = labeling(input)
b_image=1-input;

%CLEANING
b_image = changeSize(b_image);
b_image = cleaning(b_image);
%CLEANING /END
%CONNECTED COMPONENT LABELING
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

toMerge=zeros(num,2);
k = 1;
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
               toMerge(k,1)=i;
               toMerge(k,2)=j;
               k=k+1;
               newNum= newNum-1;
               break;
        end
    end
end

for i=1:k-1
    labels(labels==max(toMerge(i,1),toMerge(i,2))) = min(toMerge(i,1),toMerge(i,2));
end


result=zeros(sizeOf(1,1),sizeOf(1,2),num-1);
for i=1:newNum
    helper = zeros(sizeOf(1,1),sizeOf(1,2));
    logic(:,:)=(labels(:,:)==i);
    helper(logic==1)=i;
    result(:,:,i)=helper;
end
end

function [image] = changeSize(input)
sizeOfInp = size(input);
image = zeros(sizeOfInp(1,1)+4, sizeOfInp(1,2)+4);
sizeOfIm = size(image);
for i = 3:sizeOfIm(1,1)-2
    for j = 3:sizeOfIm(1,2)-2
        image(i,j)=input(i-2,j-2);
    end
end
end
