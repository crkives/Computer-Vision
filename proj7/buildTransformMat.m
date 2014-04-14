function transform=buildTransformMat(corrVec)
%note: corrVec = nx4 mat of the form [(x1,y1),(x2,y2)] points.  x1,y1 refer to a point in
    %im1 and x2,y2 refer to a point in im2
    
    [n,~] = size(corrVec);
    mat = [];
    vec = corrVec(:,3:4);
    for i=1:n
       x1 = corrVec(1,1);
       y1 = corrVec(1,2);
       index = (2*i)-1;
       mat(index,:) = [x1,y1,0,0,1,0];
       mat(index+1,:) = [0,0,x1,y1,0,1];        
    end
    
    aVec = mat\vec;
    trasformVec = aVec(:,size(aVec,2)-2);
    transform = reshape(trasformVec, size(trasformVec,2)/2,size(trasformVec,2)/2,1);
    translationVec = aVec(:,size(aVec,2)-1:size(aVec,2));
    transform = [transform, translationVec(:)];
    transform = [transform; zeros(1,size(transform,2)-1),1];
end