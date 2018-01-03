%Author: Björn Zehetbauer
%
%Description:
%'sum2' retruns an array of added up element-values from the specified
%dimension.
%
%Parameter:
%mat ..... The matrix which shoud be projected.
%dim ..... 1: Sum over all rows
%          2: Sum over all columns
%          else: returns the input matrix
%
%Return:
%Array of sums.

function ret = sum2(mat, dim)

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
            if dim == 1
                count(x) = count(x) + mat(y, x);
            elseif dim == 2
                count(x) = count(x) + mat(x, y);
            end
        end
    end
    ret = count;
end

