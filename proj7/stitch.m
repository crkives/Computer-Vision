function prepStitch(imList, curImIndex, cellList, interestPoints, visitedList, corners, curTransformMat)
    vecConnectIms = cellList{curImIndex};
    visitedList = [visitedList,curImIndex];
    %build corners
    
    for i=1:size(vecConnectIms)
        
        stitch(imList, vecConnectIms(i), cellList, interestPoints, visitedList);
    end
end