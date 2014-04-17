function pyramid = multiscale(im, n)
    image = rgb2gray(im);
    pyramid = cell(n,1);
    
    gn = 6;
    gauss = fspecial('gaussian', gn, gn/6);
  
    pyramid{1} = image;
    for i = 1:(n-1)
        scale = 1 / 2^i;
        newIm = imresize(image, scale);
        newIm = imfilter(newIm, gauss);
        pyramid{i+1} = uint8(newIm);
    end
end