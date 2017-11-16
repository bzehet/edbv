%gets a full-size Picture-Array and returns an array of chars
%it iterates over the pictures and crops them. Then it checks which symbol
%(+,-,*,/,(,)) it is. At the end it returns a char-array in the form of
%{'-','?','+','?'}
%Might work better with skeletonized pictures.
%Might work better with hough transform (especially with the brackets)


function [result]=zeichenErkennung(inputPics)
    %result=test()
    result=zeichnErkennungAlg(inputPics,0);
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
    amount=size(inputPics,1);
    if(justFileNames) 
        amount=size(inputPics,2);
    end
    
    result=zeros(1,amount);
    for i=1:amount
        if(justFileNames)
            pic=imread(char(inputPics(i)));
            pic=imcomplement(pic);
        else
            pic=inputPics(i);
        end
        pic=im2bw(pic,0.5);
        imshow(pic);
        %crops image to relevant part
        pic=getSymbolPortionOfBWpic(pic);
        
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
                        else
                            if(isABracket(fliplr(pic)))
                                result(i)=')';
                            else
                                result(i)='?';
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
    if(percentageBlack>0.4 && long>tall*2)
        isMinus=1;
    end
%     vertProj=rot90(sum(input)/(size(input,1)*255));
%     %90 percent has to be black by at least 90% 
%     if(sum(vertProj(:)<0.9)<size(vertProj)*0.90)
%         isMinus=0;
%         return
%     end
%     horizProj=sum(input,2);
%     if(sum(horizProj(:)<0.7) || sum(size(horizProj)<size(vertProj)*2))
%         isMinus=0
%         return
%     end
    
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
          checkSide = sum(input, 2);
        for c=0:1
            
            third=size(checkSide,1)/3;

            firstPortion=sum(checkSide(1:floor(third)));
            secondPortion=sum(checkSide(ceil(third):floor(third*2)));
            thirdPortion=sum(checkSide(ceil(third*2):size(checkSide,1)));
            %check again with other side
            checkSide = rot90(sum(input));

            if(firstPortion>secondPortion*1.2||firstPortion<secondPortion/1.2||thirdPortion>secondPortion*1.2||thirdPortion<secondPortion/1.2)
                isDivide=0;
            end
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
    %bad: it just looks at the different parts of the picture and
    %determines in which one is more color.

    isBracket=1;
    
    horizProj=rot90(sum(input,1));
    half=size(horizProj,1)/2;
    firstPortion=sum(horizProj(1:floor(half)));
    secondPortion=sum(horizProj(ceil(half):floor(half*2)));
    if(firstPortion>secondPortion*0.7)
        isBracket=0;
    end
    vertProj=sum(input,2);
    %upper and lower quarter of pic have to be greater than middle
    quarter=size(vertProj,1)/5;
    firstPortion=sum(vertProj(1:floor(quarter)));
    secondPortion=sum(vertProj(ceil(quarter):floor(quarter*3)));
    thirdPortion=sum(vertProj(ceil(quarter*3):floor(quarter*4)));
    if(firstPortion+thirdPortion<secondPortion)
        isBracket=0;
    end
end