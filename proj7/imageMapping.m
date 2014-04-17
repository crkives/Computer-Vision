function [mapping, maxIdx]=imageMapping(mappedIndex)
    imCol = mappedIndex(:,1); %get the column of the images that are the from images
    maxImNum = max(imCol, [],1);%get the max number for the mapping
    mapping = cell(maxImNum);%create the cell array
    
    maxLen = 0;
    maxIdx = -1;
    %for each image
    for i=1:length(mapping)
        row = imCol == i; %get the rows for that image 
        
        mapping{i} = unique(mappedIndex(row,2)');%get the unique values in the row
        if (size(mappedIndex,2) > maxLen) %get maxes
            maxIdx = i;
            maxLen = size(mappedIndex,2);
        end
    end
end