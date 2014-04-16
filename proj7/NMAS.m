function interestPoints = NMAS( N, R, threshold, octave )

    %N = 6;
    %threshold = -2.0;
    patchSize = 40 / 2^octave;
    [ row, col, val ] = find( R.*(R > threshold) );
    
    
    % Remove interest points that are within patch size of the image edge
    startRowVec = col - (1/2)*patchSize;
    endRowVec = col + ((1/2)*patchSize);
        
    startColVec = row - (1/2)*patchSize;
    endColVec = row + ((1/2)*patchSize);
    
    if( mod( patchSize, 2 ) == 0 )
        endRowVec = endRowVec - 1;
        endColVec = endCoVec - 1;
    end
    
    goodPoints = ( startRowVec >= 1 & endRowVec <= size( image, 1 ) & startColVec >= 1 & endColVec <= size( image, 2 ) );
    newRow = row( goodPoints == 1 );
    newCol = col( goodPoints == 1 );
    newVal = val( goodPoints == 1 );


    [ sortedVal, sortedIndecies ] = sort( newVal, 'descend' );
    sortedRow = newRow( sortedIndecies );
    sortedCol = newCol( sortedIndecies );

    pointsMatrix = [ sortedCol, sortedRow  ];
    distVector = pdist( pointsMatrix );
    distMatrix = squareform( distVector );

    pointRadii = zeros( size( newRow, 1 ), 1 );
    pointRadii( 1 ) = size( R, 1 );

    for i = 2: size( newRow, 1 )
        rowVecDist = distMatrix( i, : );
        strength = sortedVal( i );
        upperIndex = find( abs( sortedVal ) > abs( strength ), 1, 'last' );
        potentialVec = rowVecDist( 1:upperIndex );
        radius = min( potentialVec );
        pointRadii( i ) = radius;
    
    end

    [ sortedRadii, sortedRadiiIndicies ] = sort( pointRadii, 'descend' );
    finalRow = sortedRow( sortedRadiiIndicies );
    finalCol = sortedCol( sortedRadiiIndicies );
    finalVal = sortedVal( sortedRadiiIndicies );

    interestPoints = [ finalRow( 1:N, 1 ), finalCol( 1:N, 1 ), sortedRadii( 1:N, 1 ) , finalVal(1:N)];

end




    