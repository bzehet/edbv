function y = runSingleImage(net, x)
    net = cnnff(net, x);
	y=net.o;
end