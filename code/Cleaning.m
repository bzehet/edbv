%
%cleaning
%
%Method gets an input and colours every pixel on the edge with the colour of
%the background
%returns picture the size of input
function[result]=cleaning(input)
%picture gets four additional rows for processing the picture.
input = changeSize(input);
q = zeros(2,0);
for i=3:size(input, 1)-2
    %first column/last column of initial picture (third of enlarged image)
    if (input(i,3)==0)
        input(i,3)=1;
        q(:,size(q,2)+1) = [i,3];
    end
    if (input(i,size(input,2)-2)==0)
       input(i,size(input,2)-2)=1;
       q(:,size(q,2)+1) = [i,size(input,2)-2];
    end 
    %first row/last row of initial picture (third of enlarged image)
     if (input(3,i)==0)
        input(3,i) = 1; 
        q(:,size(q,2)+1) = [3,i];
    end
    if (input(size(input,1)-2,i)==0)
        input(size(input,1)-2,i)=1;
        q(:,size(q,2)+1)=[size(input,1)-2,i];
    end
end
%while queue is not empty, the neighbours of at least one pixel have to be
%checked
while (size(q,2)~=0)
    [q, item] = pullItem(q);
    for y=-2:2
        for z=-2:2
            %if neighbour is white, pixel is added to queue.
            if (input(item(1,1)+y,item(1,2)+z)==0)
                input(item(1,1)+y,item(1,2)+z)=1;
                q(:,size(q,2)+1)=[item(1,1)+y, item(1,2)+z];
            end
        end
    end
end
%result is processed picture without additional rows.
result = input(3:end-2,3:end-2);
end

%removes first item in queue and returns it and new queue
function[result, item] = pullItem(queue)
item = [queue(1,1), queue(2,1)];
result(:,1:size(queue,2)-1) = queue(:,2:end);
end

function [image] = changeSize(input)
image = ones(size(input,1)+4, size(input,2)+4);
image(3:size(image,1)-2,3:size(image,2)-2) = input(:,:);
end

