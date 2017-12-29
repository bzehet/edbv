%Author: Viktoria Pundy
%gets a rotated binary picture as input, returns processed image
function [result]=fragmentCleaner(input)
rows = histogram(input);
bool = false;
index = 1;
maximum = 0;
indexMinimum = 0;
indexMaximum = 0;
summe = 0;
firstIndex = 0;
%calculates the biggest cluster of pixels
while (index<=size(input,1))
    %if white pixel exist in current row, amount of pixels is added up
    if (rows(index,1)~=0)
        %if bool is false, this row is the first row of a cluster of pixels
        if (bool == false)
            bool = true;
            firstIndex = index;
        end
       summe = summe + sum(rows(index,1));
    else
        bool = false;
        %if current sum is bigger than maximum, new biggest cluster has
        %been found.
        if (summe > maximum)
            maximum = summe;
            indexMinimum = firstIndex;
            indexMaximum = index-1;
        end
        summe = 0;
    end  
    index = index +1;
end
%each row, which is not part of the maximum cluster is coloured black.
for j=1:size(rows,1)
    if (j<indexMinimum || j>indexMaximum)
        input(j,:)=0;
    end
end
    result = input;
end

%gets a binary picture as input, returns a vector containing the relative
%amount of white pixels per row considering the whole input image.
function[rows]=histogram(input)
rows = zeros(size(input,1),1);
for i = 1:size(input,1)
    rows(i,1)=sum(input(i,:))/(sum(sum(input)));
end
end