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

function main()
dataset = 2;
dataset = gui;

disp(dataset);
%load dataset and path for digit recognition
addpath('CNNDigitRecognition-master\');
load('CNNDigitRecognition-master/hundredEpochs.mat');

%load solutions for testimages
%[imageName, imagePath] = uigetfile({'*.jpg';'*.jpeg';'*.png'}, 'Select the picture','testset/');
filename = 'testset/image_numbers.xlsx';

if(dataset)
solution_Result = xlsread(filename,'C3:C102');
[num, solution_Formula, raw] = xlsread(filename, 'B3:B102');
imageNumber = strtok(imageName, '.');
end

image = imread(strcat(imagePath, imageName));

%Threshold nach Otsu
imageBin = otsu(image);
imshow(imageBin);
imageCl = cleaning(imageBin);
imshow(imageCl);

%Geometrische Transformation
imageRot = imalign(1- imageCl, 5);
imshow(imageRot);
imageFC = fragmentCleaner(imageRot);
imshow(imageFC);

%Connected Component Labeling
[imageLet, boolRot] = labeling(imageFC);
if (~boolRot)
    [imageLet, ~] = labeling(imrotate(imageFC,180));
end

sizeOf = size(imageLet);
if(sizeOf > 30)
    error('Too many components');
end
    
for i=1:sizeOf(1,3)
  imshow(imageLet(:,:,i));
end
    

%Symbol Recognition
symbols = symbolRecognition(imageLet(:,:,1:end-1));
    

%Digit Recognition
[formula, digits] = calculateFormula(cnn, imageLet(:,:,1:end-1), symbols);

%only for digit testing:
fprintf('Formel Vorlage: %s\n', solution_Formula{imageNumber+1});
fprintf('Formel Berechn: %s\n\n', formula);
fprintf('Struktur Berec: %s\n', symbols(1:end-1));
fprintf('Zahlen Berechn: ');
disp(digits);
%print the result, disabled for test purpose
% result = calculate(formula);
% fprintf('Formel: %s\n', formula);
% fprintf('Ergebnis: %d\n', result);
% sol = solution(imageNumber + 1);
% fprintf('Lösung: %d\n', sol);
% if(result == sol)
%     fprintf('Das Ergebnis ist korrekt!\n\n');
% else
%     fprintf('Das Ergebnis ist nicht korrekt!\n\n');
% end

end

function imageButton_callback(src, event)
    [imageName, imagePath] = uigetfile({'*.jpg';'*.jpeg';'*.png'}, 'Select the picture','testset/');
end


