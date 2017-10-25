function [res] = calculate(formula)
%evaluates a given formula
%formula without '=' sign
%res the calculated result
%res = calculate('7+4')

res = eval(formula);
end