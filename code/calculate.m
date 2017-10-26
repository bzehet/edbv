function [res] = calculate(formula)
%evaluates a given formula
%formula without '=' sign
%res the calculated result
%res = calculate('7+4')
res = zeros(1, size(formula,2));
for i=1:size(formula,2)
    res(i) = eval(formula{i});
end
end
