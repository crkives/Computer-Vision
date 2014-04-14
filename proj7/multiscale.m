function pyramid = multiscale(im, n)
    image = rgb2gray(im);
    pyramid = cell(n);
    [r,c] = size(image);
    
    gn = 6;
    gauss = fspecial('gaussian', gn, gn/6);
    [xi, yi] = meshgrid(1:r, 1:c);
    
    newIm = image;
    pyramid{1} = newIm;
    for i = 1:(n-1)
       newIm = interp2(single(newIm), 2*xi-(r/2),2*yi-(c/2));
       newIm = imfilter(newIm, gauss);
       pyramid{i+1} = uint8(newIm);
    end
end