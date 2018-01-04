% Formelerkennung
% Author: Pascal Kawasser
%
% Bernhard Martin Aschl
% Pascal Kawasser
% Oskar Perl
% Viktoria Pundy
% Björn Zehetbauer
%
% Technische Universität Wien
%

function main()

%load gui for user input
[imageName, imagePath, dataset, inputFormula] = gui;

%start stopwatch
tic;

%load dataset and path for digit recognition
addpath('CNNDigitRecognition-master\');
load('CNNDigitRecognition-master/hundredEpochs.mat');

%load solutions for testimages
solutionFilename = 'testset/image_numbers.xlsx';

%load solutions if the provided dataset is used
if(dataset)
[num, solution_Formula, raw] = xlsread(solutionFilename, 'B3:C102'); %#ok<ASGLU>
imageNumber = str2num(strtok(imageName, '.')); %#ok<ST2NM>
    if(isempty(imageNumber))
       error('Falls ein eigener Datensatz verwendet wird darf die Checkbox "Datensatz" nicht markiert werden');
    end
end

%load input
inputImage = imread(strcat(imagePath, imageName));

%Threshold nach Otsu
imageOtsu = otsu(inputImage);
imageCleaning = cleaning(imageOtsu);

%Geometrische Transformation
imageTransformation = imalign(1- imageCleaning, 5, 0.1);
imageFC = fragmentCleaner(imageTransformation);

%Connected Component Labeling
[imageLabeling, boolRot] = labeling(imageFC);
if (~boolRot)
    imageFC=imrotate(imageFC,180);
    [imageLabeling, ~] = labeling(imageFC);
end

%labels image visually
imageShowLabeling = imresize(labelImage(imageFC, imageLabeling),3);

sizeOf = size(imageLabeling);
if(sizeOf > 30)
    error('Too many components');
end  

%Symbol Recognition
symbolsFormula = symbolRecognition(imageLabeling(:,:,1:end-1));
    

%Digit Recognition
output_formula = calculateFormula(cnn, imageLabeling(:,:,1:end-1), symbolsFormula);


%print the result, disabled for test purpose
try
    output_result = calculate(output_formula);
catch
    output_result = 'Ergebnis konnte nicht berechnet werden';
end
if(dataset)
    output_formula_solution = solution_Formula(imageNumber+1,1);
    output_result_solution = calculate(output_formula_solution{1});
else
    if(isempty(inputFormula))
        %can't check result
        output_formula_solution = 'Es wurde keine Formel eingegeben';
        output_result_solution = '?';
    else
        if(inputFormula(end) == '=')
           inputFormula = inputFormula(1:end-1); 
        end
        output_formula_solution = inputFormula;
        output_result_solution = calculate(output_formula_solution);
    end
end

%stop stopwatch
finish = toc;
time = strcat(num2str(finish), ' sec');

guiOutput(inputImage, imageOtsu, imageCleaning, imageFC, imageShowLabeling, output_formula, output_result, output_formula_solution, output_result_solution, time);
end



