function C=preprocess(inputImage)
	%var1=imread(inputImage);
    var1=inputImage;
	%var3=rgb2gray(var1);
	%var3=imcrop(var2);
	%B=imresize(var3, [28 28]);
    B=imresize(var1, [28 28]);
	%B=double(B)/255;
	%B=double(ones(28, 28)-B);
    B(B<0)=1;
    B(B>0)=1;
%     X = B;
%     Y = zeros(1,size(X,1));
%     for i=1:size(X,2)
%         scatter(Y, X(:,i));
%         hold on;
%         Y = Y+1;
%     end
%     hold off;
	C=zeros(28, 28, 50);
	for j=1:50
		C(:, :, j)=B(:, :)';
    end
end