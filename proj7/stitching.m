function outIm = stitching(im1,im2, transform)
    translate = transform(1:2,3);
        
    [im1x, im1y] = size(im1);
    [im2x, im2y] = size(im2);
    
    cornerTL = transform * [1,1,1]';%top left corner
    cornerTR = transform * [1,im2y,1]';
    cornerBL = transform * [im2x,1,1]';
    cornerBR = transform * [im2x,im2y,1]';
    
    corners = [[1,1,1]',cornerTL,cornerTR, cornerBL, cornerBR,[im1x,im1y,1]'];
    maxXY = max(corners, [], 2);
    minXY = min(corners, [], 2);
        
    transform(1:2,2) = [0;0];
    im2 = imwarp(im2, affine2d(transform));
    
    %place first image
    newIm1 = zeros((minXY(1)-1) + maxXY(1),(minXY(2)-1)+maxXY(2));
    im1XOffset = abs(minXY(1)-1);    
    im1YOffset = abs(minXY(2)-1);
    
    startX = 1+im1XOffset;
    endX = 1+im1XOffset + im1x;
    startY = 1+im1YOffset;
    endY = 1+im1YOffset + im1y;
    newIm1(startX:endX, startY:endY) = im1;
    
    %place secondary image
    newIm2 = zeros((minXY(1)-1) + maxXY(1),(minXY(2)-1)+maxXY(2));
    im2XOffset = translate(1);    
    im2YOffset = translate(2);
    
    startX = 1+im2XOffset;
    endX = 1+im2XOffset + im2x;
    startY = 1+im2YOffset;
    endY = 1+im2YOffset + im2y;
    newIm2(startX:endX, startY:endY) = im2;
    
    outIm = imfuse(newIm1, newIm2);
end