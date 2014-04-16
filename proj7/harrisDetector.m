%type 1 = harris
%type 2 = harmonic
%type 3 = shi-Tomasi
function [R, M]=harrisDetector(image, n, k, type)
    [r, c, v] = size(image);
    if (v > 1)
        image = rgb2gray(image);
    end
    image = im2double(image);
      
    padNum = uint16(floor(n/2));
    padRow = zeros(padNum,c);
    padCol = zeros(r+(2*padNum),padNum);
    padImg = [padRow;image;padRow];
    padImg = [padCol,padImg,padCol];

    gauss = fspecial('gaussian', n, n/6);
    R = zeros(r,c);
    
    %dx = [0, 0, 0; 0, -1, 1; 0, 0, 0];
    %dy = [0, 0, 0; 0, -1, 0; 0, 1, 0];
    %ix = conv2(image, dx, 'same');
    %iy = conv2(image, dy, 'same');
    %filt = fspecial('gaussian', n, n/6);
    %image = imfilter(image, filt);

    %ix = imfilter(image, dx);
    %iy = imfilter(image, dy);
    [ix, iy] = imgradientxy(padImg);    
    %ix = single(ix) .* single(image);
    %iy = single(iy) .* single(image);
    %M = zeros(r,c,2,2); %hessian holder
    M = cell([r,c]);
    for x = 1:r
        startX = x;
        endX = startX+(n-1);
        for y = 1:c
            startY = y; 
            endY = startY+(n-1);
 
            w = conv2(single(padImg(startX:endX, startY:endY)), gauss);
            %iMat = [ix(x,y) * ix(x,y), ix(x,y) * iy(x,y); ix(x,y) * iy(x,y), iy(x,y) * iy(x,y)];
            tempMat = zeros(2,2);
            
            for i = 1:(n-1)
                for j = 1:(n-1)
                    curX = startX+i;
                    curY = startY+j;
                    curIx = ix(curX, curY);
                    curIy = iy(curX, curY);
                    
                    iMat = [curIx * curIx, curIx * curIy; curIx * curIy, curIy * curIy];
                    tempMat = tempMat + (w(i,j) * iMat);
                end
            end
            
            M{x,y} = tempMat;
            if (type == 1)
                R(x,y) = det(tempMat) - k*(trace(tempMat))^2;
            elseif (type == 2)
                R(x,y) = det(tempMat)/(trace(tempMat));
            elseif (type == 3)
                [~, val] = eig(tempMat);
                val = diag(val);
                R(x,y) = min(val);
            else
                %error
            end
        end
    end
      
end