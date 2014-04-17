function mappedIndexes=interestPointMatching(descriptors, numPerIm, ipToFindPerIm, corrThresh)
    [sizex, sizePatch] = size(decriptors);
    
    sizeCorrMat = sizex/sizePatch;
    numIms = sizeCorrMat/numPerIm;
    corrMat = zeros(sizeCorrMat);
    
    %for each image
    for fromIm=1:sizeCorrMat
        xcorrMatResult = normxcorr2(descriptors(fromIm:(fromIm+sizePatch-1),fromIm:(fromIm+sizePatch-1)), descriptors);
        curImDesc = floor(fromIm / numPerIm) + 1;

        %store results
        for toIm=1:sizeCorrMat
            if (curImDesc ~= floor(toIm/numPerIm)+1)
                corrMat(fromIm,toIm) = xcorrMatResult(((toIm-1)*sizePatch)+1,1);
                corrMat(toIm,fromIm) = corrMat(fromIm,toIm);
            else
                corrMat(fromIm,toIm) = -1;
            end
        end
    end
    
    %mappedIndexs = zeros(ipToFindPerIm,4); %3 columns.  First and second with image.  Third and forth with point index
    mappedIndexes = [];
    
    %for each image set
    for fromIm = 1:numIms
        curCol = corrMat(:,fromIm) .* (corrMat(:,fromIm) >= corrThresh);
        for toIm = fromIm:numIms
            curRow = curCol(toIm,:);
            [colMaxes, colIndexes] = max(curRow, [],2);%columns of A with maxes
            mat = zeros(numPerIm, numPerIm);
            mat(colIndexes,:) = colMaxes;
                
            [rowMax, rowIndexes] = max(mat, [], 1);
            [selectedMaxes,rowOrigIndexes] = sort(rowMax);
            
            numFound = find(selectedMaxes);
            
            if (size(numFound,1) >= ipToFindPerIm)
                insertVal(1:ipToFindPerIm,1) = fromIm;
                insertVal(1:ipToFindPerIm,2) = toIm;
                insertVal(1:ipToFindPerIm,3) = rowIndexes(rowOrigIndexes(1:ipToFindPerIm));
                insertVal(1:ipToFindPerIm,4) = rowOrigIndexes(1:ipToFindPerIm);

                mappedIndexes = [mappedIndexes;insertVal];
            end
        end
    end
    
end