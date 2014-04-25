function cellBins = binning(window, cellSize, binTotAmt, binDist)
    [windowX, windowY, ~] = size(window);
    %cellBins = zeros(windowX/cellSize,windowY/cellSize,binTotAmt);
    maxBin = binTotAmt * binDist;
    window(:,:,2) = mod(window(:,:,2),maxBin);
        
    x=cellSize*((1:(windowX/cellSize))-1)+1;
    y=cellSize*((1:(windowY/cellSize))-1)+1;
    positionsX=repmat(x, size(y));
    positionsY=repmat(y, size(x));
    
    extractFunc = @(r,c) window(r:(r+cellSize-1),c:(c+cellSize-1),:);
    cells = arrayfun(extractFunc,positionsX,positionsY,'UniformOutput',false);

    binFunc = @(cell) anglePartitioning(cell, binTotAmt, binDist);
    cellBins = cellfun(binFunc, cells, 'UniformOutput',false);
    
%     for cellX=1:windowX/cellSize
%         cellStartX = cellSize*(cellX-1)+1;
%         cellEndX = cellStartX + cellSize-1;
%         for cellY=1:windowY/cellSize
%             cellStartY = cellSize*(cellY-1)+1;
%             cellEndY = cellStartY+cellSize-1;
% 
%             cell = window(cellStartX:cellEndX,cellStartY:cellEndY,:);
%             
%             for bin=1:binTotAmt
%                curBin = binDist * (bin-1);
%                nextBin = curBin + binDist;
%                curBinMid = (nextBin+curBin)/2;
%                angles = cell(:,:,2);
%                
%                if (bin == 1)
%                   angles = angles+(-maxBin*(angles > (maxBin-binDist)));
%                elseif (bin == binTotAmt)
%                   angles = angles+((maxBin-binDist)*(angles < (binDist)));
%                end
%                
%                percentInBin = 1-abs((angles-curBinMid)/(2*(curBin-curBinMid)));
%                
%                %normilization here?
%                cellBins(cellX,cellY,bin) = sum(sum((cell(:,:,1).*(percentInBin.*(percentInBin > 0 & percentInBin <= 1)))));
%             end
%         end
%     end
    
    
end