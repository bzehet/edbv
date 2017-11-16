%Formelerkennung
%
%Bernhard Martin Aschl
%Pascal Kawasser
%Oskar Perl
%Viktoria Pundy
%Bj�rn Zehetbauer
%
%Technische Universit�t Wien
%

%load dataset and path for digit recognition
addpath('CNNDigitRecognition-master\');
load('CNNDigitRecognition-master/hundredEpochs.mat');

%load solutions for testimages
filename = 'testset/image_numbers.xlsx';
solution = xlsread(filename,'C3:C102');

imageNumber = 48;

image = imread(strcat('testset/', num2str(imageNumber), '.jpg'));


%Threshold nach Otsu
imageBin = otsu(image);
imshow(imageBin);
imageCl = cleaning(imageBin);
imshow(imageCL);
%Projektionen

%Geometrische Transformation
imageRot = imalign(1- imageCl, 5);
imshow(imageRot);

%Connected Component Labeling
    %returns a matrix with one character per (3rd) dimension
    imageLet = labeling(1 - imageRot);
    
    %imageFin = zeichenErkennung(imageLet);
    

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
fprintf('L�sung: %d\n', sol);
if(result == sol)
    fprintf('Das Ergebnis ist korrekt!\n\n');
else
    fprintf('Das Ergebnis ist nicht korrekt!\n\n');
end



%Methodenpipeline:
% - Otsu
% - Cleaning
% - Rotation (Projektion)
% - Labeling
% - Rechenzeichenerkennung (Projektion)
% - Digit Recognition
% - calculation
