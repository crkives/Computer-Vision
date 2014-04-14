function mappedIndexs=interestPointMatching(descriptors, numPerIm, ipToFindPerIm)
    [sizex, sizePatch] = size(decriptors);
    
    corrMat = zeros(sizex/sizePatch);
    
    %for each image
    for i=1:(sizex/sizePatch)
        xcorrMatResult = normxcorr2(descriptors(i:(i+sizePatch-1),i:(i+sizePatch-1)), descriptors);
        curImDesc = floor(i / numPerIm) + 1;

        %store results
        for j=1:(sizex/sizePatch)
            if (curImDesc ~= floor(i/numPerIm)+1)
                corrMat(i,j) = xcorrMatResult(j+(sizePatch-1),1);
            else
                corrMat(i,j) = -1;
            end
        end
    end
    
    %find correlation points
    totAmtIms = sizex/sizePatch;%total amount of ims
    [maxes, indexes] = max(corrMat,2); %get a list of max values and a list of indexs to those maxes 
    
    %convert each value in the maxes gets converted to an image.  So
    %essentially this is a vector containing the images it belongs to
    imageMapVec = floor((1/numPerIm) * (indexes-1))+1; %index the image refers too %can threshold this value if necessary
    
    %mappedIndexs = zeros(ipToFindPerIm,4); %3 columns.  First and second with image.  Third and forth with point index
    mappedIndexs = [];
    
    %for each image set
    for i = 1:totAmtIms
        for j = 1:totAmtIms
            curMapVec = imageMapVec(j:j+numPerIm);
            idxMapVec = find(curMapVec == i);%get index of all descriptors this image matches to

            if (size(idxMapVec,1) > ipToFindPerIm)
                [~, idxMax] = sort(maxes(idxMapVec),'descend');%get index of the maxs and grab the top 6

                insertVal(1:ipToFindPerIm,1) = i;
                insertVal(1:ipToFindPerIm,2) = imageMapVec(idxMax(1:ipToFindPerIm));
                insertVal(1:ipToFindPerIm,3) = idxMax(1:ipToFindPerIm);
                insertVal(1:ipToFindPerIm,4) = indexes(idxMax(1:ipToFindPerIm));

                mappedIndexs = [mappedIndexs;insertVal];
            end
        end
    end
    
end