function[res] = calculateFormula(net, images, symbols)
%generates a formula for given numbers (images) and symbols
%images = Array of images, only numbers allowed, size > 1
%symbols = Array of symbols, size > 2
%Example: (4+2)*3
%images = [4,2,3] (stored as images)
%symbols = ['(', '', '+', '', ')', '*', '']

outputDigit = zeros(1, size(images, 2));
res = '';
for i = 1 : size(images, 2)
    C=preprocess(images{i});
    y=runSingleImage(net, C);
	[~, h]=max(y(:, 1));
    outputDigit(i)=h-1;
end
j = 1;
for i = 1 : size(symbols, 2)
   if(symbols(i) == ' ')
       res = strcat(res, num2str(outputDigit(j)));
       j = j+1;
   else
       res = strcat(res,symbols(i));
   end
end   
end