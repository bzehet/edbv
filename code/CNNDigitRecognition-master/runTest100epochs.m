
load mnist_uint8;
train_x = double(reshape(train_x',28,28,60000))/255;
test_x = double(reshape(test_x',28,28,10000))/255;
train_y = double(train_y');
test_y = double(test_y');

colormap gray;
imagesc(train_x(:, :, 105)');
axis square;

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
};

% Reset the seed generator. This will make your results reproducible.
rand('state', 0)
opts.alpha = 1;
opts.batchsize = 50;
opts.numepochs = 100;

cnn = cnnsetup(cnn, train_x, train_y);

fprintf('Training the CNN...\n');
startTime = tic();
cnn = cnntrain(cnn, train_x, train_y, opts);

fprintf('...Done. Training took %.2f seconds\n', toc(startTime));
% Test the CNN on the test set
fprintf('Evaluating test set...\n');

% Evaluate the trained CNN over the test samples.
[er, bad] = cnntest(cnn, test_x, test_y);

% Calculate the number of correctly classified examples.
numRight = size(test_y, 2) - numel(bad);

fprintf('Accuracy: %.2f%%\n', numRight / size(test_y, 2) * 100); 

% Plot mean squared error over the course of the training.
figure(1); 
plot(cnn.rL);
title('Mean Squared Error');
xlabel('Training Batch');
ylabel('Mean Squared Error');

% Verify the accuracy is at least 88%.
assert(er < 0.12, 'Too big error');
