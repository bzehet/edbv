%Formelerkennung
%
%Bernhard Martin Aschl
%Pascal Kawasser
%Oskar Perl
%Viktoria Pundy
%Björn Zehetbauer
%
%Technische Universität Wien
%

%load dataset and path for digit recognition
addpath('CNNDigitRecognition-master\');
load('CNNDigitRecognition-master/hundredEpochs.mat');

%load solutions for testimages
filename = 'testset/image_numbers.xlsx';
solution = xlsread(filename,'C3:C102');

imageNumber = 35;

image = imread(strcat('testset/', num2str(imageNumber), '.jpg'));


%Threshold nach Otsu
imageBin = otsu(image);
imshow(imageBin);
%Projektionen

%Geometrische Transformation
imageRot = imalign(1- imageBin, -5);
imshow(imageRot);

%Connected Component Labeling 

%Thinning
%currently not required

%Digit Recognition
%load test values for digit recognition:
%symbols and imageNumber should be calculated by previous methods
symbols = ['(', ' ', '+', ' ', ')', '*', ' '];
imageNumer = {imread('testset/21a.jpg'), imread('testset/21b.jpg'), imread('testset/21c.jpg')};
formula = calculateFormula(cnn, imageNumer, symbols);

%the formula will be calculated by previous methods
%formula= '(4+2)*3';

%print the result
result = calculate(formula);
fprintf('Formel: %s\n', formula);
fprintf('Ergebnis: %d\n', result);
sol = solution(imageNumber + 1);
fprintf('Lösung: %d\n', sol);
if(result == sol)
    fprintf('Das Ergebnis ist korrekt!\n\n');
else
    fprintf('Das Ergebnis ist nicht korrekt!\n\n');
end


