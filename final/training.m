%training
lenPos = length(imagesNeg);
lenNeg = length(imagesPos);
images = [imagesPos; imagesNeg];
boundingBoxes = csvread('train/annotations.csv');

tic;
svmLabels = [];
svmInput = [];
svmSizes = [];
for i=1:1
    grad = generateGradient(hogNormalizeIm(images{i}));
    [descs,sizes] = spaitialBinning(grad, 64, 128, 8, 9, 20); 
    svmInput = [svmInput,cell2mat(descs)];
    svmSizes = [svmSizes,sizes];
    
     if i > lenPos
         svmLabels = [svmLabels, zeros(1,size(svmInput,1))];
     else
         annoCount = boundingBoxes(i,1);
         for j = 1:annoCount
             index = 4*(j-1)+1;
             x=boundingBoxes(i,index+1);
             y=boundingBoxes(i,index+2);
             
             %these below might be reversed (double check)
             [~,xPos] = min(abs(svmSizes(:,1)-x));
             [~,yPos] = min(abs(svmSizes(:,2)-y));
             xVal = svmSizes(xPos);
             yVal = svmSizes(yPos);
             
             ismember(svmSizes, [xVal,yVal])
             
             svmLabels = [svmLabels, ];
         end
     end
end
toc


%svm = svmtrain(svmInput, labels);