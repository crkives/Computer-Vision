function pyramid = multiscale(im, n)
    image = rgb2gray(im);
    pyramid = cell(n);
    
    gn = 6;
    gauss = fspecial('gaussian', gn, gn/6);
  
    pyramid{1} = image;
    for i = 1:(n-1)
        scale = 1 / 2^n;
        newIm = imresize(image, scale);
        newIm = imfilter(newIm, gauss);
        pyramid{i+1} = uint8(newIm);
    end
end