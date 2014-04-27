%training
lenPos = length(imagesPos)
lenNeg = length(imagesNeg)
images = [imagesPos; imagesNeg];
boundingBoxes = csvread('../../train/annotations.csv');

tic;
svmLabels = [];
svmInput = [];
for i=1:length(images)
    i
    grad = generateGradient(hogNormalizeIm(images{i}));
    [descs,sizes] = spaitialBinning(grad, 64, 128, 8, 9, 20); 
    svmInput = [svmInput,cell2mat(descs')];
    
     if i > lenPos
         svmLabels = [svmLabels, zeros(1,size(descs,1))];
     else
         annoCount = boundingBoxes(i,1);
         label = zeros(1,size(descs,1));
         for j = 1:annoCount
             index = 4*(j-1)+1;
             x=boundingBoxes(i,index+1);
             y=boundingBoxes(i,index+2);
             
             %these below might be reversed (double check)
             [~,xPos] = min(abs(sizes(:,1)-x));
             [~,yPos] = min(abs(sizes(:,2)-y));
             xVal = sizes(xPos,1);
             yVal = sizes(yPos,2);
             
             [hasValue, position] = ismember([xVal,yVal], sizes, 'rows');
             
             label(position) = 1;
         end
         svmLabels = [svmLabels, label];
     end
end
toc


svm = svmtrain(svmInput, svmLabels');