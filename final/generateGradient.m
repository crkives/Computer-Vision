function outGradient=generateGradient(im)
    gradx = [-1, 0, 1];
    grady = [1;  0;-1];
    [sizex, sizey, sizez] = size(im);
    
    totGradientsX = zeros(sizex,sizey,sizez);
    totGradientsY = zeros(sizex,sizey,sizez);
    normVec = zeros(sizez,1);
    for i=1:sizez
        %possibly use conv2?
        imGradX = imfilter(im2double(im(:,:,i)),gradx);
        imGradY = imfilter(im2double(im(:,:,i)),grady);
                
        totGradientsX(:,:,i) = imGradX;
        totGradientsY(:,:,i) = imGradY;
        magnitudeMat = sqrt(imGradX.^2 + imGradY.^2);
        
        normVec(i) = norm(magnitudeMat);
    end
    
    [~, maxInds] = max(normVec);
    outGradient(:,:,1) = totGradientsX(:,:,maxInds);
    outGradient(:,:,2) = totGradientsY(:,:,maxInds);
end