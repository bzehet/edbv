function [res] = calculate(formula)
%evaluates a given formula
%Author: Pascal Kawasser 
%formula without '=' sign
%res the calculated result
%res = calculate('7+4')

res = eval(formula);
end
