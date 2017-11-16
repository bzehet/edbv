function[result]=cleaning(input)
input = 1-input;
input = changeSize(input);
sizeOf = size(input);
q = zeros(2,0);
%erste Spalte/letzte Spalte
for i=3:sizeOf(1,1)-2
    input(i,3)=0;
    q=expandQueue(q, i,3);
    input(i,sizeOf(1,2)-2)=0;
    q=expandQueue(q, i,sizeOf(1,2)-2);  
end
%erste Zeile/letzte Zeile
for i = 3: sizeOf(1,2)-2
    input(3,i)=0;
    q=expandQueue(q,3,i);    
    input(sizeOf(1,1)-2,i)=0;
    q=expandQueue(q,sizeOf(1,1)-3,i);
end
sizeOfQueue = size(q);
while (sizeOfQueue(1,2)~=0)
    [q, item]=getItem(q);
    for y=-2:2
        for z=-2:2
            if (input(item(1,1)+y,item(1,2)+z)==1)
                input(item(1,1)+y,item(1,2)+z)=0;
                q=expandQueue(q, item(1,1)+y, item(1,2)+z);
            end
        end
    end
    sizeOfQueue = size(q);
end
result = 1-input;
end

function[result]=expandQueue(queue, r,c)
sizeOf = size(queue);
result = zeros(2,sizeOf(1,2)+1);
for i =1:sizeOf(1,2)
    result(1,i)=queue(1,i);
    result(2,i)=queue(2,i);
end
result(1,sizeOf(1,2)+1)=r;
result(2,sizeOf(1,2)+1)=c;
end

function[result, item]=getItem(queue)
sizeOf = size(queue);
item = [queue(1,1), queue(2,1)];
result = zeros(2, sizeOf(1,2)-1);
    for i=1:sizeOf(1,2)-1
        result(1,i)=queue(1,i+1);
        result(2,i)=queue(2,i+1);
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

