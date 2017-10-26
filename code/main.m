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
load('hundredEpochs.mat');
[output percentage] = DirectRun(cnn, '27.jpg')
filename = 'testset/image_numbers.xlsx';
solution = xlsread(filename,'C3:C102');

imageNumber = [20 21 22];
imageSize = size(imageNumber,2);

paths = repmat({' '},1,imageSize);
images = repmat({' '},1,imageSize);

if(size(imageNumber,2) < 2)
    paths = strcat('testset/', num2str(imageNumber), '.jpg');
    images = {imread(paths)};
else
    for i=1:imageSize
    paths(i) = cellstr(strcat('testset/', num2str(imageNumber(i)), '.jpg'));
    images(i) = {imread(paths{i})};
    end
end

%Threshold nach Otsu
%imageBin = otsu(image);

%Projektionen

%Geometrische Transformation

%Connected Component Labeling 

%Thinning
%currently not required

%the formula will be calculated by previous methods
formulas= {'7+4' '(4+2)*3' '(80/2)-11'};

result = calculate(formulas);
for i=1:size(result,2)
fprintf('Formel: %s\n', formulas{i});
fprintf('Ergebnis: %d\n', result(i));
sol = solution(imageNumber(i)+1);
fprintf('Lösung: %d\n', sol);
if(result(i) == sol)
    fprintf('Das Ergebnis ist korrekt!\n\n');
else
    fprintf('Das Ergebnis ist nicht korrekt!\n\n');
end
end


