function R=harrisDetector(image, n, k)
    [r, c, v] = size(image);
    if (v > 1)
        image = rgb2gray(image);
    end
    %image = im2double(image);
    
    %dx = [0, 0, 0; 0, -1, 1; 0, 0, 0];
   % dy = [0, 0, 0; 0, -1, 0; 0, 1, 0];
%     filt = fspecial('gaussian', n, n/6);
%     image = imfilter(image, filt);
    
    %ix = imfilter(image, dx);
    %iy = imfilter(image, dy);
    [ix, iy] = imgradientxy(image);    
    ix = single(ix) .* single(image);
    iy = single(iy) .* single(image);
      
    padNum = uint16(floor(n/2));
    padRow = zeros(padNum,c);
    padCol = zeros(r+(2*padNum),padNum);
    padImg = [padRow;image;padRow];
    padImg = [padCol,padImg,padCol];

    gauss = fspecial('gaussian', n, n/6);
    R = zeros(r,c);
    
    for x = 1:r
        startX = x;
        endX = startX+(n-1);
        for y = 1:c
            startY = y; 
            endY = startY+(n-1);
 
            w = single(padImg(startX:endX, startY:endY)) .* gauss;
            iMat = [ix(x,y) * ix(x,y), ix(x,y) * iy(x,y); ix(x,y) * iy(x,y), iy(x,y) * iy(x,y)];
            tempMat = zeros(2,2);
            
            for i = 1:n
                for j = 1:n
                    tempMat = tempMat + (w(i,j) * iMat);
                end
            end
            tempMat
            
            R(x,y) = det(tempMat) - k*(trace(tempMat)).^2;
        end
    end
      
end