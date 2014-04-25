function binVec = anglePartitioning(cell, binTotAmt, binDist)
    binVec = zeros(1,binTotAmt);
    maxBin = binTotAmt * binDist;
    
    %bin = 1:binTotAmt;
    %binFunc = @(block, bin) 
    
    for bin=1:binTotAmt
       curBin = binDist * (bin-1);
       nextBin = curBin + binDist;
       curBinMid = (nextBin+curBin)/2;
       angles = cell(:,:,2);

       if (bin == 1)
          angles = angles+(-maxBin*(angles > (maxBin-binDist)));
       elseif (bin == binTotAmt)
          angles = angles+((maxBin-binDist)*(angles < (binDist)));
       end

       percentInBin = 1-abs((angles-curBinMid)/(2*(curBin-curBinMid)));

       %normilization here?
       binVec(bin) = sum(sum((cell(:,:,1).*(percentInBin.*(percentInBin > 0 & percentInBin <= 1)))));
    end
end