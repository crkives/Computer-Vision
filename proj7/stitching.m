function outIm = stitching(imList, mapping, interestPoints)
    [imMapping, baseImIdx] = imageMapping(mapping);%get a list of images the current image is mapped to

    warpedIms = cell(length(imMapping));
    visitedList = [];%zeros(1,length(imMapping));
    corners = cell(length(imMapping));
    [corners, visitedList, warpedIms] = prepStitch(imList, imMapping, baseImIdx, mapping, interestPoints, visitedList, corners, eye(3), warpedIms); %calculates data for stitching
    
    %get data for where our corners will be placed (this is used for
    %   translation
    cornersMat = zeros(4,4*size(visitedList,2));
    for i=1:size(visitedList,2)
       index = (4*(i-1))+1;
       cornersMat(1:3,index:index+3) = corners{i};
    end
    
    %get the max and min of the corners so we can define our bounding box
    maxXY = max(cornersMat, [], 2);
    minXY = min(cornersMat, [], 2);
    
    %get first image to place in the list
    im = imList{visitedList(1)};
    [sizex,sizey] = size(im);
    
    %get upper and lower bounds based on corners
    lowerBoundY = abs(minXY(1));
    upperBoundY = lowerBoundY + maxXY(1);
    
    lowerBoundX = abs(minXY(2));
    upperBoundX = lowerBoundX + maxXY(2);
    
    %set base images offset
    offsetToBaseImX = 1+lowerBoundX;
    offsetToBaseImY = 1+lowerBoundY;
    
    %build out image
    outIm = zeros(ceil(upperBoundX), ceil(upperBoundY));
    outIm(offsetToBaseImX:offsetToBaseImX+sizex-1,offsetToBaseImY:offsetToBaseImY+sizey-1) = im;
    
    %loop through all the 
    for imNum = 2:size(visitedList,2)
       imIdx = visitedList(imNum); %get the index of the image we are displaying next
       curIm = warpedIms{imIdx}; %get the image
       [sizex,sizey] = size(curIm); %get the size
       
       %calculate where the minimum point is and tranlate it to that point
       curMinXY = corners{imIdx};
       imMinX = offsetToBaseImX+curMinXY(2);
       imMinY = offsetToBaseImY+curMinXY(1);
       
       %create a new image
       newIm = zeros(ceil(upperBoundX), ceil(upperBoundY));
       newIm(imMinX:(imMinX+sizex-1),imMinY:(imMinY+sizey-1)) = curIm;
       
       %blend with other images
       outIm = imfuse(outIm, newIm, 'blend');
    end
    
%     translate = transform(1:2,3);
%         
%     [im1x, im1y] = size(im1);
%     [im2x, im2y] = size(im2);
%     
%     cornerTL = transform * [1,1,1]';%top left corner
%     cornerTR = transform * [1,im2y,1]';
%     cornerBL = transform * [im2x,1,1]';
%     cornerBR = transform * [im2x,im2y,1]';
%     
%     corners = [[1,1,1]',cornerTL,cornerTR, cornerBL, cornerBR,[im1x,im1y,1]'];
%     maxXY = max(corners, [], 2);
%     minXY = min(corners, [], 2);
%         
%     transform(1:2,2) = [0;0];
%     im2 = imwarp(im2, affine2d(transform));
%     
%     %place first image
%     newIm1 = zeros((minXY(1)-1) + maxXY(1),(minXY(2)-1)+maxXY(2));
%     im1XOffset = abs(minXY(1)-1);    
%     im1YOffset = abs(minXY(2)-1);
%     
%     startX = 1+im1XOffset;
%     endX = 1+im1XOffset + im1x;
%     startY = 1+im1YOffset;
%     endY = 1+im1YOffset + im1y;
%     newIm1(startX:endX, startY:endY) = im1;
%     
%     %place secondary image
%     newIm2 = zeros((minXY(1)-1) + maxXY(1),(minXY(2)-1)+maxXY(2));
%     im2XOffset = translate(1);    
%     im2YOffset = translate(2);
%     
%     startX = 1+im2XOffset;
%     endX = 1+im2XOffset + im2x;
%     startY = 1+im2YOffset;
%     endY = 1+im2YOffset + im2y;
%     newIm2(startX:endX, startY:endY) = im2;
%     
%     outIm = imfuse(newIm1, newIm2);
end