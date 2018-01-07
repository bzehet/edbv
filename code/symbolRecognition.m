%Author: Bernhard Martin Aschl

%gets a full-size Picture-Array and returns an array of chars
%it iterates over the pictures and crops them. Then it checks which symbol
%(+,-,*,/,(,)) it is. At the end it returns a char-array in the form of
%{'-','?','+','?'}
%note: numerical values (standard deviations and so on) in this code are empirical.

function [result]=symbolRecognition(inputPics)
    amount=size(inputPics,3);
    result=zeros(1,amount);
    %as there may only be a ) if there was a (, the unclosed brackets are counted
    bracketOpenCounter=0;
    
    for i=1:amount
        pic=inputPics(:,:,i);
        %crops image to relevant part
        pic=getContentOfPic(pic);
        
        %if the image contains too little information it is suspected, that
        %it was only noise. Then it checks for each individual symbol in
        %order according to difficulty of detection.
        if(sum(size(pic))<10)
            result(i)=' ';
        else
            if(isAMinus(pic))
                result(i)='-';
            else
                if(isADivide(pic))
                    result(i)='/';
                else
                    if(isAPlus(pic))
                        result(i)='+';
                    else
                        if(isAMult(pic))
                            result(i)='*';
                        else
                            if(isABracket(pic))
                                result(i)='(';
                                bracketOpenCounter=bracketOpenCounter+1;
                            else
                                %a ) flipped around is a (, so only one
                                %method necessary. Also, if there hasn't
                                %been a ( it can't be a )
                                if(bracketOpenCounter>0 && isABracket(fliplr(pic)))
                                    result(i)=')';
                                    bracketOpenCounter=bracketOpenCounter-1;
                                else
                                    result(i)='?';
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    result=char(result);
end

function[isPlus]=isAPlus(input)
    %The input is a plus if the maximum value of the projection is in the
    %middle and the corners are empty. Furhtermore, to check for 4s, the
    %left upper rectangle has to be empty. 
    isPlus=1;
    
    tall=size(input,1);
    long=size(input,2);
    
    pixInp=pixelizePic(input, 9,9);
    %corners must not be filled and it mustn't be a 4
    if(pixInp(9,1)||pixInp(1,9)||pixInp(9,9)||sum(sum(pixInp(1:3,1:3))))
        isPlus=0;
    end
    
    %if the input has too much content, it's not a plus. It's rather a *
    percentageBlack=sum(sum(input))/max(max(input))/(tall*long);
    if(percentageBlack >0.5)
        isPlus=0;
    else
        %check both projections
        for c=0:1
            checkSide = sum2(input, 2);
            csLength=size(checkSide,1);
                
            [maximum, index]=max(checkSide);
            %if index of max is in the middle
            pIndex=index/csLength;
            if(pIndex>0.75 || pIndex<0.25)
                isPlus=0;
            end
            
            input=rot90(input);
        end
    end
end
function[isMinus]=isAMinus(input)
    %it's a minus if it's long (longer than tall) and mostly black.
    %Furthermore it should be very even.
    %a minus often has single pixels at the edges messing with the
    %recognition. They can be cut off.
    
    %As pens often get thinner when you stop writing, a little bit has to
    %be cropped to check for standard deviation. Also noise might be a 
    %problem, so the upper and lower part a cropped a little.
    %There might be a problem if the minus is too thin, 
    %but it would have to be 3 or less thick to really be a problem.
    cropLong=ceil(size(input,1)*0.1);
    cropTall=ceil(size(input,2)*0.05);
    tall=size(input,1)-cropTall;
    long=size(input,2)-cropLong;
    input=input(cropTall+1:tall, cropLong+1:long);
    
    isMinus=0;
    horizProj=rot90(sum2(input,1));
    
    %Standard deviation in percent of mean.
    stdPerc=std(horizProj)/mean(horizProj);
    
    %has to be long and even.
    if(stdPerc<0.25 && long>tall*2)
        isMinus=1;
    end
end

function[isDivide]=isADivide(input)
    %Input is a / if it's even in both projections and it's not too upright,
    %otherwise it might be a 1. That's why it's checked for the percentage
    %of non-zero pixels. Furthermore the upper left and lower right corners
    %are checked because of 0s and 8s.
    isDivide=1;

    tall=size(input,1);
    long=size(input,2);
    %get the amount of pixels with content and divide by total pixels
    percentageContent=size(find(input),1)/(tall*long);
    if(percentageContent>0.55)
        isDivide=0;
    else
        hProj= sum2(input, 2);
        vProj= rot90(sum(input));
        hProjOK=(std(hProj)/mean(hProj))<0.30;
        %on the sides it is a little crooked, but in the middle a / should be about
        %the same, so -15% on each side should help.
        margin=ceil(size(vProj,1)*0.15);
        vProj=vProj(margin:size(vProj,1)-margin);
        vProjOK=(std(vProj)/mean(vProj))<0.33;
        
        %if the projection of both sides is fairly even.
        if(vProjOK~=1||hProjOK~=1)
            isDivide=0;
        end
        
        %Sometimes a 0 or 8 might look like a /, thats why the upper left
        %and lower right corner should be checked for content.
        quartLong=floor(long*0.25);
        quartTall=floor(tall*0.25);
        if(sum(sum(input(1:quartTall,1:quartLong)))>0|| sum(sum(input(tall-quartTall:tall, long-quartLong:long)))>0)
            isDivide=0;
        end
    end
    
end

function[isMult]=isAMult(input)
    %Pretty simple: If the input is mostly black (except maybe for the
    %corners) it is a * pretty certainly. It should also be roughly square
    isMult=1;
    tall=size(input,1);
    long=size(input,2);
    sumBlack=sum(sum(input));
    percentageBlack=sumBlack/max(max(input))/(tall*long);
    if(percentageBlack<0.6 || ~compareWithMargin(tall, long, 0.5))
        isMult=0;
    end
end

function[isBracket]=isABracket(input)
    %checking for (
    %check for corners and even distribution. Furthermore which side is
    %fuller (to check if it's a ( or a ) )
    isBracket=1;
    %brackets aren't upright very often, so it has to be rotated
    input=rotateUpright(input, 20, 5);
    
    horizProj=rot90(sum2(input,1));
    half=size(horizProj,1)/2;
    firstPortion=sum(horizProj(1:floor(half)));
    secondPortion=sum(horizProj(ceil(half):floor(half*2)));
    
    %The right way around?
    if(firstPortion>secondPortion*0.7)
        isBracket=0;
    end
    
    pix=pixelizePic(input,7,4);
    %at least the middle left of the pic has to be full and the middle right has to be
    %empty. Furthermore at least one of the left corners has to be empty.
    %(as the ( could be rotated)
    if(sum(pix(3:5,1)==1)==0 || (pix(1,1)==1 && pix(7,1)==1) || sum(pix(3:5,4)==0)==0)
        isBracket=0;
    end
    
    vertProj=sum2(input,2);
    %standard deviation in percent
    %a bracket can be written very clumsily, so the std could be
    %very high.
    %On the other side if it is set too high, a 3 might get recognized as a )
    stdPerc=std(vertProj)/mean(vertProj);
    if(stdPerc>0.45)
        isBracket=0;
    end
    
    %there might be a problem with 1s, so the upper and lower half have to
    %be roughly equal
    halfV=size(vertProj,1)/2;
    firstHalf=vertProj(1:floor(halfV));
    secondHalf=vertProj(ceil(halfV):size(vertProj,1));
    if(~compareWithMargin(sum(firstHalf), sum(secondHalf), 0.3))
        isBracket=0;
    end
    
end

%rotates the input by up to +-maxDegrees, depending on where the pic is the
%largest (longest). Steps is how finely it should be rotated.
%every step rotate by +- maxDegrees/steps and check if it is longer than
%previous longest.
function[result]=rotateUpright(input, maxDegrees, steps)
stepDegree=maxDegrees/steps;
result = input;
for i=0:steps
    
    %positive
    currentPic=getContentOfPic(imrotate2(input, stepDegree*i));
    if(size(currentPic,1)>size(result,1))
        result=currentPic;
    end
    
    %negative
    currentPic=getContentOfPic(imrotate2(input, stepDegree*i*-1));
    if(size(currentPic,1)>size(result,1))
        result=currentPic;
    end
    
end
end

%returns a binary map depicting which areas of the input contain content.
%e.g.: pixelizePic(picOfZero,3,2) it might return a map with only 1s except
%for the middle.
function[result]=pixelizePic(input,heightPx,widthPx)
result=zeros(heightPx, widthPx);

%height and width of individual areas.
sectionH=size(input,1)/heightPx;
sectionW=size(input,2)/widthPx;

for h=1:heightPx
    for w=1:widthPx
        %get area of input
        xStart=floor((w-1)*sectionW)+1;
        xEnd=ceil(w*sectionW)-1;
        yStart=floor((h-1)*sectionH)+1;
        yEnd=ceil(h*sectionH)-1;
        sectionSum=sum(sum(input(yStart:yEnd,xStart:xEnd)));
        %check for content
        if(sectionSum>0)
            result(h,w)=1;
        end
    end
end
end

function[result]=compareWithMargin(a, b, margin)
    result=(margin<1 && margin>0 && a>b*(1-margin) && a<b*(1+margin));
end