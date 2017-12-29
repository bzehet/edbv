function ret = sum2(mat, dim)
%SUM2 Summary of this function goes here
%   Detailed explanation goes here
    if dim == 1
        ar_size = size(mat, 2);
        mat_size = size(mat,1);
    elseif dim == 2
        ar_size = size(mat, 1);
        mat_size = size(mat,2);
    else 
        ret = mat;
        return
    end
    count = zeros(1,ar_size);
    for x = 1:ar_size
        for y = 1:mat_size
            count(x) = count(x) + mat(x, y);
        end
    end
    ret = count;
end

