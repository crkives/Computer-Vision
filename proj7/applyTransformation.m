function out = applyTransformation(im, affineTransform)
    out = imwarp(im, affine2d(affineTransform));
end