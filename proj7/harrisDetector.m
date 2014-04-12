function R=harrisDetector(image, window, k)
    image = im2double(rgb2gray(image));
%     dx = [0, 0, 0; 0, -1, 1; 0, 0, 0];
%     dy = [0, 0, 0; 0, -1, 0; 0, 1, 0];
    n = window;
%     filt = fspecial('gaussian', n, n/6);
%     image = imfilter(image, filt);
    
%     ix = imfilter(image, dx);
%     iy = imfilter(image, dy);
    [ix, iy] = imgradientxy(image);
%     iMat = [ix * ix, ix * iy; ix * iy, iy * iy];
    
      
    [r, c] = size(image);
    padNum = uint16(floor(n/2));
    padRow = zeros(padNum,c);
    padCol = zeros(r+(2*padNum),padNum);
    padImg = [padRow;image;padRow];
    padImg = [padCol,padImg,padCol];

    padImg=im2double(padImg);
    m = zeros(r,c,2,2);
    gauss = fspecial('gaussian', n, n/6);
    R = zeros(r,c);
    
    for x = 1:r
        startX = uint32(x+padNum) - uint32(floor(n/2));
        endX = uint32(x+padNum) + uint32(floor(n/2));
        for y = 1:c
            startY = uint32(y+padNum) - uint32((floor(n/2))); 
            endY = uint32(y+padNum) + uint32((floor(n/2)));
            
            w = padImg(startX:endX, startY:endY) .* gauss;
            iMat = [ix(x,y) * ix(x,y), ix(x,y) * iy(x,y); ix(x,y) * iy(x,y), iy(x,y) * iy(x,y)];
            tempMat = zeros(2,2);
            
            for i = 1:n
                for j = 1:n
                    tempMat = tempMat + (w(i,j) * iMat);
                end
            end
            
            %m(x,y,:,:) = (sumGauss * iMat);
            R(x,y) = det(tempMat) - k*(trace(tempMat)).^2;
        end
    end
      
end