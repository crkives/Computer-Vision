function mappedIndexes=interestPointMatching(descriptors, numPerIm, ipToFindPerIm, corrThresh)
    [sizex, sizePatch] = size(descriptors); %get the size of the descriptors and the size of each patch
    
    numDesc = sizex/sizePatch; %calculates the number of descriptors exist
    numIms = numDesc/numPerIm; %calculates the number of images we are looking at
    corrMat = zeros(numDesc); %zeros out a square matrix that we will store the correlations in
    
    %for each descriptor
    for i=1:numDesc
        index = (sizePatch*(i-1))+1; %calculate the starting index
        curDescriptor = descriptors(index:(index+sizePatch-1),1:sizePatch);
        xcorrMatResult = normxcorr2(curDescriptor, descriptors);%get the correlation
        curImDesc = floor(i / numPerIm) + 1; %get the image index that we are working on

        %store results
        for j=1:numDesc
            if (curImDesc ~= floor(j/numPerIm)+1) %if the descriptors are for the same image ignore them
                corrMat(i,j) = xcorrMatResult(((j-1)*sizePatch)+1,1); %set the vert correlation found
                corrMat(j,i) = corrMat(i,j); %set the horizontal
            else
                corrMat(i,j) = -1; %ignore the descriptors from the same image
            end
        end
    end
    
    
    %Find all image mappings
    mappedIndexes = [];%First and second index of image.  Third and forth index of interest point
    
    %for each image set
    for fromIm = 1:numIms
        colIdx = numPerIm * (fromIm-1) + 1;%calc the start of the im range in columns
        curCol = corrMat(:,colIdx:(colIdx+numPerIm-1)) .* (corrMat(:,colIdx:(colIdx+numPerIm-1)) >= corrThresh);%grab all the columns of that image and zero out anything less than the threshold
        
        %from the fromImage onward
        for toIm = (fromIm+1):numIms 
            rowIdx = numPerIm * (toIm-1) + 1;%calc the start of the im range in the row
            curRow = curCol(rowIdx:(rowIdx+numPerIm-1),:);%grab the rows of the columns
            
            [colMaxes, colIndexes] = max(curRow, [],2);%get columns indexs of fromIm with maxes in columns
            mat = zeros(numPerIm, numPerIm); %create storage
            indexes = sub2ind([numPerIm, numPerIm], (1:numPerIm)', colIndexes);
            mat(indexes) = colMaxes; %set the rows to their maxes with zeros elsewhere
                
            [rowMax, rowIndexes] = max(mat, [], 1); %get the max of the rows
            [selectedMaxes,rowOrigIndexes] = sort(rowMax, 'descend'); %sort the maxes and get their indices
            
            numFound = find(selectedMaxes); %count the maxes
            
            if (size(numFound,1) >= ipToFindPerIm) %if the maxes are more than the amount we are looking for
                insertVal(1:ipToFindPerIm,1) = fromIm; %store from im index
                insertVal(1:ipToFindPerIm,2) = toIm;%store to im index
                insertVal(1:ipToFindPerIm,3) = rowOrigIndexes(1:ipToFindPerIm); 
                insertVal(1:ipToFindPerIm,4) = rowIndexes(rowOrigIndexes(1:ipToFindPerIm));
                %insertVal(1:ipToFindPerIm,3) = colIndexes(rowIndexes(rowOrigIndexes(1:ipToFindPerIm))); 
                %insertVal(1:ipToFindPerIm,4) = rowIndexes(rowOrigIndexes(1:ipToFindPerIm));

                mappedIndexes = [mappedIndexes;insertVal];
            end
        end
    end
    
end