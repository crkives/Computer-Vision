function outIm = hogNormalizeIm(im, useLAB)
    %colorTransform = makecform('srgb2lab');
    %lab = applycform(im, colorTransform);
    
    im = double(im);
    
    [~, ~, sizez] = size(im);
    
    for i = 1:sizez
        %im(:,:,i) = histeq(im(:,:,i)); normalize?
        %reduce gamma
        %im(:,:,i) = im(:,:,i).^(1/2);
    end
    outIm = im;
end