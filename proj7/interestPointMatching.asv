function mappedIndexes=interestPointMatching(descriptors, numPerIm, ipToFindPerIm, corrThresh)
    [sizex, sizePatch] = size(decriptors);
    
    sizeCorrMat = sizex/sizePatch;
    numIms = sizeCorrMat/numPerIm;
    corrMat = zeros(sizeCorrMat);
    
    %for each image
    for i=1:sizeCorrMat
        xcorrMatResult = normxcorr2(descriptors(i:(i+sizePatch-1),i:(i+sizePatch-1)), descriptors);
        curImDesc = floor(i / numPerIm) + 1;

        %store results
        for j=1:sizeCorrMat
            if (curImDesc ~= floor(j/numPerIm)+1)
                corrMat(i,j) = xcorrMatResult(((j-1)*sizePatch)+1,1);
                corrMat(j,i) = corrMat(i,j);
            else
                corrMat(i,j) = -1;
            end
        end
    end
    
    %mappedIndexs = zeros(ipToFindPerIm,4); %3 columns.  First and second with image.  Third and forth with point index
    mappedIndexes = [];
    
    %for each image set
    for i = 1:numIms
        curCol = corrMat(:,i) .* (corrMat(:,i) >= corrThresh);
        for j = i:numIms
            curRow = curCol(j,:);
            [colMaxes, colIndexes] = max(curRow,2);%columns of A with maxes
            mat = zeros(numPerIm, numPerIm);
            mat(colIndexes,:) = colMaxes;
                
            [rowMax, rowIndexes] = max(mat, 1);
            [selectedMaxes,rowOrigIndexes] = sort(rowMax);
            
            numFound = find(selectedMaxes);
            
            if (size(numFound,1) >= ipToFindPerIm)
                insertVal(1:ipToFindPerIm,1) = i;
                insertVal(1:ipToFindPerIm,2) = j;
                insertVal(1:ipToFindPerIm,3) = rowIndexes(rowOrigIndexes(1:ipToFindPerIm));
                insertVal(1:ipToFindPerIm,4) = rowOrigIndexes(1:ipToFindPerIm);

                mappedIndexes = [mappedIndexes;insertVal];
            end
        end
    end
    
end