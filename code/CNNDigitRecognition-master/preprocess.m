function C=preprocess(inputImage)
	var1=imread(inputImage);
	var2=rgb2gray(var1);
	var3=imcrop(var2);
	B=imresize(var3, [28 28]);
	B=double(B)/255;
	B=double(ones(28, 28)-B);
	C=zeros(28, 28, 50);
	for j=1:50
		C(:, :, j)=B(:, :)';
	end
	TestImage(C);
	 function X = TestImage(X)
        colormap gray;
		imagesc(X(:, :, 46)');
		figure(1); 
		axis square;
    end
end