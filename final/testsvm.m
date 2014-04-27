% Pre-allocate trainingFeatures array
numTrainingImages = size(images,1);
%trainingFeatures  = zeros(numTrainingImages,hogFeatureSize,'single');
boundingBoxes = csvread('../../train/annotations.csv');

% Extract HOG features from each training image. trainingImages
% contains both positive and negative image samples.
labels = [];
trainingFeatures=[];
for i = 1:length(images)
    if i > length(imagesPos)
        trainingFeatures = [trainingFeatures,extractHOGFeatures(image)'];
        labels = [labels,0];
    else
        annoCount = boundingBoxes(i,1);
        for j=1:annoCount
            index = 4*(j-1)+1;
            x=boundingBoxes(i,index+1);
            y=boundingBoxes(i,index+2);
            maxx = boundingBoxes(i,index+3);
            maxy = boundingBoxes(i,index+4);
            
            image = images{i};
            addy = maxy-y;
            addx = maxx-x;
            image = image(y:y+addy,x:x+addx,:);
            image= imresize(image, [128, 64]);

            trainingFeatures = [trainingFeatures,extractHOGFeatures(image)'];
            labels = [labels,1];
        end
    end
end

% Train a classifier for a digit. Each row of trainingFeatures contains
% the HOG features extracted for a single training image. The
% trainingLabels indicate if the features are extracted from positive
% (true) or negative (false) training images.

svm = trainSVM(trainingFeatures, labels, @linearKernelFunction);