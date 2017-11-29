%
%Connected Component Labeling
%
function [result] = labeling(input)
%input background must be black
%CONNECTED COMPONENT LABELING
[labels, num] = bwlabel(input,8);
%CONNECTED COMPONENT LABELING /END

check = zeros(num,size(input,2));
for i=1:size(input,1)
    for j=1:size(input,2)
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
               break;
        end
    end
end

for i=1:k-1
    labels(labels==max(toMerge(i,1),toMerge(i,2))) = min(toMerge(i,1),toMerge(i,2));
end


result=zeros(size(input,1),size(input,2),num);
for i=1:num
    logic(:,:)=(labels(:,:)==i);
    result(:,:,i)=logic;
end
end


