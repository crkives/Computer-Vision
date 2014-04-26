%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LINEARKERNELFUNCTION - linear kernel of observations ( dot(a,b) + 1 )
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ARGS:
% X - matirx of observations (each col an observation)
% xNew - individual new observation
%OUTPUT:
% features - matrix where rows are kernel(Xi,xNew)
function [ features ] = linearKernelFunction( X, xNew )
    numCols = size(X,2);
    % repeat the new x the same number of times as the number of
    % observations
    xNewVec = repmat(xNew, [1 numCols]);
    % take the dot product of each row of our matrices (also add 1 as the
    % constant to our linear kernel)
    features = dot(X, xNewVec, 1) + 1;
end

