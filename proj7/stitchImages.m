% Master Image Stitching Function
function stitchedImage = stitchImages( path, fileExt)

    % Global Properties
    ipNumber = 50; % the number of interestPoints desired after NMAS
    ipPerTransform = 6; % the number of interest points needed per affine transform
    corrThreshold = 0.5; % value of the cross correlation threshold
    n = 4; % the number of octaves to use
    
    % Read images into a cell array
    fname = dir( strcat( path, fileExt ) );
    numberImages = length(fname);
    imagesArray = cell( numberImages, 1 );
    %dah = 'at the top'
    %numberImages
    for index = 1:numberImages
        
        im = imread( strcat( path, fname(index).name ) );
        imagesArray{ index } = im;
        
    end
    

    % Scale each image to n different octaves scaled images
    % are stored into a cell array where each row is the
    % set of all images at the same scale and each column
    % is the same image at n different scales
    
    % 2D cell array to store all images at each scale
    scaledImagesArray = cell(4, numberImages);
    
    % Loop over images generating sa scaling pyramind, see [xx]
    for index = 1:numberImages
        
        image = imagesArray{ index };
        pyramid = multiscale( image, n );
        scaledImagesArray(:, index) = pyramid;
        
    end
    
    % END generating scaled images
    
    % Generate the descriptors for each image, storing the set
    % of descriptors
    
    % Current ocatave or scale being used, must loop through 0 to 3
    % octaves.
    for octave = 0:n-1
        allDescriptors = []; % this is a matrix containing the concat of all descriptors for a given octave
        %dah = 'Before loop'
        %numberImages
        % Loop over each image at a given octave getting that images
        % descriptors.  Then store the descriptors in a "matrix accumulator"
        % called allDescriptors.
        for index = 1:numberImages
            %dah = 'in loop'
            image = scaledImagesArray{ octave + 1, index };
            %dah = 'image size' 
            %size( image )
            %imshow( image );
            [strengthMat, hessians] = harrisDetector( image, 6, 0.04, 1);
            interestPoints = NMAS( ipNumber, strengthMat, octave );
            descriptors = MOPS( image, interestPoints, octave, hessians );
            allDescriptors = [ allDescriptors; descriptors ];

        end
    
        % TODO: Code below is for later use when actually stitching
        %mapping = interestPointMatching( descriptors, ipNumber, ipPerTransform, corrThreshold );
        %transform = buildTransformMat( mapping );
        %transformedImage = applyTransformation( image, transform );
    end
        

end