%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% MOPS - creates descriptors for all interest points in an image
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ARGS:
% image - the image the interest points come from
% interestPoints - an n x 2 matrix, each row contains the x and y of 
%                  an interest point
% octave - an integer representing the octave to analyze
% hessians - a [r c 2 2] matrix holding a hessian for every pixel in the
%            image
%OUTPUT:
% descriptors- an [n 8 8] matrix where n is the number of interest points
%              basically a matrix holding a descriptor for each interest
%              point
function [ descriptors ] = MOPS( image, interestPoints, octave, hessians )
    d = size(interestPoints);
    numInterestPoints = d(1);
    descriptors = [];
    patchSize = uint8( 40 / 2^octave );
    %image = rgb2gray(image);
    %image = im2double(image);
    
    for idx = 1:numInterestPoints
        currentPoint = interestPoints(idx,:);
        x = currentPoint(1);
        y = currentPoint(2);
        
        % Realign the image so that the dominant eigenvector of the hessian
        % is along the horizontal
        [evec, evals] = eig(hessians{x,y});
    
        % The dominant eigenvector is the first eigenvector returned by eig
        dominantEigVec = evec(:,1);
    
        % rotate the image so that the dominant eigenvector is horizontal.
        angle = double( -radtodeg(atan(dominantEigVec(2)/dominantEigVec(1))) );
        rotImage = imrotate(image, angle);
    
        % for each interest point
        % 1) extract a patch around it (the size of the patch is patchSize x 
        %      patchSize)
        % 2) resize the patch to 8x8
        % 3) normalize the patch
        
        % create a patch of patchSize x patchSize of pixels around
        % interest point
        halfPatch = ceil( (1/2)*patchSize );
        
        startRow = y - halfPatch;
        endRow = y + halfPatch;
        
        startCol = x - halfPatch;
        endCol = x + halfPatch;
        
        % if the patchsize is even, the interest point can not be
        % at the center of the patch. It will be the top left point
        % of the lower right quadrant
        if(mod(patchSize,2) == 0)
            endRow = endRow - 1;
            endCol = endCol - 1;
        end
        
        % Skip patch if its dimensions exceed matrix dimensions
        if( startRow >= 1 && endRow <= size( image, 1 ) && startCol >= 1 && endCol <= size( image, 2 ) && startCol < endCol && startRow < endRow )
            
            
            % 1) extract out the patch from the rotated image
            patch = rotImage(startRow:endRow, startCol:endCol);
            % 2) resize the patch to be 8 x 8
            %    if the image is larger than 8 x 8, it will be sized down
            %    if the image is smaller than 8 x 8, it will be interpolated
            %       using bicubic interpolation
            patch = im2double(imresize(patch, [8 8]));

            % 3) normalize
            avg = mean2(patch);
            stdDev = std2(patch);
            patch = patch - avg;
            if stdDev ~= 0
                patch = patch ./ stdDev;
            else
                patch(1,1) = 1;
            end
            % save in descriptors
            descriptors = [ descriptors; patch ];
        else
            error( 'Holy Hart Picks Batman, we have not eliminated all the bad corners!' );
        end
    end
        
end