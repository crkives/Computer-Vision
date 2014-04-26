function descriptor=blockNormalization(cellBins)
    [sizex,sizey] = size(cellBins);
    blockSize = 2;
    
    x=(1:(sizex-blockSize+1));
    y=(1:(sizey-blockSize+1));
    positionsX=repmat(x, size(y));
    positionsY=repmat(y, size(x));
    
%     extractFunc = @(r,c) cellBins(r:(r+blockSize-1),c:(c+blockSize-1),:);
%     blocks = arrayfun(extractFunc,positionsX,positionsY,'UniformOutput',false);
    
    descFunc = @(r,c) blockNorm(cellBins(r:(r+blockSize-1),c:(c+blockSize-1)));
    descriptor=arrayfun(descFunc,positionsX,positionsY, 'UniformOutput',false);
    descriptor=cell2mat(descriptor(:));
    descriptor = descriptor(:);

%     for x=1:sizex-blockSize+1
%         startX = x;
%         endX = x + blockSize-1;
%         for y=1:sizey-blockSize+1
%             startY = y;
%             endY = y+blockSize-1;
%             
%             block = cellBins(startX:endX, startY:endY,:);
% 
%             finalVec = reshape(block, sizez*2*blockSize,1); 
%             finalVec = finalVec/norm(finalVec);
%             descriptor = [descriptor;finalVec];
%         end
%     end
end

function descriptor=blockNorm(block)
    finalVec = block{:};
    descriptor=(finalVec/norm(finalVec));
end