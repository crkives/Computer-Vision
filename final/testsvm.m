% Pre-allocate trainingFeatures array
numTrainingImages = size(trainingImages,1);
trainingFeatures  = zeros(numTrainingImages,hogFeatureSize,'single');

% Extract HOG features from each training image. trainingImages
% contains both positive and negative image samples.
for i = 1:numTrainingImages
    img = imread(trainingImages{i,d});

    img = preProcess(img);

    trainingFeatures(i,:) = extractHOGFeatures(img,'CellSize',cellSize);
end

% Train a classifier for a digit. Each row of trainingFeatures contains
% the HOG features extracted for a single training image. The
% trainingLabels indicate if the features are extracted from positive
% (true) or negative (false) training images.
svm(d) = svmtrain(trainingFeatures, trainingLabels(:,d));