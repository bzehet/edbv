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
formula= '7+4';

result = calculate(formula);
fprintf('Formel: %s\n', formula);
fprintf('Ergebnis: %d\n', result);
sol = solution(imageNumber(1)+1);
fprintf('Lösung: %d\n', sol);
if(result == sol)
    fprintf('Das Ergebnis ist korrekt!\n\n');
else
    disp('Das Ergebnis ist nicht korrekt!\n\n');
end


