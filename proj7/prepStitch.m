%imlist - cell array of images with the current one being indexed by curImIndex
%cellList - cell array with each index of an image containing the indexes
%       of the images it references
%curImIndex - index of image we are using
%interestPoints - cell array of interest points
%visitedList - a list containing the items we have visited thus far.
%   Should be [] initially
%corners - a cell array with each image index containing column vectors of
%   corners
%curTransformMat - the transformation used to get into the image space of
%   of the prior image (initially identity [1,0,0;0,1,0;0,0,1])
function [corners, visitedList, warpedIms] = prepStitch(imList, cellList, curImIndex, mapping, interestPoints, visitedList, corners, curTransformMat, warpedIms)
    vecConnectIms = cellList{curImIndex};
    visitedList = [visitedList,curImIndex];
    im = imList{curImIndex};
    
    %build corners
    [sizex,sizey] = size(im);
    cornerTL = curTransformMat * [1,1,1]';         %top left corner
    cornerTR = curTransformMat * [1,sizey,1]';
    cornerBL = curTransformMat * [sizex,1,1]';
    cornerBR = curTransformMat * [sizex,sizey,1]';
    corners{curImIndex} = [cornerTL,cornerTR,cornerBL,cornerBR];
    
    curTransformMat(1:2,3) = [0;0];
    imWarp = imwarp(im, affine2d(curTransformMat));    
    warpedIms{curImIndex} = imWarp;
    for i=1:size(vecConnectIms)
        if (~any(visitedList == vecConnectIms(i)))
            indexFrom = mapping(:,1) == curImIndex;
            mappingFrom = mapping(indexFrom,:);
            indexTo = mappingFrom(:,2) == vecConnectIms(i);
            mappingValuesIpValues = mappingFrom(indexTo,3:4);
            
            fromIp = interestPoints(mappingValuesIpValues(:,1),:);
            toIp = interestPoints(mappingValuesIpValues(:,2),:);
            transform = buildTransformMat([fromIp,toIp]);
            transform = curTransformMat * transform;
            [corners, visitedList, warpedIms] = prepStitch(imList, cellList, curImIndex, mapping, interestPoints, visitedList, corners, transform, warpedIms);
        end
    end
end