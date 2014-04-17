function [mapping, maxIdx]=imageMapping(mappedIndex)
    imCol = mappedIndex(:,1);
    maxImNum = max(imCol, [],1);
    mapping = cell(maxImNum);
    
    maxLen = 0;
    maxIdx = -1;
    for i=1:length(mapping)
        row = imCol == i;
        mapping{i} = unique(mappedIndex(row,2)');
        if (size(mappedIndex,2) > maxLen)
            maxIdx = i;
        end
    end
end