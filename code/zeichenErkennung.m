%gets a full-size Picture-Array and returns an array of chars
%it iterates over the pictures and crops them. Then it checks which symbol
%(+,-,*,/,(,)) it is. At the end it returns a char-array in the form of
%{'-','?','+','?'}
%Might work better with skeletonized pictures.
%Might work better with hough transform (especially with the brackets)


function [result]=zeichenErkennung(inputPics)
    %result=test()
    result=zeichenErkennungAlg(inputPics,0);
end

function[result]= test()

    var loadFilesFlag=1;
    result='';
    
    files={'resized/bracketOpen.png','resized/divide.png','resized/minus.png','resized/plus.png','resized/mal.png'}
    
    result=zeichenErkennungAlg(files,1);
    
end


function [result]=zeichenErkennungAlg(inputPics,justFileNames)
    %imshow(pic);
    %pause;
    
    %imshow(pic);
    %pic
    %pause;
    amount=size(inputPics,3);
    if(justFileNames) 
        amount=size(inputPics,2);
    end
    
    result=zeros(1,amount);
    bracketOpenCounter=0;
    for i=1:amount
        if(justFileNames)
            pic=imread(char(inputPics(i)));
            pic=imcomplement(pic);
        else
            pic=inputPics(:,:,i);
        end
        %pic=im2bw(pic,0.5);
        %imshow(pic);
        if(max(max(pic))==0)
            result(i)='=';
        else
            pic=getSymbolPortionOfBWpic(pic);
            imshow(pic);
            if(sum(size(pic))<15)
                result(i)=' ';
            else
                %crops image to relevant part
                if(isAPlus(pic))
                    result(i)='+';
                else
                    if(isAMinus(pic))
                        result(i)='-';
                    else
                        if(isADivide(pic))
                            result(i)='/';
                        else
                            if(isAMult(pic))
                                result(i)='*';
                            else
                                if(isABracket(pic))
                                    result(i)='(';
                                    bracketOpenCounter=bracketOpenCounter+1;
                                else
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
    end
    result=char(result);
end


function[symbolPic]=getSymbolPortionOfBWpic(input)
    indSubPic=find(input);
    widPic=size(input,2);
    heiPic=size(input,1);
    xmin=floor(min(indSubPic)/heiPic)+1;
    ymin=min(mod(indSubPic,heiPic));
    xmax=floor(max(indSubPic)/heiPic)+1;
    ymax=max(mod(indSubPic,heiPic));
    subPicRect=[xmin,ymin,xmax-xmin,ymax-ymin];
    symbolPic=imcrop(input,subPicRect);
end
function[isPlus]=isAPlus(input)
    isPlus=1;
    %first check horizontal
    %input=bwmorph(input,'skel',Inf);
    %Don't skeletonize, otherwise it might be recognized as a +
    
    tall=size(input,1);
    long=size(input,2);
    percentageBlack=sum(sum(input))/max(max(input))/(tall*long);
    if(percentageBlack >0.5)
        isPlus=0;
    else
        checkSide = sum(input, 2);
        for c=0:1
            %how to detect a plus: portion a projection in 3 1/3rd areas, if the sum of
            %the first and last are less than the middle one it is either a + or a *

            third=size(checkSide,1)/3;

            firstPortion=sum(checkSide(1:floor(third)));
            secondPortion=sum(checkSide(ceil(third):floor(third*2)));
            thirdPortion=sum(checkSide(ceil(third*2):size(checkSide,1)));

            %check again with other side
            checkSide = rot90(sum(input));

            if(firstPortion+thirdPortion>secondPortion*1.2)
                isPlus=0;
            end
        end
    end
end
function[isMinus]=isAMinus(input)
    %it's a minus if it's long (longer than tall) and mostly black.
    tall=size(input,1);
    long=size(input,2);
    percentageBlack=sum(sum(input))/max(max(input))/(tall*long);
    isMinus=0;
    
    horizProj=rot90(sum(input,1));
    stdPerc=std(horizProj)/mean(horizProj);
    
    if(stdPerc<0.25 && long>tall*2)
        isMinus=1;
    end
end

function[isDivide]=isADivide(input)
    isDivide=1;

    tall=size(input,1);
    long=size(input,2);
    sumBlack=sum(sum(input));
    percentageBlack=sumBlack/max(max(input))/(tall*long);
    avgtall=sumBlack/tall;
    avgLong=sumBlack/long;
    
    if(percentageBlack>0.7)
        isDivide=0;
    else
        hProj= sum(input, 2);
        vProj= rot90(sum(input));
        hProjOK=(std(hProj)/mean(hProj))<0.30;
        %on the sides it is a little crooked, but in the middle a / should be about
        %the same, so -15% on each side should help.
        %there might be a problem with 0
        %there is a problem with 8
        spazi=ceil(size(vProj,1)*0.15);
        vProj=vProj(spazi:size(vProj,1)-spazi);
        vProjOK=(std(vProj)/mean(vProj))<0.33;
        if(vProjOK~=1||hProjOK~=1)
            isDivide=0;
        end
        %the problem with 8 and 0 might be solve 
        %if the upper left and lower right corner are
        %checked for content, as 8 and 0 have content there, but / doesn't
        %check 25%*25%
        quartLong=floor(long*0.25);
        quartTall=floor(tall*0.25);
        if(sum(sum(input(1:quartTall,1:quartLong)))>0|| sum(sum(input(tall-quartTall:tall, long-quartLong:long)))>0)
            isDivide=0;
        end
    end
    
end

function[isMult]=isAMult(input)
    isMult=1;
    tall=size(input,1);
    long=size(input,2);
    sumBlack=sum(sum(input));
    percentageBlack=sumBlack/max(max(input))/(tall*long);
    if(percentageBlack<0.6)
        isMult=0;
    else
        
    end
end

function[isBracket]=isABracket(input)
    %checking for (
    isBracket=1;
    
    horizProj=rot90(sum(input,1));
    half=size(horizProj,1)/2;
    firstPortion=sum(horizProj(1:floor(half)));
    secondPortion=sum(horizProj(ceil(half):floor(half*2)));
    
    %actually not a real criteria, as ( can be more like a C or like a {
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
    
    vertProj=sum(input,2);
    %standard deviation in percent
    %a bracket can be written very clumsily, so the std could be
    %very high.
    %On the other side if it is set too high, a 3 might get recognized as a )
    stdPerc=std(vertProj)/mean(vertProj);
    if(stdPerc>0.3)
        isBracket=0;
    end
    
    
    %upper and lower quarter of pic have to be greater than middle
%     quarter=size(vertProj,1)/5;
%     firstPortion=sum(vertProj(1:floor(quarter)));
%     secondPortion=sum(vertProj(ceil(quarter):floor(quarter*3)));
%     thirdPortion=sum(vertProj(ceil(quarter*3):floor(quarter*4)));
%     if(firstPortion+thirdPortion<secondPortion)
%         isBracket=0;
%     end
end

function[result]=pixelizePic(input,heightPx,widthPx)
result=zeros(heightPx, widthPx);

sectionH=size(input,1)/heightPx;
sectionW=size(input,2)/widthPx;
for h=1:heightPx
    for w=1:widthPx
        xStart=floor((w-1)*sectionW)+1;
        xEnd=ceil(w*sectionW)-1;
        yStart=floor((h-1)*sectionH)+1;
        yEnd=ceil(h*sectionH)-1;
        sectionSum=sum(sum(input(yStart:yEnd,xStart:xEnd)));
        if(sectionSum>0)
            result(h,w)=1;
        end
    end
end
end