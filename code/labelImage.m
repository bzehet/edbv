%Author: Viktoria Pundy
%returns a picture with every component being labeled visually.
function[output]=labelImage(input, labelmatrix)
index = 1;
position = zeros(size(labelmatrix,3)-1,2);
value = zeros(1,size(labelmatrix,3)-1);
%iterates over every letter in given labelmatrix
for i = 1:size(labelmatrix,3)-1
    [r,c]=find(labelmatrix(:,:,i)==1);
    if (isempty(r)||isempty(c))
        continue;
    end
    %sets position for number as median of all values in rows and columns
    y = median(r);
    x = median(c);
    position(index,:)=[x, y];
    value(1,index)=index;
    index = index+1;
end
output = insertText(input, position, value, 'Fontsize', 30);
end