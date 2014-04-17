function transform=buildTransformMat(corrVec)
%note: corrVec = nx4 mat of the form [(x1,y1),(x2,y2)] points.  x1,y1 refer to a point in
    %im1 and x2,y2 refer to a point in im2
    
    [n,~] = size(corrVec);
    mat = [];
    vec = corrVec(:,3:4);
    newVec = size(2*n,1);
    for i=1:n
       x1 = corrVec(i,1);
       y1 = corrVec(i,2);
       index = (2*i)-1;
       mat(index,:) = [x1,y1,0,0,1,0];
       mat(index+1,:) = [0,0,x1,y1,0,1];
       
       index = 2*(i-1);
       newVec(index+1) = vec(i,1);
       newVec(index+2) = vec(i,2);
    end
    
    newVec = newVec';
    aVec = mat\newVec;
    
    transformVec = aVec(1:size(aVec,1)-2,:);
    transform = reshape(transformVec, size(transformVec,1)/2,size(transformVec,1)/2,1);
    translationVec = [-1*aVec(size(aVec,1)-1);aVec(size(aVec,1),:)];
    transform = [transform, translationVec(:)];
    transform = [transform; zeros(1,size(transform,2)-1),1];
end