function outIm = hogNormalizeIm(im)    
    im = double(im);
    
    [~, ~, sizez] = size(im);
    
    for i = 1:sizez
        %reduce gamma
        im(:,:,i) = im(:,:,i).^(1/2);
    end
    outIm = im;
end