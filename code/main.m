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

solution_Result = xlsread(filename,'C3:C102');
[num, solution_Formula, raw] = xlsread(filename, 'B3:B102');
imageNumber = 55;


image = imread(strcat('testset/', num2str(imageNumber), '.jpg'));


%Threshold nach Otsu
imageBin = otsu(image);
imshow(imageBin);
imageCl = cleaning(imageBin);
imshow(imageCl);
%Projektionen

%Geometrische Transformation
imageRot = imalign(1- imageCl, 5);
imshow(imageRot);

%Connected Component Labeling
    %returns a matrix with one character per (3rd) dimension
    [imageLet, bool] = labeling(imageRot);
    if (~bool)
        [imageLet, ~]=labeling(imrotate(imageRot,180));
    end
    sizeOf = size(imageLet);
    
    if(sizeOf > 20)
        error('Too many components');
    end
    
    for i=1:sizeOf(1,3)
        imshow(imageLet(:,:,i));
    end
    
    
symbols = symbolRecognition(imageLet(:,:,1:end-1));
    

%Thinning
%currently not required

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
% fprintf('L�sung: %d\n', sol);
% if(result == sol)
%     fprintf('Das Ergebnis ist korrekt!\n\n');
% else
%     fprintf('Das Ergebnis ist nicht korrekt!\n\n');
% end



%Methodenpipeline:
% - Otsu
% - Cleaning
% - Rotation (Projektion)
% - Labeling
% - Rechenzeichenerkennung (Projektion)
% - Digit Recognition
% - calculation
