%Formelerkennung
%
%Bernhard Martin Aschl
%Pascal Kawasser
%Oskar Perl
%Viktoria Pundy
%Björn Zehetbauer
%
%TU Wien
%

filename = 'testset/image_numbers.xlsx';
solution = xlsread(filename,'C3:C102');

imageNumber = 20;
path = strcat('testset/', num2str(imageNumber), '.jpg');
image = imread(path);

%Threshold nach Otsu
imageBin = otsu(image);

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
sol = solution(imageNumber+1);
fprintf('Lösung: %d\n', sol);
if(result == sol)
    fprintf('Das Ergebnis ist korrekt!\n\n');
else
    disp('Das Ergebnis ist nicht korrekt!\n\n');
end


