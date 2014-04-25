function descriptors=spaitialBinning(imGradientMat, windowSizeR, windowSizeC, cellSize, binTot, binDist)
    mAng = zeros(size(imGradientMat));
    mAng(:,:,1) = (imGradientMat(:,:,1).^2 + imGradientMat(:,:,2).^2).^(1/2);
    mAng(:,:,2) = radtodeg(atan2(imGradientMat(:,:,2), imGradientMat(:,:,1)));
    
    [sizex, sizey, ~] = size(imGradientMat);
    gapX = floor(sizex/(windowSizeC/2))-1; 
    gapY = floor(sizey/(windowSizeR/2))-1; 
    posX = floor(windowSizeC/2);
    posY = floor(windowSizeR/2);
    
    x=posX*((1:gapX)-1)+1;
    y=posY*((1:gapY)-1)+1;
    positionsX=repmat(x, size(y));
    positionsY=repmat(y, size(x));

    extractFunc = @(r,c) mAng(r:(r+windowSizeC-1),c:(c+windowSizeR-1),:);
    windows = arrayfun(extractFunc,positionsX,positionsY,'UniformOutput',false);
    
    cellFunc = @(windowCell) binning(windowCell, cellSize, binTot, binDist); 
    bins = cellfun(cellFunc, windows, 'UniformOutput',false);
    
    descFunc = @(binCell) blockNormalization(binCell);
    descriptors = cellfun(descFunc, bins, 'UniformOutput',false);
    
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