function [outputDigit, percentage]=DirectRun(net,inputImage)
	C=preprocess(inputImage);
	y=runSingleImage(net, C);
	[~, h]=max(y(:, 1));
    outputDigit=h-1;
var1=y(:, 1);
percentage=var1/sum(var1)*100;
percentage=percentage(h);
figure(1);
title(['Expected output: ' num2str(outputDigit)]);
end