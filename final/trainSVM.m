%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TRAINSVM - trains a support vector machine given observations, values,
%            and a kernel function
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ARGS:
% X - matrix of observations (each col an observation)
% Y - a corresponding matrix the matching classes for the observations
%       first class:   1
%       second class: -1
% kernelFunction - the kernel function to use for the svm
%                  ARGS:
%                   X - matrix of observations
%                   xNew - individual new observation
%                  OUTPUT:
%                   features - matrix where rows are kernel(Xi,xNew)
%OUTPUT:
% predictor - the predictor function
%             ARGS:
%              xNew - the new observation of which to predict the class
%             OUTPUT:
%              class - a scalar, if -1 then second class, else 1 for first
%                      class
function [ predictor ] = trainSVM( X, Y, kernelFunction )

    y_pairwise = Y'*Y;
    
    % ===================================================
    % Generate kernal matrix H
    % ===================================================
    
    % get dimensions of kernel matrix
    [ numRows, numCols ] = size( X );
    % Create empty kernel martrix
    kernelMatrix = zeros( numCols, numCols );
    
    % Insert kernel values by observation in kernel matrix
    % where each column represents the value of the kernel function 
    % evaluated at each observation in the set agains the single
    % observation corresponding to that column.
    tic
    for index = 1:size(X,2)
        kernelMatrix(index, : ) = linearKernelFunction( X, X(:, index) );
    end
    talk = 'build kernel matrix using loop'
    toc
    
    %tic
    %X_RepCells = mat2Cell(X, numRows, numCols);
    %X_RepCells = repmat(X_RepCells,[1 numCols]);
    %X_ObsCells = num2cell(X, 1);
    %kernelMatrix = arrayfun(@linearKernelFunction, X_RepCells, X_ObsCells, 'UniformOutput', false);
    %kernelMatrix = reshape(kernelMatrix, numCols, numCols);
    %talk = 'built kernel matrix using arrayfun'
    %toc
    
    kernelMatrix = y_pairwise .* kernelMatrix;
    % Linear terms of the target function for optimization
    linearTerms = -ones( numCols );
    slackTerm = 0.01;
    % Calculate the Lagrange multipliers by optimizing the kernel
    % function's dual with linear terms of -1 and no equality constraint of
    % Sum over i of classification * lagrange multiplier equal to 0 (i.e.
    % Sum_i( y_i*a_i ) = 0 )
    tic
    lagrangeMultipliers = quadprod( kernelMatrix, linearTerms, [], [], Y, 0, 0, slackTerm );
    talk = 'time for optimization:'
    toc
    
    tic
    % May have problems here with orientation of vectors from quadprod
    supportVectorsIndices = (lagrangeMultipliers > 0);
    supportVectors = X(:, supportVectorsIndices);
    supportLabels = Y( supportVectorsIndices );
    supportLagrangians = lagrangeMultipliers( supportVectorsIndices );
    
    [SVRows SVCols] = size(supportVectors);
    supportKernelMatrix = zeros (SVCols, SVCols);
    for index = 1:SVCols
        supportKernelMatrix(index, :) = linearKernelFunction(supportVectors, supportVectors(:, index) );
    end
    lagrangeY = supportLagrangians .* supportLabels;
    lagrangeYMat = repmat(lagrangeY, [SVRows 1]);
    lagrangeYSupportMat = bsxfun(@times, lagrangeYMat, supportKernelMatrix);
    rowSumOfLagrangeYSupportMat = sum(lagrangeYSupportMat, 2);
    bias = (1/SVCols) * sum(supportLabels - rowSumOfLagrangeYSupportMat);
    talk = 'calculated the bias:'
    toc

    predictor = @(xNew) signum( sum(lagrangeMultipliers .* Y .* kernelFunction(X, xNew)) + bias);
end
