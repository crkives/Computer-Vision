function [ descriptors ] = MOPS( image, interestPoints, octave )
    descriptors = zeros(size(interestPoints));
    patchSize = 40 / 2^octave;
    
    % Realign the image so that the dominant eigenvector is along
    % the horizontal
    % First, calculate the eigenvectors of the image
    image = rgb2gray(image);
    image_double = double(image);
    [evec, eval] = eig(image_double);
    
    dominantEigVec = evec(:,1)
    
    % rotate the image so that the dominant eigenvector is horizontal.
    % ???
    angle = -radtodeg(atan(???));
    image = imrotate(image, angle);
    
    % for each interest point
    % extract a patch around it (the size of the patch is patchSize x 
    %      patchSize)
    % resample the patch to 8x8
    % normalize the patch
    for idx = 1:numel(interestPoints)
        x = interestPoints(i,1);
        y = interestPoints(i,2);
        
        % create a patch of patchSize x patchSize of pixels around
        % interest point
        
        
        % resize the patch to be 8 x 8
        if ( patchSize < 8)
            %patch = interp2(...);
        end
        if ( patchSize > 8)
            patch = imresize(patch, [8 8]);
        
        % normalize
        avg = ones(8) .* mean(patch);
        stdDev = ones(8) .* std(patch);
        patch = patch - avg;
        patch = patch ./ stdDev;
        % save in descriptors
        descriptors(idx) = patch;
        
end