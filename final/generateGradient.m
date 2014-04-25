function [outGradient,test]=generateGradient(im)
    gradx = [-1, 0, 1];
    grady = [1;  0;-1];
    [sizex, sizey, sizez] = size(im);
    
    totGradientsX = zeros(sizex,sizey,sizez);
    totGradientsY = zeros(sizex,sizey,sizez);
    for i=1:sizez
        %possibly use conv2?
        imGradX = imfilter(im2double(im(:,:,i)),gradx);
        imGradY = imfilter(im2double(im(:,:,i)),grady);
                
        totGradientsX(:,:,i) = imGradX;
        totGradientsY(:,:,i) = imGradY;
        %imshow(imGradX); figure;
        %imshow(imGradY); figure;
    end
    
    %normalize first?
    [~, maxInds] = max(sqrt(totGradientsX.^2 + totGradientsY.^2),[],3);
    test = im(maxInds);
    outGradient(:,:,1) = totGradientsX;
    outGradient(:,:,2) = totGradientsY;
    
    
    %NOTE: seems that our output here is incorrect
end