function[result]=Cleaning(input)
sizeOf = size(input);
import java.util.LinkedList
q = LinkedList();
%erste Spalte/letzte Spalte
for i=2:sizeOf(1,1)-1
    input(i,2)=0;
        q.add([i, 2]);
    input(i,sizeOf(1,2)-1)=0;
        q.add([i, sizeOf(1,2)-1]);
end
%erste Zeile/letzte Zeile
for i = 2: sizeOf(1,2)-1
    input(2,i)=0;
        q.add([2,i]);
    input(sizeOf(1,1)-1,i)=0;
        q.add([sizeOf(1,1)-1,i]);
end
while (size(q)~=0)
    item = q.remove();
    for y=-1:1
        for z=-1:1
            if (input(item(1,1)+y,item(2,1)+z)==1)
                input(item(1,1)+y,item(2,1)+z)=0;
                q.add([item(1,1)+y,item(2,1)+z]);
            end
        end
    end
end
result = input;
imshow(result);
end