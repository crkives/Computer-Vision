function [descriptors, sizing]=spaitialBinning(imGradientMat, windowSizeR, windowSizeC, cellSize, binTot, binDist)
    mAng = zeros(size(imGradientMat));
    mAng(:,:,1) = (imGradientMat(:,:,1).^2 + imGradientMat(:,:,2).^2).^(.5);
    mAng(:,:,2) = radtodeg(atan2(imGradientMat(:,:,2), imGradientMat(:,:,1)));
    
    [sizex, sizey, ~] = size(imGradientMat);
    gapX = floor(sizex/(windowSizeC/2))-1; %(sizex-windowSizeC);
    gapY = floor(sizey/(windowSizeR/2))-1; %(sizey-windowSizeR);
    posX = floor(windowSizeC/2);%1;
    posY = floor(windowSizeR/2);%1;
    
    x=posX*((1:gapX)-1)+1;
    y=posY*((1:gapY)-1)+1;
    positionsX=repmat(x, size(y));
    positionsY=repmat(y, size(x));

%      extractFunc = @(r,c) {...
%                             fprintf('r=%d', r),...
%                             fprintf('c=%d',c),...
%                             mAng(r:(r+windowSizeC-1),c:(c+windowSizeR-1),:);}
%      windows = arrayfun(extractFunc,positionsX,positionsY,'UniformOutput',false);

    cellFunc = @(r,c) binning(mAng(r:(r+windowSizeC-1),c:(c+windowSizeR-1),:), cellSize, binTot, binDist); 
    bins = arrayfun(cellFunc,positionsX,positionsY, 'UniformOutput',false);
    
    descFunc = @(binCell) blockNormalization(binCell);
    descriptors = cellfun(descFunc, bins, 'UniformOutput',false);
    
    sizing=[positionsX,positionsY];
    
%     for x=1:gapX%(sizex-windowSizeC)
%         startX = posX*(x-1)+1;
%         endX = startX + windowSizeC-1;
%         for y=1:gapY%(sizey-windowSizeR)
%             startY = posY*(y-1)+1;
%             endY = startY + windowSizeR-1;
% 
%             window = mAng(startX:endX,startY:endY,:);           
%             %size(window)
%             %imshow(window(:,:,1)); figure;
%             bins = binning(window, cellSize, binTot, binDist);
%             descriptor=blockNormalization(bins);
%             descriptors=[descriptors,descriptor];
%         end
%     end
end