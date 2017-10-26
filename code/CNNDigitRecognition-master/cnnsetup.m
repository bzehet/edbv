function net = cnnsetup(net, x, y)

    inputmaps = 1;
    
    % This variable will hold the size of the map for the current layer.
    % For the input layer (layer 1), this is just the size of the training
    % images (e.g., [28, 28] for MNIST).
    mapsize = size(squeeze(x(:, :, 1)));

    % For each defined layer 'l'
    for l = 1 : numel(net.layers)
        
        % If this is a subsampling layer...
        if strcmp(net.layers{l}.type, 's')
            % Calculate the size of the output map for this layer.
            mapsize = mapsize / net.layers{l}.scale;
            
            % Assert that the resulting output map size is an integer.
            assert(all(floor(mapsize) == mapsize), ['Layer ' num2str(l) ' size must be integer. Actual: ' num2str(mapsize)]);
            
            % Initialize the bias term to 0 for all output maps. The bias
            % term is unused for pooling layers.
            for j = 1 : inputmaps
                net.layers{l}.b{j} = 0;
            end
        end
        
        % If this is a convolution layer...
        if strcmp(net.layers{l}.type, 'c')
            
            % Calculate the size of the output map for this layer.
            % Because the filters can't go past the edge of the image, the
            % output map is slightly smaller than the input map.
            mapsize = mapsize - net.layers{l}.kernelsize + 1;
            
            % Calculate the "fan out". This number is just used in
            % initializing the kernel weights for this layer.
            fan_out = net.layers{l}.outputmaps * net.layers{l}.kernelsize ^ 2;
            
            % Initialize all of the kernel weights for this layer.
            % For each outputmap (that is, for each "filter" / "neuron" / 
            % "feature" in this layer)...
            for j = 1 : net.layers{l}.outputmaps  
                
                % Calculate the "fan in". This corresponds to the number of
                % inputs to a neuron in this layer. 
                fan_in = inputmaps * net.layers{l}.kernelsize ^ 2;
                
                % For each input map...
                for i = 1 : inputmaps
                    % Randomly initialize the 2D filter.
                    % We initialize a separate filter for each input map,
                    % but when we do the feedforward pass we will sum the 
                    % convolutions for each input map so it's as if there
                    % is just one 3D filter.
                    % TODO - I am not familiar with the math used to
                    % initialze the weights.
                    net.layers{l}.k{i}{j} = (rand(net.layers{l}.kernelsize) - 0.5) * 2 * sqrt(6 / (fan_in + fan_out));
                end
                
                % Initialize the bias term for this neuron to 0.
                net.layers{l}.b{j} = 0;
            end
            
            % The number of input maps for the next layer is equal to the
            % number of output maps in the current layer.
            inputmaps = net.layers{l}.outputmaps;
        end
    end
    % 'onum' is the number of labels, that's why it is calculated using size(y, 1). If you have 20 labels so the output of the network will be 20 neurons.
    % 'fvnum' is the number of output neurons at the last layer, the layer just before the output layer.
    % 'ffb' is the biases of the output neurons.
    % 'ffW' is the weights between the last layer and the output neurons. Note that the last layer is fully connected to the output layer, that's why the size of the weights is (onum * fvnum)
    fvnum = prod(mapsize) * inputmaps;
    onum = size(y, 1);

    % Initialize the weights for the output (classifier) neurons.
    net.ffb = zeros(onum, 1);
    net.ffW = (rand(onum, fvnum) - 0.5) * 2 * sqrt(6 / (onum + fvnum));
end
