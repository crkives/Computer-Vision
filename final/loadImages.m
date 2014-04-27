%load images
tic;
imagesPos = readTrainingImages('..\..\train\pos\','.png');
imagesNeg = readTrainingImages('..\..\train\neg\','.jpg');
imagesNeg = [imagesNeg;readTrainingImages('..\..\train\neg\','.png')];
toc
