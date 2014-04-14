function out = applyTransformation(im, affineTransform)
    [r,c] = size(im);
    [xi,yi] = meshgrid(1:r,1:c);
    affineTransform = inv(affineTransform);
    xx = (affineTransform(1,1)*xi+affineTransform(1,2)*yi+affineTransform(1,3))./(affineTransform(3,1)*xi+affineTransform(3,2)*yi+affineTransform(3,3));
    yy = (affineTransform(2,1)*xi+affineTransform(2,2)*yi+affineTransform(2,3))./(affineTransform(3,1)*xi+affineTransform(3,2)*yi+affineTransform(3,3));
    out = uint8(interp2(im,xx,yy));
end